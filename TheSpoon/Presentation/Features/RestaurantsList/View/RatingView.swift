//
//  RatingView.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import UIKit

class RatingView: UIView {
    
    private struct ViewConst {
        static let reviewIconSize: CGFloat = 13
        static let reviewIconName: String = "icon-reviews"
    }
    
    @UsesAutoLayout
    private var ratinglbl: UILabel = UILabel()
    private lazy var ratinglblConstraints: [NSLayoutConstraint] = {
        [
            ratinglbl.topAnchor
                .constraint(equalTo: topAnchor),
            
            ratinglbl.trailingAnchor
                .constraint(equalTo: trailingAnchor)
        ]
    }()
    
    @UsesAutoLayout
    private var reviewsLbl: UILabel = UILabel()
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
    
    @UsesAutoLayout
    private var imgReviews: UIImageView = UIImageView()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        ratinglbl.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        ratinglbl.textAlignment = .right
        ratinglbl.textColor = UIColor.titleColor
        addSubview(ratinglbl)

        imgReviews.image = UIImage(named: ViewConst.reviewIconName)?.withRenderingMode(.alwaysTemplate)
        imgReviews.tintColor = UIColor.subtitleColor
        imgReviews.contentMode = .scaleAspectFit
        addSubview(imgReviews)
        
        reviewsLbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        reviewsLbl.textAlignment = .right
        reviewsLbl.textColor = UIColor.subtitleColor
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
