//
//  WeekForecastView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine

final class WeekForecastView: UIView {
    
    //MARK: - Private fields
    
    private let tableView: UITableView =  {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.register(WeekDayCell.self, forCellReuseIdentifier: WeekDayCell.cellIdentifier)
        view.backgroundColor = Resources.Colors.secondBackgroundColor
        view.isScrollEnabled = false
        view.allowsSelection = false
        view.separatorColor = Resources.Colors.secondFontColor
        view.rowHeight = 50
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Week Forecast"
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = Resources.Colors.secondFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Public fields
    
    public let viewModel: WeekForecastViewModelProtocol
    
    //MARK: - Initialaziers
    
    public init(viewModel: WeekForecastViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        configuration()
        constraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func configuration() {
        layer.cornerRadius = 15
        backgroundColor = Resources.Colors.secondBackgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(headerLabel)
        addSubview(tableView)
    }
    
    private func constraints() {
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 5),
            headerLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 15),
            headerLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.layoutMarginsGuide.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            self.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
    
    private func bind() {
        viewModel.refreshData.sink { [unowned self] _ in
            self.tableView.reloadData()
        }.store(in: &cancelable)
    }

}

//MARK: - TableView Configuration

extension WeekForecastView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.output.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeekDayCell.cellIdentifier, for: indexPath) as! WeekDayCell
        
        cell.setData(data: viewModel.output[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
}
