//
//  Extensions+Thread.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 30/12/21.
//

import Foundation

extension Thread {
  var isRunningXCTest: Bool {
    for key in self.threadDictionary.allKeys {
      guard let keyAsString = key as? String else {
        continue
      }
    
      if keyAsString.split(separator: ".").contains("xctest") {
        return true
      }
    }
    return false
  }
}
