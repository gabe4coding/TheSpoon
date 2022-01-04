//
//  PricingView.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 29/12/21.
//

import Foundation
import UIKit

class RestaurantPricingView: UIView {
    
    //MARK: Subviews and Constraints
    ///Discount label with yellow background
    private lazy var discount: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .systemYellow
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.layer.cornerRadius = 5.0
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var discountConstraints: [NSLayoutConstraint] = {
        [
            discount.topAnchor
                .constraint(equalTo: topAnchor),
            
            discount.leadingAnchor
                .constraint(equalTo: leadingAnchor),
            
            discount.bottomAnchor
                .constraint(equalTo: bottomAnchor),
            
            discount.widthAnchor
                .constraint(equalToConstant: discount.intrinsicContentSize.width * 1.2)
        ]
    }()
    
    ///Average price label
    private lazy var price: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.subtitleColor
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    private lazy var priceConstraints: [NSLayoutConstraint] = {
        [
            price.topAnchor
                .constraint(equalTo: topAnchor),
            
            price.leadingAnchor
                .constraint(equalTo: discount.trailingAnchor,
                            constant: Layout.spacing),
            
            price.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(discount)
        
        addSubview(price)
    }
    
    //MARK: Setup
    func setText(discount: String, price: String) {
        self.discount.text = discount
        self.price.text = price
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(discountConstraints + priceConstraints)
    }
    
    //MARK: Overrides
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
