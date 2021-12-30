//
//  LocalStorageDataSource.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

enum StorageError: Error {
    case notFound
}

class LocalStorageDataSource: LocalStorageDataSourceInterface {
    private lazy var userDefault: UserDefaults = {
        #if DEBUG
        if Thread.current.isRunningXCTest {
            let userDefault = UserDefaults(suiteName: #file)
            userDefault?.removePersistentDomain(forName: #file)
            return userDefault!
        }
        #endif
        
        return UserDefaults.standard
    }()

    func object<T: Any>(forKey tag: String) -> Single<T> {
        Single<T>.create {[weak self] observer in
            if let obj = (self?.userDefault.object(forKey: tag) as? T) {
                observer(.success(obj))
            } else {
                observer(.failure(StorageError.notFound))
            }

            return Disposables.create()
        }
    }

    func set(value: Any?, forKey tag: String) -> Completable  {
        Completable.create { [weak self] observer in
            self?.userDefault.set(value, forKey: tag)
            observer(.completed)
            return Disposables.create()
        }
    }

    func removeObject(forKey tag: String) -> Completable {
        Completable.create { [weak self] observer in
            self?.userDefault.removeObject(forKey: tag)
            observer(.completed)
            return Disposables.create()
        }
    }
}
