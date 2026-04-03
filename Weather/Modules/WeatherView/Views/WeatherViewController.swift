//
//  WeatherViewController.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine
import SnapKit

final class WeatherViewController: UIViewController {

    //MARK: - Private properties

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
    
    //MARK: - Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        constraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.didFinish()
    }
    
}

//MARK: - Extension with private methods

private extension WeatherViewController {
    
    func configuration() {
        view.backgroundColor = Resources.Colors.backgroundColor
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        dayForecast.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        weekForecast.translatesAutoresizingMaskIntoConstraints = false
        airConditions.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(headerView)
        scrollView.addSubview(dayForecast)
        scrollView.addSubview(weekForecast)
        scrollView.addSubview(airConditions)
        
        scrollView.frame = view.bounds
        
        scrollView.refreshControl?.tintColor = Resources.Colors.secondFontColor
        
        scrollView.refreshControl?.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
    
        view.addSubview(scrollView)
    }
    
    func constraints() {
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(view.snp.leadingMargin)
            $0.trailing.equalTo(view.snp.trailingMargin)
            $0.height.equalTo(LayoutConstants.headerViewHeight)
        }
        
        dayForecast.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottomMargin)
            $0.horizontalEdges.equalTo(headerView.snp.horizontalEdges)
        }
        
        weekForecast.snp.makeConstraints {
            $0.top.equalTo(dayForecast.snp.bottomMargin)
                .offset(LayoutConstants.offset)
            $0.horizontalEdges.equalTo(dayForecast.snp.horizontalEdges)
        }
        
        airConditions.snp.makeConstraints {
            $0.top.equalTo(weekForecast.snp.bottomMargin)
                .offset(LayoutConstants.offset)
            $0.horizontalEdges.equalTo(weekForecast.snp.horizontalEdges)
            $0.bottom.equalToSuperview()
                .inset(LayoutConstants.offset)
        }
        
    }
    
    func bind() {
        viewModel.isRefreshing.sink { [weak self] _ in
            self?.scrollView.refreshControl?.endRefreshing()
        }.store(in: &cancelable)
        
        viewModel.error.sink { [weak self] error in
            self?.showErrorAlert(message: error)
        }.store(in: &cancelable)
            
        viewModel.data.sink { [weak self] data in
            self?.headerView.viewModel.data.send(data)
            self?.dayForecast.viewModel.data.send(data)
            self?.weekForecast.viewModel.data.send(data)
            self?.airConditions.viewModel.data.send(data)
        }.store(in: &cancelable)
        
    }
    
    @objc func startRefresh() {
        viewModel.loadData()
    }
    
    func showErrorAlert(message: String) {
        let view = UIAlertController(title: StringConstants.errorTitle, message: message, preferredStyle: .alert)
        
        view.addAction(.init(title: StringConstants.okButtonTitle, style: .default, handler: { [weak self] _ in
            guard let refreshing = self?.scrollView.refreshControl else { return }
            
            if refreshing.isRefreshing {
                refreshing.endRefreshing()
            }
        }))
        
        present(view, animated: true)
    }
    
}

//MARK: - Extension with private subobjects

private extension WeatherViewController {
    
    enum LayoutConstants {
        static let offset: CGFloat = 30
        static let headerViewHeight: CGFloat = 350
    }
    
    enum StringConstants {
        static let errorTitle: String = "Error"
        static let okButtonTitle: String = "OK"
    }
    
}
