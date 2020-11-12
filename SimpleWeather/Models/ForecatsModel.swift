//
//  ForecatsModel.swift
//  SimpleWeather
//
//  Created by Aknyazev on 10/10/20.
//

import Foundation

struct ForecatsModel: Decodable {
    
    struct ForecatsElement: Decodable {
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case main
            case temperature = "temp"
            case weather
        }

        let date: Date
        let temperature: Double
        let weatherType: WeatherType
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let main = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
            
            self.temperature = (try main.decode(Double.self, forKey: .temperature)).rounded(toPlaces: 1)
            
            let cloudys = try container.decode([CloudyModel].self, forKey: .weather)
            self.weatherType = WeatherType.type(from: cloudys[0].icon)
            
            let timestamp = try container.decode(TimeInterval.self, forKey: .date)
            self.date = Date(timeIntervalSince1970: timestamp)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case list
    }
    
    let list: [ForecatsElement]
}
