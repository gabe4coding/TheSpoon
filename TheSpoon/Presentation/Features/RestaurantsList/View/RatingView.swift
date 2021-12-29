//
//  RatingView.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import UIKit

class RatingView: UIView {
    
    @UsesAutoLayout
    var ratinglbl: UILabel = UILabel()
    
    @UsesAutoLayout
    var reviewsLbl: UILabel = UILabel()
    
    @UsesAutoLayout
    var imgReviews: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ratinglbl.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        ratinglbl.textAlignment = .right
        ratinglbl.textColor = UIColor(named: "LabelColor")
        addSubview(ratinglbl)

        imgReviews.image = UIImage(named: "icon-reviews")?.withRenderingMode(.alwaysTemplate)
        imgReviews.tintColor = UIColor(named: "SubtitleColor")
        imgReviews.contentMode = .scaleAspectFit
        addSubview(imgReviews)
        
        reviewsLbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        reviewsLbl.textAlignment = .right
        reviewsLbl.textColor = UIColor(named: "SubtitleColor")
        addSubview(reviewsLbl)

        NSLayoutConstraint.activate([
            ratinglbl.topAnchor
                .constraint(equalTo: topAnchor),
            ratinglbl.trailingAnchor
                .constraint(equalTo: trailingAnchor),
            
            reviewsLbl.topAnchor
                .constraint(equalTo: ratinglbl.bottomAnchor),
            reviewsLbl.trailingAnchor
                .constraint(equalTo: ratinglbl.trailingAnchor),
            reviewsLbl.bottomAnchor
                .constraint(equalTo: bottomAnchor),
            
            imgReviews.trailingAnchor
                .constraint(equalTo: reviewsLbl.leadingAnchor, constant: -Const.spacing),
            imgReviews.centerYAnchor
                .constraint(equalTo: reviewsLbl.centerYAnchor),
            imgReviews.heightAnchor
                .constraint(equalToConstant: 13),
            imgReviews.widthAnchor
                .constraint(equalToConstant: 13)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
      }

}
