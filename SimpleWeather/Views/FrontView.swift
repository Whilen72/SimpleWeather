//
//  FrontView.swift
//  SimpleWeather
//
//  Created by Aknyazev on 10/6/20.
//
import UIKit

class FrontView: UIView {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minMaxLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        countryLabel.text = nil
        temperatureLabel.text = nil
        weatherLabel.text = nil
        weatherImageView.image = nil
        minMaxLabel.text = nil
    }
}
