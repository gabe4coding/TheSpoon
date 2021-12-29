//
//  Extensions+Error.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 29/12/21.
//

import Foundation

extension Error {
    func mapNetworkError() -> ErrorType {
        switch (self as NSError).code {
        case 13:
            return .offline
        case NSURLErrorTimedOut:
            return .timeout
        default: return .generic
        }
    }
}
