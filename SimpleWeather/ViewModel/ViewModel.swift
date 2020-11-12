//
//  ViewModel.swift
//  SimpleWeather
//
//  Created by Aknyazev on 10/10/20.
//

import Foundation
import RxSwift
import CoreLocation

protocol ViewModelInput {
    func controllerDidSetup()
}

protocol ViewModelOutput {
    var temperature: PublishSubject<String> { get }
    var country: PublishSubject<String> { get }
    var weatherImage: PublishSubject<UIImage?> { get }
    var weatherTitle: PublishSubject<String> { get }
    var minMaxTemp: PublishSubject<String> { get }
    var onReloadTable: PublishSubject<Void> { get }
    var isLoading: PublishSubject<Bool> { get }
    func numberOfRows(in section: Int) -> Int
    func numberOfSections() -> Int
    func forecastElement(row: Int) -> ForecatsModel.ForecatsElement
}

protocol ViewModelType {
    var input: ViewModelInput { get }
    var output: ViewModelOutput { get }
}

class ViewModel: ViewModelType, ViewModelInput, ViewModelOutput {
     
    // MARK: - ViewModelType
    
    var input: ViewModelInput { return self }
    var output: ViewModelOutput { return self }
    
    // MARK: - Public interface
    
    let temperature = PublishSubject<String>()
    let country = PublishSubject<String>()
    let weatherImage = PublishSubject<UIImage?>()
    let weatherTitle = PublishSubject<String>()
    let onReloadTable = PublishSubject<Void>()
    let minMaxTemp = PublishSubject<String>()
    var isLoading = PublishSubject<Bool>()

    
    // MARK: - Private interface
    
    private let disposeBag = DisposeBag()
    
    private lazy var apiService = ApiService()
    private lazy var locationService: LocationServiceType = LocationService()
    
    private weak var currentWeaterTask: URLSessionTask?
    private weak var currentForecastTask: URLSessionTask?
    
    private var forecats: ForecatsModel? = nil

    // MARK: - Methods
    
    func controllerDidSetup() {
        locationService.location.subscribe(onNext: { [weak self] (location) in
            self?.getWeatherInfo(for: location)
        }).disposed(by: disposeBag)
        locationService.locality.subscribe(onNext: { [weak self] (locality) in
            self?.country.onNext(locality)
        }).disposed(by: disposeBag)
        locationService.startUpdatingLocation()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let forecats = forecats else { return 0}
        return forecats.list.count
    }
    
    func forecastElement(row: Int) -> ForecatsModel.ForecatsElement {
        guard let forecats = forecats else { fatalError() }
        return forecats.list[row]
    }
    
    // MARK: - Private methods
    
    private func getWeatherInfo(for location: CLLocation) {
        currentWeaterTask?.cancel()
        currentForecastTask?.cancel()
        
        isLoading.onNext(true)
        
        let longitude: CGFloat = CGFloat(location.coordinate.longitude)
        let latitude: CGFloat = CGFloat(location.coordinate.latitude)
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        var finalResult:(WeatherModel?, ForecatsModel?) = (nil, nil)
        
        group.notify(queue: .main) { [weak self] in
            guard
                let self = self,
                let weather = finalResult.0,
                let forecast = finalResult.1
            else { return }
            
            self.isLoading.onNext(false)
            
            self.temperature.onNext("\(weather.temperature)°")
            self.weatherImage.onNext(weather.weatherType.icon)
            self.weatherTitle.onNext(weather.weatherType.description)
            self.minMaxTemp.onNext(" \(weather.tempMin)° / \(weather.tempMax)°")

            self.forecats = forecast
            self.onReloadTable.onNext(())
        }
        
        currentWeaterTask = apiService.getWeather(longitude: longitude, latitude: latitude, completion: { (result) in
            switch result {
            case .success(let model):
                finalResult.0 = model
            default:
                break
            }
            group.leave()
        })
        currentForecastTask = apiService.getForecast(longitude: longitude, latitude: latitude, completion: { (result) in
            switch result {
            case .success(let model):
                finalResult.1 = model
            default:
                break
            }
            group.leave()
        })
    }
}
