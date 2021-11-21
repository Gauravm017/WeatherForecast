//
//  WeatherListSettingCell.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import UIKit

class WeatherListSettingCell: UITableViewCell {

    @IBOutlet weak var toggleButton: UIButton!
    
    private var fahrenheitOrCelsius: FahrenheitOrCelsius? {
        didSet {
            UserDefaults.standard.set(fahrenheitOrCelsius?.rawValue,
                                      forKey: UserInfo.fahrenheitOrCelsius
            )
        }
    }
    var delegate: fahrenheitOrCelsiusDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fetchFahrenheitOrCelsius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func fetchFahrenheitOrCelsius() {
        fahrenheitOrCelsius = UserInfo.getFahrenheitOrCelsius()
    }
    
    @IBAction func celsiusFahrenheitButtonClicked(_ sender: UIButton) {
        guard let fahrenheitOrCelsius = fahrenheitOrCelsius else {
            return
        }
        switch fahrenheitOrCelsius {
        case .Celsius:
            delegate?.selectFahrenheitOrCelsius(name: .Fahrenheit)
            self.fahrenheitOrCelsius = .Fahrenheit
        case .Fahrenheit:
            delegate?.selectFahrenheitOrCelsius(name: .Celsius)
            self.fahrenheitOrCelsius = .Celsius
        }
    }
    
    @IBAction func findCityButtonClicked(_ sender: UIButton) {
        let st = UIStoryboard.init(name: "SearchLocation", bundle: nil)
        guard let vc = st.instantiateViewController(withIdentifier: "SearchLocationVC") as? SearchLocationVC else {
            return
        }
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func webButtonClicked(_ sender: UIButton) {
        guard let webURL = URL(string: BaseURL.webURL) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(webURL)
        }
    }
}

