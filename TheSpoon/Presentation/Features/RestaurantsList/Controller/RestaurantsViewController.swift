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
    }
    
    var viewModel: RestaurantsViewModel! = RestaurantsViewModel()
    
    private var disposables: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = Constants.barTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let itemBar = UIBarButtonItem(image: UIImage(named:"sort"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(selectListOrder))
        itemBar.tintColor = .darkGray
        
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
        
        viewModel
            .objects()
            .bind(to: tableView.rx.items(cellIdentifier: Constants.cellId,
                                         cellType: RestaurantTableViewCell.self))
            { _, model, cell in
                cell.bind(to: RestaurantItemViewModel(model: model))
            }
            .disposed(by: disposables)
    }
    
    @objc func selectListOrder() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let sortByName = UIAlertAction(title: "By Name",
                                       style: .default,
                                       handler: {[weak self] (action) -> Void in
            self?.viewModel.sort(by: .name)
        })
        
        let sortByRating = UIAlertAction(title: "By Rating",
                                         style: .default,
                                         handler: {[weak self] (action) -> Void in
            self?.viewModel.sort(by: .rating)
        })
        
        let resetSort = UIAlertAction(title: "Reset",
                                      style: .default,
                                      handler: {[weak self] (action) -> Void in
            self?.viewModel.sort(by: .none)
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

