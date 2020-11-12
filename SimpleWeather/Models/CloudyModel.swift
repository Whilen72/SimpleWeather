//
//  CloudyModel.swift
//  SimpleWeather
//
//  Created by Aknyazev on 10/10/20.
//

import Foundation

struct CloudyModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case description
        case icon
    }

    let description: String
    let icon: String
}
