//
//  PricingView.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 29/12/21.
//

import Foundation
import UIKit

class PricingView: UIView {
    @UsesAutoLayout
    private var discount: UILabel = UILabel()
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
    
    @UsesAutoLayout
    private var price: UILabel = UILabel()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        //Discount
        discount.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        discount.textColor = .black
        discount.textAlignment = .center
        discount.backgroundColor = .systemYellow
        discount.lineBreakMode = .byTruncatingTail
        discount.numberOfLines = 1
        discount.layer.cornerRadius = 5.0
        discount.clipsToBounds = true
        addSubview(discount)
        
        //Average Price
        price.font = UIFont.systemFont(ofSize: 14, weight: .light)
        price.textColor = UIColor.subtitleColor
        price.lineBreakMode = .byTruncatingTail
        price.numberOfLines = 1
        addSubview(price)
    }
    
    func setText(discount: String, price: String) {
        self.discount.text = discount
        self.price.text = price
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(discountConstraints + priceConstraints)
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
