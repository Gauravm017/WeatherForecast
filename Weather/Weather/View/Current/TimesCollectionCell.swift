//
//  TimesCollectionCell.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import UIKit

class TimesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(weather data: Weather) {
        descriptionLabel.text = data.description
        iconImageView.loadImageUsingCache(withUrl: String(format: "http://openweathermap.org/img/wn/%@@2x.png", data.icon))
    }
}
