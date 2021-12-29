//
//  AppDelegate.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dependencies = Dependecies()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Setup Dependency Injection
        InjectSettings.resolver = dependencies.container
        dependencies.registerComponents()
        
        let rootController = RestaurantsViewController(viewModel: RestaurantsViewModel())
        
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: rootController)
        window?.makeKeyAndVisible()
        
        return true
    }
}

