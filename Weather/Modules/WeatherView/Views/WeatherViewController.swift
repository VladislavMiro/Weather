//
//  WeatherViewController.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine

final class WeatherViewController: UIViewController {

    //MARK: - Private fields

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.refreshControl = UIRefreshControl()
        
        return view
    }()
    
    private let headerView: HeaderView
    private let dayForecast: DayForecastView
    private let weekForecast: WeekForecastView
    private let airConditions: AirConditionView
    
    private let viewModel: WeatherViewModelProtocol
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initializers
    
    public init(headerView: HeaderView, dayForecastView: DayForecastView, weekForecast: WeekForecastView, airConditionView: AirConditionView, viewModel: WeatherViewModelProtocol) {
        
        self.viewModel = viewModel
        self.headerView = headerView
        self.dayForecast = dayForecastView
        self.weekForecast = weekForecast
        self.airConditions = airConditionView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        constraints()
        bind()
        viewModel.loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.didFinish()
    }
    
    //MARK: - Private methods
    
    private func configuration() {
        view.backgroundColor = Resources.Colors.backgroundColor
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        dayForecast.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        weekForecast.translatesAutoresizingMaskIntoConstraints = false
        airConditions.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(headerView)
        scrollView.addSubview(dayForecast)
        scrollView.addSubview(weekForecast)
        scrollView.addSubview(airConditions)
        
        scrollView.refreshControl?.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
    
        view.addSubview(scrollView)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 350),
            
            dayForecast.topAnchor.constraint(equalTo: headerView.layoutMarginsGuide.bottomAnchor),
            dayForecast.trailingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.trailingAnchor, constant: -15),
            dayForecast.leadingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.leadingAnchor, constant: 15),
            
            weekForecast.topAnchor.constraint(equalTo: dayForecast.layoutMarginsGuide.bottomAnchor, constant: 30),
            weekForecast.leadingAnchor.constraint(equalTo: dayForecast.leadingAnchor),
            weekForecast.trailingAnchor.constraint(equalTo: dayForecast.trailingAnchor),
            
            airConditions.topAnchor.constraint(equalTo: weekForecast.layoutMarginsGuide.bottomAnchor, constant: 30),
            airConditions.leadingAnchor.constraint(equalTo: weekForecast.leadingAnchor),
            airConditions.trailingAnchor.constraint(equalTo: weekForecast.trailingAnchor),
            airConditions.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30)
        ])
    }
    
    private func bind() {
        viewModel.isRefreshing.sink { [unowned self] _ in
            self.scrollView.refreshControl?.endRefreshing()
        }.store(in: &cancelable)
        
        viewModel.error.sink { [unowned self] error in
            self.showErrorAlert(message: error)
        }.store(in: &cancelable)
        
        viewModel.data.subscribe(headerView.viewModel.data).store(in: &cancelable)
        viewModel.data.subscribe(dayForecast.viewModel.data).store(in: &cancelable)
        viewModel.data.subscribe(weekForecast.viewModel.data).store(in: &cancelable)
        viewModel.data.subscribe(airConditions.viewModel.data).store(in: &cancelable)
    }
    
    @objc private func startRefresh() {
        viewModel.loadData()
    }
    
    private func showErrorAlert(message: String) {
        let view = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        view.addAction(.init(title: "OK", style: .default, handler: { [weak self] _ in
            guard let refreshing = self?.scrollView.refreshControl else { return }
            
            if refreshing.isRefreshing {
                refreshing.endRefreshing()
            }
        }))
        
        present(view, animated: true)
    }
}
