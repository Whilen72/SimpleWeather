//
//  WeatherModel.swift
//  SimpleWeather
//
//  Created by Aknyazev on 10/6/20.
//

import Foundation
import UIKit

struct WeatherModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather
        case base
        case main
        
        case temperature = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    struct Coordinates: Decodable {
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case latitude = "lat"
        }
        
        let longitude: CGFloat
        let latitude: CGFloat
    }

    let coordinates: Coordinates
    let weatherType: WeatherType
    let temperature: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
          
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        
        let main = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        self.temperature = (try main.decode(Double.self, forKey: .temperature)).rounded(toPlaces: 1)
        self.feelsLike = (try main.decode(Double.self, forKey: .feelsLike)).rounded(toPlaces: 1)
        self.tempMin = (try main.decode(Double.self, forKey: .tempMin)).rounded(toPlaces: 1)
        self.tempMax = (try main.decode(Double.self, forKey: .tempMax)).rounded(toPlaces: 1)
        
        let cloudys = try container.decode([CloudyModel].self, forKey: .weather)
        self.weatherType = WeatherType.type(from: cloudys[0].icon)
    }
}
