//
//  RestaurantTableViewCell.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import UIKit
import RxSwift
import Swinject

class RestaurantTableViewCell: UITableViewCell, ItemViewModelBindable {
    
    //MARK: Constants
    private struct ViewConst {
        static let imageHeight: CGFloat = 210
        static let ratingWidth: CGFloat = 80
        static let squaredBtnFavSize: CGFloat = 35
        static let enabledFavBtnName: String = "solid-heart"
        static let disabledFavBtnName: String = "empty-heart"
        static let avgPriceText: String = "Average price"
    }
    
    //MARK: Properties
    private var viewModel: RestaurantItemViewModel? = nil
    private var disposable: Disposable? = nil
    
    //MARK: Subviews and Constraints
    ///Name of the restaurant
    lazy var name: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor.titleColor
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    ///Address of the restaurant
    lazy var address: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor.subtitleColor
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    ///Pricing info of the restaurant
    @UsesAutoLayout
    var pricingView: PricingView = PricingView(frame: .zero)
    
    ///Rating info of the restaurant
    @UsesAutoLayout
    var rating: RatingView = RatingView(frame: .zero)
    
    ///Image of the restaurant
    lazy var imgView: UIImageView = {
        @UsesAutoLayout
        var image = UIImageView()
        image.layer.cornerRadius = 5.0
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        image.contentMode = .scaleAspectFill
        return image
    }()
    private lazy var imgViewConstraints: [NSLayoutConstraint] = {
        [
            imgView.topAnchor
                .constraint(equalTo: contentView.topAnchor,
                            constant: Layout.topPadding),
            
            imgView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor,
                            constant: Layout.leftPadding),
            
            imgView.trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor,
                            constant: Layout.rightPadding),
            
            imgView.heightAnchor
                .constraint(equalToConstant: ViewConst.imageHeight)
        ]
    }()
    
    ///Cuisine type of the restaurant
    lazy var cuisine: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.subtitleColor
        label.layer.opacity = 0.4
        return label
    }()
    private lazy var cuisineConstraints: [NSLayoutConstraint] = {
        [
            cuisine.leadingAnchor
                .constraint(equalTo: imgView.leadingAnchor),
            
            cuisine.topAnchor
                .constraint(equalTo: imgView.bottomAnchor,
                            constant: Layout.topPadding)
        ]
    }()
    
    ///Toggle favourite button of the restaurant.
    lazy var favouriteBtn: UIButton = {
        @UsesAutoLayout
        var button = UIButton(type: .custom)
        button.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        if let image = UIImage(named: ViewConst.disabledFavBtnName)?
            .withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
        }
        
        if let image = UIImage(named: ViewConst.enabledFavBtnName)?
            .withRenderingMode(.alwaysTemplate){
            button.setImage(image, for: .selected)
        }
        button.imageView?.tintColor = .white
        button.backgroundColor = .lightGray
        button.imageEdgeInsets = UIEdgeInsets(top: 8,left: 6,bottom: 7,right: 6)
        button.addTarget(self,
                         action: #selector(self.favouriteBtnTapped),
                         for: .touchUpInside)
        button.layer.cornerRadius = ViewConst.squaredBtnFavSize / 2
        return button
    }()
    private lazy var favouriteBtnConstraints: [NSLayoutConstraint] = {
        [
            favouriteBtn.topAnchor
                .constraint(equalTo: imgView.topAnchor,
                            constant: Layout.topPadding),
            
            favouriteBtn.trailingAnchor
                .constraint(equalTo: imgView.trailingAnchor,
                            constant: Layout.rightPadding),
            
            favouriteBtn.widthAnchor
                .constraint(equalToConstant: ViewConst.squaredBtnFavSize),
            
            favouriteBtn.heightAnchor
                .constraint(equalToConstant: ViewConst.squaredBtnFavSize)
        ]
    }()
    
    ///VStack of the Restaurant Info
    lazy var stackInfo: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.name, self.address, self.pricingView])
        stack.axis = .vertical
        stack.spacing = Layout.spacing
        stack.distribution = .fill
        
        return stack
    }()
    
    ///HStack of the Restaurant Info and Rating
    lazy var stackInfoAndRating: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.stackInfo, self.rating])
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = Layout.spacing * 4
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    lazy var stackInfoConstraints: [NSLayoutConstraint] = {
        [
            stackInfoAndRating.topAnchor
                .constraint(equalTo: cuisine.bottomAnchor,
                            constant: Layout.topPadding * 1.2),
            
            stackInfoAndRating.leadingAnchor
                .constraint(equalTo: imgView.leadingAnchor),
            
            stackInfoAndRating.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor,
                            constant: Layout.bottomPadding * 2),
            
            stackInfoAndRating.trailingAnchor
                .constraint(equalTo: imgView.trailingAnchor)
        ]
    }()
    
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    
    
    //MARK: Setup
    private func setupSubviews() {
        //Main Image
        contentView.addSubview(imgView)
        
        //Cuisine Type
        contentView.addSubview(cuisine)
        
        //Favourite
        contentView.addSubview(favouriteBtn)
        
        //Content Stack
        contentView.addSubview(stackInfoAndRating)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(imgViewConstraints +
                                    cuisineConstraints +
                                    stackInfoConstraints +
                                    favouriteBtnConstraints)
    }
    
    private func setupDataBinding() {
        //Reset in case of new binding when cell is reused
        disposable?.dispose()
        imgView.image = nil
        
        if let img = viewModel?.data.img {
            imgView.load(url: img)
        }
        
        cuisine.text = viewModel?.data.cuisine.uppercased() ?? "-"
        name.text = viewModel?.data.name ?? "-"
        address.text = viewModel?.data.address ?? "-"
        
        pricingView.setText(discount: viewModel?.data.discount ?? "-",
                            price: "\(ViewConst.avgPriceText) \(viewModel?.data.avgPrice ?? "-")€")
        
        rating.setText(rating: viewModel?.data.rating ?? "-",
                       reviews: viewModel?.data.numReviews ?? "-")
        
        //In a use case where favourite is managed with a remote storage, it could be useful
        //to add a loader when the selection changes.
        disposable = viewModel?
            .isFavourite()
            .subscribe(onNext: {[weak self] value in
                guard let self = self else { return }
                
                UIView.transition(with: self.favouriteBtn,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { self.favouriteBtn.isSelected = value },
                                  completion: nil)
            })
        
        setupConstraints()
    }
    
    func bind(to viewModel: ViewModel) {
        self.viewModel = viewModel as? RestaurantItemViewModel
        setupDataBinding()
    }
    
    
    
    //MARK: Actions
    @objc func favouriteBtnTapped(sender: UIButton) {
        viewModel?.toggleFavourite()
    }
    
    
    
    //MARK: Overrides
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
}
