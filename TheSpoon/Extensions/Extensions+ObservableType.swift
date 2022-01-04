//
//  Extensions+ObservableType.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

enum AppError: Error {
    case mappingFailed
}

extension ObservableType where Element == [Restaurant] {
    func mapToUIModel<T>() -> Observable<[T]> {
        flatMap { restaurants -> Observable<[T]> in
            let mapped: [T]? = restaurants.map()
            
            guard let result = mapped else {
                return Observable.error(AppError.mappingFailed)
            }
            
            return Observable.just(result)
        }
    }
}

extension ObservableType where Element == RequestAPI {
    
    func buildRequest() -> Observable<URLRequest> {
        flatMap { request -> Observable<URLRequest> in
            let urlBasePath: String = request.fullPath

            var components = URLComponents(string: urlBasePath)
            let pathParameters: [String: String] = request.queryParameters
            if !pathParameters.isEmpty {
                components?.queryItems = pathParameters.map { element in URLQueryItem(name: element.key, value: element.value) }
            }

            guard let url = components?.url else {
                return Observable<URLRequest>.error(APIError.invalidUrl)
            }

            var requestURL = URLRequest(url: url)
            requestURL.httpMethod = request.method.rawValue

            var headers: [String: String] = [:]

            if let jsonModel = request.bodyParameters,
               let jsonData = try? JSONSerialization.data(withJSONObject: jsonModel) {
                requestURL.httpBody = jsonData
                headers["Content-Type"] = "application/json"
            }
            
            headers.merge(request.customHeaders, uniquingKeysWith: { _, new in new })
            requestURL.allHTTPHeaderFields = headers
            requestURL.cachePolicy = .reloadIgnoringCacheData
            
            return Observable<URLRequest>.just(requestURL)
        }
    }
}

extension ObservableType where Element == RequestAPI {
    func decodeMock<T: Decodable>(named: String) -> Single<T> {
        Single<T>.create { observer in
            if let path = Bundle.main.path(forResource: named, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    let decoded = try jsonDecoder.decode(T.self, from: data)
                    observer(.success(decoded))
                    
                } catch {
                    observer(.failure(APIError.failedDecoding))
                }
            } else {
                observer(.failure(APIError.failedDecoding))
            }
            return Disposables.create()
        }
    }
}

