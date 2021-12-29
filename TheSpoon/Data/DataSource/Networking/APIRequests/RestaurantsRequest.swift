//
//  RestaurantsRequest.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation

struct RestaurantsRequest: RequestAPI {
    var baseUrl: String = "https://alanflament.github.io"
    var fullPath: String {
        "\(baseUrl)\(path)"
    }
    var path: String = "/TFTest/test.json"
    var method: APIHTTPMethod = .get
    var customHeaders: [String : String] = [:]
    var queryParameters: [String : String] = [:]
    var bodyParameters: [String : Any]? = nil
    var useMockWithName: String? = nil
}
