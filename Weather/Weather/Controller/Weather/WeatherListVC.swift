//
//  WeatherListVC.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import UIKit
import MapKit

class WeatherListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var allowPermission: Bool = false
    private var weather: [WeatherInfoModel] = [WeatherInfoModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var fahrenheitOrCelsius: FahrenheitOrCelsius? = UserInfo.getFahrenheitOrCelsius() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var myCities: [Coordinate] = [Coordinate]() {
        didSet {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.myCities),
                                      forKey: UserInfo.cities
            )
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshData),
                                 for: .valueChanged
        )
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        getCoordinate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        registerNib()
        createObserver()
        fetchCityList()
    }
    
    private func fetchCityList() {
        guard let cities = UserInfo.getCityList() else {
            return
        }
        myCities = cities
        DispatchQueue.global().async {
            self.myCities.forEach({
                self.getWeatherByCoordinate(latitude: $0.lat,
                                            longitude: $0.lon
                )
            })
        }
    }
    
    private func setupViewController() {
        tableView.addSubview(refreshControl)
        let inter = UIContextMenuInteraction(delegate: self)
        self.view.addInteraction(inter)
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
    }
    
    private func registerNib() {
        tableView.register(WeatherListCell.self)
        tableView.register(WeatherListSettingCell.self)
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectedCity),
                                               name: .selectCity,
                                               object: nil
        )
    }
    
    @objc private func selectedCity(notification: NSNotification) {
        guard let cityCoordinate = notification.object as? CLLocationCoordinate2D else {
            return
        }
        if !myCities.contains(Coordinate(lat: cityCoordinate.latitude.makeRound(),
                                        lon: cityCoordinate.longitude.makeRound())){
            getWeatherByCoordinate(latitude: cityCoordinate.latitude,
                                   longitude: cityCoordinate.longitude
            )
            myCities.append(Coordinate(lat: cityCoordinate.latitude.makeRound(),
                                       lon: cityCoordinate.longitude.makeRound())
            )
        }
    }
    
    @objc private func selectedFahrenheitOrCelsius(notification: NSNotification) {
        fahrenheitOrCelsius = notification.object as? FahrenheitOrCelsius
    }
    
    @objc private func refreshData() {
        guard let coordinate = currentLocation?.coordinate else {
            return
        }
        
        weather.removeAll()
        DispatchQueue.global().async {
            self.getWeatherByCoordinate(latitude: coordinate.latitude.makeRound(),
                                   longitude: coordinate.longitude.makeRound()
            )
            self.fetchCityList()
        }
    }
    
    private func getCoordinate() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func getWeatherByCoordinate(latitude lat: Double, longitude lon: Double) {
        APIManager.getWeatherByCoordinate(latitude: lat, longitude: lon) { [weak self] (model) in
            guard let self = self else {
                return
            }
            if let weatherModel = model{
                self.checkCurrentLocationOrNot(bodyData: weatherModel)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func checkCurrentLocationOrNot(bodyData: WeatherInfoModel) {
        guard let coordinate = currentLocation?.coordinate else {
            if !allowPermission {
                weather.append(bodyData)
            }
            return
        }
        if bodyData.name == weather.first?.name {
            return
        }
        if coordinate.latitude.makeRound() == bodyData.coord.lat,
            coordinate.longitude.makeRound() == bodyData.coord.lon {
            weather.insert(bodyData, at: 0)
        } else {
            weather.append(bodyData)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: TableView Deleagate and DataSource
extension WeatherListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherListCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? weather.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = WeatherListCellType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch cellType {
        case .City:
            let cell: WeatherListCell = tableView.dequeueReusableCell(for: indexPath)
            guard weather.count > 0,
                let fahrenheitOrCelsius = fahrenheitOrCelsius else {
                return UITableViewCell()
            }
            cell.config(weatherInfoData: weather[indexPath.row],
                        fahrenheitOrCelsius: fahrenheitOrCelsius
            )
            return cell
        case .Setting:
            let cell: WeatherListSettingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let st = UIStoryboard.init(name: "CurrentLocation", bundle: nil)
        guard let vc = st.instantiateViewController(withIdentifier: "FavoriteCitiesPageVC") as? FavoriteCitiesPageVC ,
            indexPath.section == 0 else {
            return
        }
        vc.weatherList = weather
        vc.startIndex = indexPath.row
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 && allowPermission ? false : true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if !allowPermission {
                myCities.remove(at: indexPath.row)
                weather.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let coordinate = weather[indexPath.row].coord
                myCities = myCities.filter {
                    $0.lat.makeRound() != coordinate.lat &&
                        $0.lon.makeRound() != coordinate.lon
                }
                weather.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

// MARK: CLLocationManagerDelegate
extension WeatherListVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            guard let myCurrentLocation = locationManager.location else {
                return
            }
            currentLocation = myCurrentLocation
            getWeatherByCoordinate(latitude: myCurrentLocation.coordinate.latitude.makeRound(),
                                   longitude: myCurrentLocation.coordinate.longitude.makeRound()
            )
            allowPermission = true
        } else {
            print("user denied authorization")
            allowPermission = false
        }
    }
}

extension WeatherListVC: UIContextMenuInteractionDelegate{
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: {
                                                    guard let indexPath = self.tableView.indexPathForRow(at: location),
                                                          let _ = self.tableView.cellForRow(at: indexPath) else {
                                                        return nil
                                                    }
                                                    guard let vc = UIStoryboard.init(name: "CurrentLocation", bundle: nil).instantiateViewController(withIdentifier: "FavoriteCitiesPageVC") as? FavoriteCitiesPageVC else {
                                                        return nil
                                                    }
                                                    //previewingContext.sourceRect = cell.frame
                                                    vc.weatherList = self.weather
                                                    vc.startIndex = indexPath.row
                                                    return vc
                                                }, actionProvider: nil)
        return config
    }
}

// MARK: SelectedFahrenheitOrCelsius
extension WeatherListVC: fahrenheitOrCelsiusDelegate {
    func selectFahrenheitOrCelsius(name: FahrenheitOrCelsius) {
        fahrenheitOrCelsius = name
    }
}

