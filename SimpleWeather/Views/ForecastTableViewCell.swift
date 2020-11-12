//
//  ForecastTableViewCell.swift
//  SimpleWeather
//
//  Created by Aknyazev on 10/6/20.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    static let reuseIdentifier = String.init(describing: ForecastTableViewCell.self)
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
