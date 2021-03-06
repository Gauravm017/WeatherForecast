//
//  DaysTableCell.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import UIKit

class DaysTableCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
        
    var weatherDaysList: List? {
        didSet{
            guard let dayTime = weatherDaysList?.dtTxt,
                let iconName = weatherDaysList?.weather.first?.icon else {
                return
            }
            dateLabel.text = getDayString(getData: dayTime)
            weatherIconImageView.loadImageUsingCache(withUrl: String(format: "http://openweathermap.org/img/wn/%@@2x.png", iconName))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func getDayString(getData: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let formatDate = dateFormatter.date(from: getData),
            let dayCnt = formatDate.dayNumberOfWeek(),
            let day = Week(rawValue: dayCnt) else {
            return " "
        }
        return day.StringValue
    }
    
    func config(weather data: List, fahrenheitOrCelsius: FahrenheitOrCelsius) {
        weatherDaysList = data
        let emoji = fahrenheitOrCelsius.emoji
        switch fahrenheitOrCelsius {
        case .Celsius:
            tempMaxLabel.text = data.main.tempMax.makeCelsius() + emoji
            tempMinLabel.text = data.main.tempMin.makeCelsius() + emoji
        case .Fahrenheit:
            tempMaxLabel.text = data.main.tempMax.makeFahrenheit() + emoji
            tempMinLabel.text = data.main.tempMin.makeFahrenheit() + emoji
        }
    }
}

