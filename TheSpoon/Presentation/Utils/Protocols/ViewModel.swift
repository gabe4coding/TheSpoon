//
//  ViewModel.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation

protocol ViewModel : AnyObject {}

protocol ViewModelBindable: AnyObject {
    associatedtype ViewModelType = ViewModel
    var viewModel: ViewModelType { get set }
}

protocol ItemViewModelBindable {
    func bind(to viewModel: ViewModel)
}
