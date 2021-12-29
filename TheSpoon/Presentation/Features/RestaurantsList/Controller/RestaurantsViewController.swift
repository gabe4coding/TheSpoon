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
    
    private struct ViewConst {
        //Table View
        static let rowHeight: CGFloat = 370
        static let cellId = "Cell"
        static let sortImg = "sort"
        
        //Localizable eventually mapped using a CMS or equivalent.
        static let txtTitle = "TheSpoon"
        static let txtNoInternetMsg = "Internet offline, check your device connection."
        static let txtGenericMsg = "An error occured, please try again."
        static let txtNameSorting = "Name"
        static let txtRatingSorting = "Rating"
        static let txtResetSorting = "Reset"
        static let txtCancel = "Cancel"
        static let txtRetry = "Retry"
        static let txtWarning = "Warning"
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
        
        setupNavigationController()
        setupSubviews()
    }
    
    func setupNavigationController() {
        
        navigationController?.navigationBar.topItem?.title = ViewConst.txtTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let itemBar = UIBarButtonItem.menuButton(self,
                                                 action: #selector(selectListOrder),
                                                 imageName: ViewConst.sortImg,
                                                 tint: .darkGray)
        
        navigationItem.rightBarButtonItem = itemBar
    }
    
    func setupSubviews() {
        view = UIView()
        view.backgroundColor = .white
        tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = ViewConst.rowHeight
        tableView.separatorStyle = .none
        tableView.dataSource = nil
        
        tableView.register(RestaurantTableViewCell.self,
                           forCellReuseIdentifier: ViewConst.cellId)
        
        viewModel?
            .objects()
            .bind(to:
                tableView.rx.items(cellIdentifier: ViewConst.cellId,
                           cellType: RestaurantTableViewCell.self)
                  
            ) { _, model, cell in
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
        let alertController = UIAlertController(title: ViewConst.txtWarning,
                                                message: errorMessage(error),
                                                preferredStyle: .alert)
        
        alertController.addAction(
            UIAlertAction(title: ViewConst.txtCancel,style: .cancel, handler: nil)
        )
        
        alertController.addAction(
            UIAlertAction(title: ViewConst.txtRetry, style: .default, handler:
                { [weak self] _ in
                    self?.viewModel?.reload()
                }
            )
        )
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func errorMessage(_ error: ErrorType) -> String {
        switch error {
        case .offline:
            return ViewConst.txtNoInternetMsg
        default:
            return ViewConst.txtGenericMsg
        }
    }
    
    @objc func selectListOrder() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(
            UIAlertAction(title: ViewConst.txtNameSorting, style: .default, handler:
                { [weak self] (action) -> Void in
                    self?.viewModel?.sort(by: .name)
                }
            )
        )
        
        alertController.addAction(
            UIAlertAction(title: ViewConst.txtRatingSorting, style: .default, handler:
                { [weak self] (action) -> Void in
                    self?.viewModel?.sort(by: .rating)
                }
            )
        )
        
        alertController.addAction(
            UIAlertAction(title: ViewConst.txtResetSorting, style: .default, handler:
                { [weak self] (action) -> Void in
                    self?.viewModel?.sort(by: .none)
                }
            )
        )
        
        alertController.addAction(
            UIAlertAction(title: ViewConst.txtCancel, style: .cancel, handler: nil)
        )
        
        self.present(alertController, animated: true, completion: nil)
    }
}

