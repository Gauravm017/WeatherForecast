//
//  DetailTableCell.swift
//  Weather
//
//  Created by Gaurav Malik on 21/11/21.
//

import UIKit

class DetailTableCell: UITableViewCell {

    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftDescriptionLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightDescriptionLabel: UILabel!
    
    var weatherDetailData: WeatherInfoModel? {
        didSet{
            guard let speed = weatherDetailData?.wind.speed,
                let humidity = weatherDetailData?.main.humidity else {
                return
            }
            leftDescriptionLabel.text = "\(speed)"
            rightDescriptionLabel.text = "\(humidity)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        leftTitleLabel.text = "wind"
        rightTitleLabel.text = "humidity"

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
