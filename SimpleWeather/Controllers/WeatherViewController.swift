//
//  WXControllerViewController.swift
//  SimpleWeather
//
//  Created by Aknyazev on 10/6/20.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView?
    @IBOutlet weak var backgroundImageView: UIImageView!
    let frontView: FrontView = { Bundle(for: FrontView.self).loadNibNamed(String(describing: FrontView.self), owner: nil, options: nil)?.first as? FrontView }()!
   
    private var gradientLayer = CAGradientLayer()

    private let disposeBag = DisposeBag()
    private let viewModel: ViewModelType = ViewModel()

    // MARK: - UIViewContoller
    
    override func loadView() {
        super.loadView()
        frontView.frame = view.frame
        tableView.tableHeaderView = frontView
        tableView.register(UINib(nibName: String(describing: ForecastTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: ForecastTableViewCell.reuseIdentifier)
        tableView.separatorColor = UIColor(white: 1, alpha: 0.2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // https://stackoverflow.com/questions/51783408/how-to-gradient-a-background-of-a-tableview-in-swift
        if gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        let topColor = UIColor(red: 16.0/255.0, green: 12.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 57.0/255.0, green: 33.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = tableView.bounds
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Binding
    
    func bind(_ viewModel: ViewModelType) {
        viewModel.output.temperature.bind(to: frontView.temperatureLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.country.bind(to: frontView.countryLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.minMaxTemp.bind(to: frontView.minMaxLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.weatherImage.bind(to: frontView.weatherImageView.rx.image).disposed(by: disposeBag)
        viewModel.output.weatherTitle.bind(to: frontView.weatherLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.onReloadTable.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        viewModel.output.isLoading.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (flag) in
            if flag == false {
                self?.activityIndicatior?.removeFromSuperview()
            }
            self?.activityIndicatior?.isHidden = !flag
        }).disposed(by: disposeBag)
        viewModel.input.controllerDidSetup()
    }
}
 
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseIdentifier, for: indexPath) as! ForecastTableViewCell
        let model = viewModel.output.forecastElement(row: indexPath.row)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd - HH:mm"
        cell.dateLabel.text = formatter.string(from: model.date)
        cell.temperatureLabel.text = "\(model.temperature)°"
        cell.iconImageView.image = model.weatherType.icon
        
        return cell
    }
}

