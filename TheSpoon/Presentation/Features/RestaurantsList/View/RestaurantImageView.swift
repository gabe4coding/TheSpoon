//
//  RestaurantImageView.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 04/01/22.
//

import UIKit

class RestaurantImageView: UIView {
    
    //MARK: Constants
    private struct ViewConst {
        static let imageHeight: CGFloat = 210
    }
    
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
                .constraint(equalTo: topAnchor),
            
            imgView.leadingAnchor
                .constraint(equalTo: leadingAnchor),
            
            imgView.trailingAnchor
                .constraint(equalTo: trailingAnchor),
            
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
                .constraint(equalTo: leadingAnchor),
            
            cuisine.topAnchor
                .constraint(equalTo: imgView.bottomAnchor,
                            constant: Layout.topPadding),
            
            cuisine.bottomAnchor
                .constraint(equalTo: bottomAnchor)
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
        addSubview(imgView)
        
        addSubview(cuisine)
    }
    
    //MARK: Setup
    func set(cuisine: String?, img: String?) {
        if let img = img {
            imgView.load(url: img)
        } else {
            imgView.image = nil
        }
        
        self.cuisine.text = cuisine?.uppercased() ?? "-"
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(imgViewConstraints + cuisineConstraints)
    }
    
    //MARK: Overrides
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

}
