//
//  ViewController.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 01.12.2023.
//

import UIKit
import Combine

final class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - Private fields
    
    private let viewModel: MainViewModelProtocol
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initialaizers
    
    public init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }
    
    //MARK: - Private methods
    
    private func configuration() {
        
        UITabBar.appearance().backgroundColor = Resources.Colors.secondBackgroundColor
        UITabBar.appearance().tintColor = Resources.Colors.fontColor
        UITabBar.appearance().unselectedItemTintColor = Resources.Colors.secondFontColor
        
    }
    
    //MARK: - Public methods
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        viewModel.selectedTab.send(item.tag)
    }

}
