//
//  ApiService.swift
//  SimpleWeather
//
//  Created by Aknyazev on on 10/10/20.
//

import UIKit
import CoreLocation

protocol ApiServiceType {
    func getWeather(longitude: CGFloat, latitude: CGFloat, completion: @escaping (Result<WeatherModel, Error>)->Void) -> URLSessionTask
    func getForecast(longitude: CGFloat, latitude: CGFloat, completion: @escaping (Result<ForecatsModel, Error>)->Void) -> URLSessionTask
}

class ApiService: ApiServiceType {
        
    private let session: URLSession = URLSession(configuration: .default)
    private static let apiKey = "fdb5f3172f2d718c945ee2081374de45"

    private func fetch<T>(from url: URL, completion: @escaping (Result<T, Error>)->Void) -> URLSessionTask where T: Decodable {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, _, error) in
            let decoder = JSONDecoder()
            if let data = data, let model = try? decoder.decode(T.self, from: data) {
                completion(.success(model))
            } else if let error = error {
                completion(.failure(error))
            } else {
                // something went wrong
            }
        }
        defer {
            task.resume()
        }
        return task
    }

    func getWeather(longitude: CGFloat, latitude: CGFloat, completion: @escaping (Result<WeatherModel, Error>)->Void) -> URLSessionTask {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(ApiService.apiKey)")!
        return fetch(from: url, completion: completion)
    }
    
    func getForecast(longitude: CGFloat, latitude: CGFloat, completion: @escaping (Result<ForecatsModel, Error>)->Void) -> URLSessionTask {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(ApiService.apiKey)")!
        return fetch(from: url, completion: completion)
    }
    
}
