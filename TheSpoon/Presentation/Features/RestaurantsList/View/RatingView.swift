//
//  RatingView.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import UIKit

class RatingView: UIView {
    
    //MARK: Constants
    private struct ViewConst {
        static let reviewIconSize: CGFloat = 13
        static let reviewIconName: String = "icon-reviews"
    }
    
    //MARK: Subviews and Constraints
    ///Rating number
    private lazy var ratinglbl: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .right
        label.textColor = UIColor.titleColor
        return label
    }()
    private lazy var ratinglblConstraints: [NSLayoutConstraint] = {
        [
            ratinglbl.topAnchor
                .constraint(equalTo: topAnchor),
            
            ratinglbl.trailingAnchor
                .constraint(equalTo: trailingAnchor)
        ]
    }()
    
    ///Number of reviews
    private lazy var reviewsLbl: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .right
        label.textColor = UIColor.subtitleColor
        return label
    }()
    private lazy var reviewsLblConstraints : [NSLayoutConstraint] = {
        [
            reviewsLbl.topAnchor
                .constraint(equalTo: ratinglbl.bottomAnchor),
            
            reviewsLbl.trailingAnchor
                .constraint(equalTo: ratinglbl.trailingAnchor),
            
            reviewsLbl.bottomAnchor
                .constraint(equalTo: bottomAnchor),
        ]
    }()
    
    ///Reivews image badge.
    private lazy var imgReviews: UIImageView = {
        @UsesAutoLayout
        var img = UIImageView()
        img.image = UIImage(named: ViewConst.reviewIconName)?.withRenderingMode(.alwaysTemplate)
        img.tintColor = UIColor.subtitleColor
        img.contentMode = .scaleAspectFit
        return img
    }()
    private lazy var imgReviewsConstraints: [NSLayoutConstraint] = {
        [
            imgReviews.trailingAnchor
                .constraint(equalTo: reviewsLbl.leadingAnchor, constant: -Layout.spacing/2),
            
            imgReviews.centerYAnchor
                .constraint(equalTo: reviewsLbl.centerYAnchor),
            
            imgReviews.heightAnchor
                .constraint(equalToConstant: ViewConst.reviewIconSize),
            
            imgReviews.widthAnchor
                .constraint(equalToConstant: ViewConst.reviewIconSize)
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
    
    //MARK: Setup
    func setupSubviews() {
        addSubview(ratinglbl)

        addSubview(imgReviews)
        
        addSubview(reviewsLbl)
    }
    
    func setText(rating: String, reviews: String) {
        self.ratinglbl.text = rating
        self.reviewsLbl.text = reviews
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(ratinglblConstraints +
                                    imgReviewsConstraints +
                                    reviewsLblConstraints + [ widthAnchor.constraint(greaterThanOrEqualToConstant: self.ratinglbl.intrinsicContentSize.width)])
    }
}
