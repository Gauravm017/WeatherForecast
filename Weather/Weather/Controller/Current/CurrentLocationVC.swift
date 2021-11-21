//
//  CurrentLocationVC.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import UIKit

class CurrentLocationVC: UIViewController {

    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var fadeViewContraint: NSLayoutConstraint!
    
    var currentWeatherData: WeatherInfoModel?
    var currentIndex: Int = 0
    var totalPage: Int = 0
    private var fiveDayWeatherData: FiveDayWeather? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var fahrenheitOrCelsius: FahrenheitOrCelsius? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerNib()
        fetchData()
        fetchFahrenheitOrCelsius()
    }
    
    private func fetchFahrenheitOrCelsius() {
        fahrenheitOrCelsius = UserInfo.getFahrenheitOrCelsius()
    }
    
    private func fetchData() {
        guard let coordinate = currentWeatherData?.coord else {
            return
        }
        self.get5DayWeatherByCoordinate(latitude: coordinate.lat,
                                        longitude: coordinate.lon
        )
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerNib() {
        tableView.register(CurrentLocationTimesCell.self)
        tableView.register(DaysTableCell.self)
        tableView.register(DetailTableCell.self)
    }
    
    private func get5DayWeatherByCoordinate(latitude lat: Double, longitude lon: Double) {
        APIManager.get5DayWeatherByCoordinate(latitude: lat, longitude: lon){ [weak self] (model) in
            guard let self = self else {
                return
            }
            if let forecastModel = model{
                DispatchQueue.main.async {
                    self.fiveDayWeatherData = forecastModel
                }
            }
        }
    }
    
    @IBAction func listButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func webButtonClicked(_ sender: UIButton) {
        guard let webURL = URL(string: BaseURL.webURL) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(webURL,
                                      options: [:],
                                      completionHandler: nil
            )
        } else {
            UIApplication.shared.openURL(webURL)
        }
    }
    
    private func updateUI() {
        guard let weather = currentWeatherData,
            let fahrenheitOrCelsius = fahrenheitOrCelsius else {
            return
        }
        
        switch fahrenheitOrCelsius {
        case .Celsius:
            tempLabel.text = weather.main.temp.makeCelsius()
            maxTempLabel.text = weather.main.tempMax.makeCelsius()
            minTempLabel.text = weather.main.tempMin.makeCelsius()
        case .Fahrenheit:
            tempLabel.text = weather.main.temp.makeFahrenheit()
            maxTempLabel.text = weather.main.tempMax.makeFahrenheit()
            minTempLabel.text = weather.main.tempMin.makeFahrenheit()
        }
        
        cityNameLabel.text = weather.name
        dayLabel.text = calculateDay()
        weatherStatusLabel.text = weather.weather.first?.description
        pageControl.numberOfPages = totalPage
        pageControl.currentPage = currentIndex
    }
    
    private func calculateDay() -> String {
        guard let timezone = currentWeatherData?.timezone,
            let date = Date().dayNumberOfWeek(time: timezone),
            let day = Week(rawValue: date) else {
            return ""
        }
        return day.StringValue
    }
}

extension CurrentLocationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = fiveDayWeatherData?.list else {
            return 1
        }
        return list.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CurrentCellType(rawValue: indexPath.row) ?? .DaysCell
        if cellType.cellType == CurrentLocationTimesCell.self {
            let cell: CurrentLocationTimesCell = tableView.dequeueReusableCell(for: indexPath)
            guard let weatherData = currentWeatherData?.weather else {
                return UITableViewCell()
            }
            cell.weatherList = weatherData
            return cell
        } else if cellType.cellType == DetailTableCell.self {
            let cell: DetailTableCell = tableView.dequeueReusableCell(for: indexPath)
            guard let weatherData = currentWeatherData else {
                return UITableViewCell()
            }
            cell.weatherDetailData = weatherData
            return cell
        } else {
            let cell: DaysTableCell = tableView.dequeueReusableCell(for: indexPath)
            guard let list = fiveDayWeatherData?.list,
                let fahrenheitOrCelsiusData = fahrenheitOrCelsius else {
                    return UITableViewCell()
            }
            cell.config(weather: list[indexPath.row - 2],
                        fahrenheitOrCelsius: fahrenheitOrCelsiusData
            )
            return cell
        }
    }
}
