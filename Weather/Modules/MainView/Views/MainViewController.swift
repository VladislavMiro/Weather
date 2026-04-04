//
//  ViewController.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 01.12.2023.
//

import UIKit
import Combine

final class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - Private properties
    
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
    
    //MARK: - Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }
    
    //MARK: - Overriden methods
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        viewModel.selectedTab.send(item.tag)
    }

}

//MARK: - Extension with private methods

private extension MainViewController {
    
    func configuration() {
        view.backgroundColor = Colors.background
        tabBarConfiguration()
        navBarConfiguration()
    }
    
    func tabBarConfiguration() {
        let standartAppearance = UITabBarAppearance()
        let itemAppearance = UITabBarItemAppearance()
        let scrollAppearance = UITabBarAppearance()
        
        standartAppearance.configureWithOpaqueBackground()
        scrollAppearance.configureWithOpaqueBackground()
        
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: Colors.normalText ?? .systemGray]
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: Colors.selectedText ?? .systemBlue]
        itemAppearance.normal.iconColor = Colors.normalItemIcon
        itemAppearance.selected.iconColor = Colors.selectedItemIcon
        
        standartAppearance.stackedLayoutAppearance = itemAppearance
        standartAppearance.backgroundColor = Colors.standartTabViewBackground

        scrollAppearance.stackedLayoutAppearance = itemAppearance
        scrollAppearance.backgroundColor = Colors.tabViewScrollAppearanceBackground
        
        UITabBar.appearance().standardAppearance = standartAppearance
        UITabBar.appearance().scrollEdgeAppearance = scrollAppearance
    }
    
    func navBarConfiguration() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = Colors.navBarBackground
        appearance.titleTextAttributes = [.foregroundColor: Colors.navBarTitle ?? .white]
        appearance.largeTitleTextAttributes = [.foregroundColor: Colors.navBarLargeTitle ?? .white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = Colors.navBarTint
    }
    
}

//MARK: - Extensuion with private subobjects

private extension MainViewController {
    
    enum Colors {
        static let normalText: UIColor? = R.color.secondFontColor()
        static let selectedText: UIColor? = R.color.fontColor()
        static let background: UIColor? = R.color.backgroundColor()
        static let normalItemIcon: UIColor? = R.color.secondFontColor()
        static let selectedItemIcon: UIColor? = R.color.fontColor()
        static let standartTabViewBackground: UIColor? = R.color.secondBackgroundColor()?.withAlphaComponent(0.95)
        static let tabViewScrollAppearanceBackground: UIColor? = R.color.secondBackgroundColor()
        static let navBarBackground: UIColor? = R.color.backgroundColor()
        static let navBarTitle: UIColor? = R.color.fontColor()
        static let navBarLargeTitle: UIColor? = R.color.fontColor()
        static let navBarTint: UIColor? = R.color.fontColor()
    }
    
}
