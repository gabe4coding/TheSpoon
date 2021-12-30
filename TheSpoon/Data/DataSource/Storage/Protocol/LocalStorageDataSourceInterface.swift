//
//  LocalStorageDataSourceInterface.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

protocol LocalStorageDataSourceInterface {
    
    func object<T>(forKey tag: String) -> Single<T>
    func set(value: Any?, forKey tag: String) -> Completable
    func removeObject(forKey tag: String) -> Completable
}
