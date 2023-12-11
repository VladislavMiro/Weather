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
        tabBarConfiguration()
        navBarConfiguration()
    }
    
    
    //MARK: - Public methods
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        viewModel.selectedTab.send(item.tag)
    }
    
    //MARK: - Private methods
    
    private func tabBarConfiguration() {
        let standartAppearance = UITabBarAppearance()
        let itemAppearance = UITabBarItemAppearance()
        let scrollAppearance = UITabBarAppearance()
        
        standartAppearance.configureWithOpaqueBackground()
        scrollAppearance.configureWithOpaqueBackground()
        
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: Resources.Colors.secondFontColor ?? .systemGray]
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: Resources.Colors.fontColor ?? .systemBlue]
        itemAppearance.normal.iconColor = Resources.Colors.secondFontColor
        itemAppearance.selected.iconColor = Resources.Colors.fontColor
        
        standartAppearance.stackedLayoutAppearance = itemAppearance
        standartAppearance.backgroundColor = Resources.Colors.secondBackgroundColor?.withAlphaComponent(0.95)

        scrollAppearance.stackedLayoutAppearance = itemAppearance
        scrollAppearance.backgroundColor = Resources.Colors.secondBackgroundColor
        
        UITabBar.appearance().standardAppearance = standartAppearance
        UITabBar.appearance().scrollEdgeAppearance = scrollAppearance
    }
    
    private func navBarConfiguration() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = Resources.Colors.backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: Resources.Colors.fontColor ?? .white]
        appearance.largeTitleTextAttributes = [.foregroundColor: Resources.Colors.fontColor ?? .white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = Resources.Colors.fontColor
    }

}
