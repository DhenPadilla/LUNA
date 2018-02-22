//
//  SettingsCell.swift
//  LUA Application
//
//  Created by Dhen Padilla on 27/01/2018.
//  Copyright © 2018 dhenpadilla. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : .white
            settingName.textColor = isHighlighted ? .white : .black
        }
    }
    
    var setting: Setting? {
        didSet {
            settingName.text = setting?.name
        }
    }
    
    let settingName: UILabel = {
        let button = UILabel()
        button.text = "Log Out" //of (\first_name) + (\last_name)
        button.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(settingName)
        
        addConstraint(NSLayoutConstraint(item: settingName, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: settingName)
        
    }
}
