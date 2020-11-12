//
//  WeatherType.swift
//  SimpleWeather
//
//  Created by Aknyazev on 10/10/20.
//

import Foundation
import UIKit

enum WeatherType: String {
    case clearSky
    case fewClouds
    case scatteredClouds
    case brokenClouds
    case showerRain
    case rain
    case thunderstorm
    case snow
    case mist

    static func type(from string: String) -> WeatherType {        
        switch string {
        case "01n", "01d":
            return .clearSky
        case "02n", "02d":
            return .fewClouds
        case "03n", "03d":
            return .scatteredClouds
        case "04n", "04d":
            return .brokenClouds
        case "09n", "09d":
            return .showerRain
        case "10n", "10d":
            return .rain
        case "11n", "11d":
            return .thunderstorm
        case "13n", "13d":
            return .snow
        case "50n", "50d":
            return .mist
        default:
            return .clearSky
        }
    }
    
    var description: String {
        switch self {
        case .clearSky:
            return "Clear sky"
        case .fewClouds:
            return "Few Clouds"
        case .scatteredClouds:
            return "Scattered clouds"
        case .brokenClouds:
            return "Broken clouds"
        case .showerRain:
            return "Shower rain"
        case .rain:
            return "Rain"
        case .thunderstorm:
            return "Thunderstorm"
        case .snow:
            return "Snow"
        case .mist:
            return "Mist"
        }
    }
    
    var icon: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
