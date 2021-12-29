//
//  NetworkingDataSource.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift
import RxAlamofire

///The protocol of the Data Source which owns the execution of REST API request.
protocol NetworkingDataSourceInterface {
    ///Performs an API request
    ///- Parameter request Encapsulate all the information to execute an API request toward the Cloud.
    ///- Returns The response of the request, otherwise an error.
    func perform<T: Decodable>(request: RequestAPI) -> Single<T>
}
