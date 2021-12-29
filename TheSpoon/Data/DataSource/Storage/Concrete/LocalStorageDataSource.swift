//
//  LocalStorageDataSource.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

class LocalStorageDataSource: LocalStorageDataSourceInterface {
    private let userDefault = UserDefaults.standard

    func object<T: Any>(forKey tag: String) -> Single<T?> {
        Single<T?>.create {[weak self] observer in
            observer(.success(self?.userDefault.object(forKey: tag) as? T))
            return Disposables.create()
        }
    }

    func set(value: Any?, forKey tag: String) -> Completable  {
        Completable.create { [weak self] observer in
            self?.userDefault.set(value, forKey: tag)
            self?.userDefault.synchronize()
            observer(.completed)
            return Disposables.create()
        }
    }

    func removeObject(forKey tag: String) -> Completable {
        Completable.create { [weak self] observer in
            self?.userDefault.removeObject(forKey: tag)
            self?.userDefault.synchronize()
            observer(.completed)
            return Disposables.create()
        }
    }
}
