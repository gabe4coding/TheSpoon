//
//  RestaurantTableViewCell.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import UIKit
import RxSwift
import Swinject

struct Const {
    //Paddings
    static let zero: CGFloat = 0
    static let spacing: CGFloat = 5
    static let topPadding: CGFloat = 10
    static let bottomPadding: CGFloat = -10
    static let leftPadding: CGFloat = 10
    static let rightPadding: CGFloat = -10
    
    //Sizes
    static let imageHeight: CGFloat = 210
    static let squaredBtnFavSize: CGFloat = 35
}

class RestaurantTableViewCell: UITableViewCell, ItemViewModelBindable {
    
    private var viewModel: RestaurantItemViewModel? = nil
    private var disposable: Disposable? = nil
    
    @UsesAutoLayout
    var imgView: UIImageView = UIImageView()
    
    @UsesAutoLayout
    var cuisine: UILabel = UILabel()
    
    @UsesAutoLayout
    var name: UILabel = UILabel()
    
    @UsesAutoLayout
    var address: UILabel = UILabel()
    
    @UsesAutoLayout
    var discount: UILabel = UILabel()
    
    @UsesAutoLayout
    var price: UILabel = UILabel()
    
    @UsesAutoLayout
    var favouriteBtn = UIButton(type: .custom)
    
    @UsesAutoLayout
    var rating: RatingView = RatingView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        //Main Image
        imgView.layer.cornerRadius = 5.0
        imgView.clipsToBounds = true
        imgView.backgroundColor = .lightGray
        imgView.contentMode = .scaleAspectFill
        contentView.addSubview(imgView)
        
        //Cuisine Type
        cuisine.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        cuisine.textColor = UIColor(named: "SubtitleColor")
        cuisine.layer.opacity = 0.4
        contentView.addSubview(cuisine)
        
        //Restaurant Name
        name.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        name.textColor = UIColor(named: "LabelColor")
        name.lineBreakMode = .byTruncatingTail
        name.numberOfLines = 2
        contentView.addSubview(name)
        
        //Address
        address.font = UIFont.systemFont(ofSize: 16, weight: .light)
        address.textColor = UIColor(named: "SubtitleColor")
        address.lineBreakMode = .byTruncatingTail
        address.numberOfLines = 1
        contentView.addSubview(address)
        
        //Discount
        discount.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        discount.textColor = .black
        discount.textAlignment = .center
        discount.backgroundColor = .systemYellow
        discount.lineBreakMode = .byTruncatingTail
        discount.numberOfLines = 1
        discount.layer.cornerRadius = 5.0
        discount.clipsToBounds = true
        contentView.addSubview(discount)
        
        //Average Price
        price.font = UIFont.systemFont(ofSize: 14, weight: .light)
        price.textColor = UIColor(named: "SubtitleColor")
        price.lineBreakMode = .byTruncatingTail
        price.numberOfLines = 1
        contentView.addSubview(price)
        
        //Favourite
        favouriteBtn.contentMode = .scaleAspectFit
        favouriteBtn.contentHorizontalAlignment = .fill
        favouriteBtn.contentVerticalAlignment = .fill
        favouriteBtn.imageView?.tintColor = .white
        if let image = UIImage(named: "empty-heart")?.withRenderingMode(.alwaysTemplate) {
            favouriteBtn.setImage(image, for: .normal)
        }
        
        if let image = UIImage(named: "solid-heart") {
            favouriteBtn.setImage(image, for: .selected)
        }
        favouriteBtn.backgroundColor = .darkGray
        favouriteBtn.imageEdgeInsets = UIEdgeInsets(top: 8,left: 6,bottom: 7,right: 6)
        favouriteBtn.addTarget(self,
                               action: #selector(self.favouriteBtnTapped),
                               for: .touchUpInside)
        favouriteBtn.layer.cornerRadius = Const.squaredBtnFavSize / 2
        contentView.addSubview(favouriteBtn)
        
        //Rating
        contentView.addSubview(rating)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            //ImageView
            imgView.topAnchor
                .constraint(equalTo: contentView.topAnchor,
                            constant: Const.topPadding),
            
            imgView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor,
                            constant: Const.leftPadding),
            
            imgView.trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor,
                            constant: Const.rightPadding),
            
            imgView.heightAnchor
                .constraint(equalToConstant: Const.imageHeight),
            
            
            //Rating Label
            rating.topAnchor
                .constraint(equalTo: name.topAnchor),
            
            rating.trailingAnchor
                .constraint(equalTo: imgView.trailingAnchor),
            
            cuisine.leadingAnchor
                .constraint(equalTo: imgView.leadingAnchor),
            
            cuisine.topAnchor
                .constraint(equalTo: imgView.bottomAnchor,
                            constant: Const.topPadding),
            
            //Name Label
            name.leadingAnchor
                .constraint(equalTo: imgView.leadingAnchor),
            
            name.topAnchor
                .constraint(equalTo: cuisine.bottomAnchor,
                            constant: Const.topPadding * 1.2),
            name.trailingAnchor
                .constraint(equalTo: rating.leadingAnchor,
                            constant: Const.rightPadding * 3),
            
            //Address Label
            address.leadingAnchor
                .constraint(equalTo: imgView.leadingAnchor),
            
            address.topAnchor
                .constraint(equalTo: name.bottomAnchor,
                            constant: Const.spacing),
            
            address.trailingAnchor
                .constraint(equalTo: imgView.trailingAnchor),
            
            //Discount Label
            discount.widthAnchor
                .constraint(equalToConstant: 45),
            
            discount.centerYAnchor
                .constraint(equalTo: price.centerYAnchor),
            
            discount.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor,
                            constant: Const.bottomPadding * 2),
            
            discount.leadingAnchor
                .constraint(equalTo: price.trailingAnchor,
                            constant: Const.leftPadding),
            
            //Price Label
            price.leadingAnchor
                .constraint(equalTo: imgView.leadingAnchor),
            
            price.topAnchor
                .constraint(equalTo: address.bottomAnchor,
                            constant: Const.spacing),
            price.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor,
                            constant: Const.bottomPadding * 2),
            
            //Favourite Button
            favouriteBtn.topAnchor
                .constraint(equalTo: imgView.topAnchor,
                            constant: Const.topPadding),
            
            favouriteBtn.trailingAnchor
                .constraint(equalTo: imgView.trailingAnchor,
                            constant: Const.rightPadding),
            
            favouriteBtn.widthAnchor
                .constraint(equalToConstant: Const.squaredBtnFavSize),
            
            favouriteBtn.heightAnchor
                .constraint(equalToConstant: Const.squaredBtnFavSize)
        ])
    }
    
    private func setupDataBinding() {
        disposable?.dispose()
        imgView.image = nil
        if let img = viewModel?.data.img {
            imgView.load(url: img)
        }
        
        cuisine.text = viewModel?.data.cuisine.uppercased() ?? "-"
        name.text = viewModel?.data.name ?? "-"
        address.text = viewModel?.data.address ?? "-"
        discount.text = viewModel?.data.discount ?? "-"
        price.text = "Average price \(viewModel?.data.avgPrice ?? "-")€"
        rating.ratinglbl.text = viewModel?.data.rating ?? "-"
        rating.reviewsLbl.text = viewModel?.data.numReviews ?? "-"
        
        setupConstraints()
        
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
    }
    
    func bind(to viewModel: ViewModel) {
        self.viewModel = viewModel as? RestaurantItemViewModel
        setupDataBinding()
    }
    
    @objc func favouriteBtnTapped(sender: UIButton) {
        viewModel?.toggleFavourite()
    }
}
