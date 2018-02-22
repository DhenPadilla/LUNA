//
//  MenuCell.swift
//  LUA Application
//
//  Created by Dhen Padilla on 11/09/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home Button")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor(r: 109, g: 127, b: 140)
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor(r: 24, g: 32, b: 49) : UIColor(r: 109, g: 127, b: 140)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor(r: 24, g: 32, b: 49) : UIColor(r: 109, g: 127, b: 140)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
