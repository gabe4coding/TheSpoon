//
//  ViewController.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import UIKit
import RxSwift
import RxDataSources

class RestaurantsViewController: UITableViewController, ViewModelBindable {
    
    private struct Constants {
        static let barTitle = "TheSpoon"
        static let rowHeight: CGFloat = 370
        static let cellId = "Cell"
        
        static let noInternetMsg = "Internet offline, check your device connection."
        static let genericMsg = "An error occured, please try again."
    }
    
    private var disposables: DisposeBag = DisposeBag()
    
    var viewModel: RestaurantsViewModel?
    
    init(viewModel: RestaurantsViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = Constants.barTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let itemBar = UIBarButtonItem.menuButton(self,
                                                 action: #selector(selectListOrder),
                                                 imageName: "sort",
                                                 tint: .darkGray)
        
        navigationItem.rightBarButtonItem = itemBar
        
        view = UIView()
        view.backgroundColor = .white
        tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.separatorStyle = .none
        tableView.dataSource = nil
        
        tableView.register(RestaurantTableViewCell.self,
                           forCellReuseIdentifier: Constants.cellId)
        
        viewModel?
            .objects()
            .bind(to: tableView.rx.items(cellIdentifier: Constants.cellId,
                                         cellType: RestaurantTableViewCell.self))
            { _, model, cell in
                cell.bind(to: RestaurantItemViewModel(model: model))
            }
            .disposed(by: disposables)
        
        viewModel?
            .errorOccured()
            .subscribe {[weak self] error in
                self?.errorOccured(error: error)
            }
            .disposed(by: disposables)
    }
    
    func errorOccured(error: ErrorType) {
        let alertController = UIAlertController(title: "Warning",
                                                message: errorMessage(error),
                                                preferredStyle: .alert)
        
        let retryButton = UIAlertAction(title: "Retry",
                                        style: .default,
                                        handler: {[weak self] _ in
            self?.viewModel?.reload()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(cancelButton)
        alertController.addAction(retryButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func errorMessage(_ error: ErrorType) -> String {
        switch error {
        case .offline:
            return Constants.noInternetMsg
        default:
            return Constants.genericMsg
        }
    }
    
    @objc func selectListOrder() {
        let alertController = UIAlertController(title: "Sort by",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let sortByName = UIAlertAction(title: "Name",
                                       style: .default,
                                       handler: {[weak self] (action) -> Void in
            self?.viewModel?.sort(by: .name)
        })
        
        let sortByRating = UIAlertAction(title: "Rating",
                                         style: .default,
                                         handler: {[weak self] (action) -> Void in
            self?.viewModel?.sort(by: .rating)
        })
        
        let resetSort = UIAlertAction(title: "Reset",
                                      style: .default,
                                      handler: {[weak self] (action) -> Void in
            self?.viewModel?.sort(by: .none)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(sortByName)
        alertController.addAction(sortByRating)
        alertController.addAction(resetSort)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

