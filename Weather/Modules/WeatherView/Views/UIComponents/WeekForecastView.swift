//
//  WeekForecastView.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import UIKit
import Combine
import SnapKit

final class WeekForecastView: UIView {
    
    //MARK: - Private properties
    
    private let tableView: UITableView =  {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.register(WeekDayCell.self, forCellReuseIdentifier: WeekDayCell.cellIdentifier)
        view.backgroundColor = Colors.tableViewBackground
        view.isScrollEnabled = false
        view.allowsSelection = false
        view.separatorColor = Colors.tableViewSeparator
        view.rowHeight = LayoutConstants.tableViewRowHeight
        view.clipsToBounds = true
        view.backgroundView?.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        
        label.text = StringConstants.headerLabel
        label.font = Fonts.headerLabel
        label.textAlignment = .left
        label.textColor = Colors.headerLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Public properties
    
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

}

//MARK: - Extension with UITableViewDelegate & UITableViewDataSource implementations

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
        return LayoutConstants.tableViewRowHeight
    }
    
}

//MARK: - Extension with private methods

private extension WeekForecastView {
 
    func configuration() {
        layer.cornerRadius = LayoutConstants.superViewCornerRadius
        backgroundColor = Colors.background
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(headerLabel)
        addSubview(tableView)
    }
    
    func constraints() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(LayoutConstants.superViewHeight)
        }
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
                .offset(LayoutConstants.headerLabelTopOffset)
            $0.leading.equalToSuperview()
                .offset(LayoutConstants.headerLabelLeadingOffset)
            $0.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom)
                .offset(LayoutConstants.tableViewTopOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
                .inset(LayoutConstants.tableViewBottomOffset)
        }
        
    }
    
    func bind() {
        viewModel.refreshData.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancelable)
    }
    
}


//MARK: - Extension with private subobjects

private extension WeekForecastView {
    
    enum LayoutConstants {
        static let tableViewTopOffset: CGFloat = 15.0
        static let tableViewRowHeight: CGFloat = 54.0
        static let tableViewBottomOffset: CGFloat = 5.0
        static let superViewCornerRadius: CGFloat = 15.0
        static let superViewHeight: CGFloat = 465.0
        static let headerLabelTopOffset: CGFloat = 10.0
        static let headerLabelLeadingOffset: CGFloat = 15.0
    }
    
    enum Fonts {
        static let headerLabel: UIFont = .boldSystemFont(ofSize: 16)
    }
    
    enum StringConstants {
        static let headerLabel: String = R.string.localizable.weekForecastViewTitleLabel()
    }
    
    enum Colors {
        static let background: UIColor? = R.color.secondBackgroundColor()
        static let tableViewBackground: UIColor? = R.color.secondBackgroundColor()
        static let tableViewSeparator: UIColor? = R.color.secondFontColor()
        static let headerLabelText: UIColor? = R.color.secondFontColor()
    }
    
}
