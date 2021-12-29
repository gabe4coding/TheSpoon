//
//  Dependencies.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import Swinject

protocol InjectableDependecy {
    func registerComponents(container: Container)
}

struct InjectSettings {
    static var resolver: Resolver?
}

class Dependecies {
    let container: Container

    init(customContainer: Container? = nil) {
        container = customContainer ?? Container()
    }

    func registerComponents() {
        let dependecies: [InjectableDependecy] = [AppDependencies()]
        dependecies.forEach { [weak self] in
            guard let self = self else { return }
            $0.registerComponents(container: self.container)
        }
    }

    func register<T>(type: T.Type, factory: @escaping (Resolver) -> T) {
        container.register(type, factory: factory)
    }
}

class AppDependencies: InjectableDependecy {
    func registerComponents(container: Container) {
        container.register(LocalStorageDataSourceInterface.self) { _ in
            LocalStorageDataSource()
        }
        
        container.register(NetworkingDataSourceInterface.self) { _ in
            NetworkingDataSource()
        }
        
        container.register(RestaurantsRepositoryInterface.self) { _ in
            RestaurantsRepository()
        }
        
        container.register(RestaurantsUseCaseInterface.self) { _ in
            RestaurantsUseCase()
        }
        .inObjectScope(.container)
    }
}
