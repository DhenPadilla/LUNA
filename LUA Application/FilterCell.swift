//
//  FilterCell.swift
//  LUA Application
//
//  Created by Dhen Padilla on 11/09/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit

class FilterCell: BaseCell {
    
    /*
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : UIColor(red: 24/255, green: 32/255, blue: 49/255, alpha: 0)
            //filterName.textColor = isHighlighted ? .white : .black
        }
    }
    */
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .lightGray : UIColor(red: 24/255, green: 32/255, blue: 49/255, alpha: 0)
            //filterName.textColor = isHighlighted ? .white : .black
        }
    }

    var filter: Filter? {
        didSet {
            filterName.text = filter?.name
            if filterName.text == "Cancel" {
                filterName.textColor = .red
            }
        }
    }
    
    let filterName:UILabel = {
        let button = UILabel()
        button.text = "By Most Recent"
        button.font = UIFont.systemFont(ofSize: 16)
        button.textColor = .white
        return button
    }()
    
    

    
    override func setupViews() {
        super.setupViews()
        
        addSubview(filterName)
        
        addConstraint(NSLayoutConstraint(item: filterName, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))

        addConstraintsWithFormat(format: "V:|[v0]-1-|", views: filterName)
    }
}
