//
//  NetworkingDataSource.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift
import RxAlamofire

class NetworkingDataSource: NetworkingDataSourceInterface {
    
    private struct Constants {
        static let responseQueue: String = "TSAPI-Queue"
    }
    
    func perform<T: Decodable>(request: RequestAPI) -> Single<T> {
        #if DEBUG
        if Thread.current.isRunningXCTest {
            if let mock = request.useMock {
                return Observable.just(request)
                    .decodeMock(named: mock)
            }
        }
        #endif
        
        return Observable.just(request)
            .buildRequest()
            .flatMap { urlRequest -> Observable<T> in
                RxAlamofire
                    .requestDecodable(urlRequest)
                    .observe(on: SerialDispatchQueueScheduler.init(internalSerialQueueName: Constants.responseQueue))
                    .debug()
                    .flatMap { _, decoded in
                        Observable<T>.just(decoded)
                    }
            }
            .asSingle()
    }
}

