//
//  MenuBar.swift
//  LUA Application
//
//  Created by Dhen Padilla on 06/09/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit

class MenuBar: UIView , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let topMenuBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 100/225, green: 100/225, blue: 100/225, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Customisation of Tab Menu
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white//(red: 17/255, green: 64/255, blue: 142/255, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellID"
    let imageNames = ["Home Button", "Search Button", "Saved Button", "User Button"]
    
    var homeController: HomeViewController?
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(topMenuBorder)
        setupTopMenuBorder()
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        
        setupHorizontalBar()

        
        backgroundColor = UIColor.white
    }
    
    func setupTopMenuBorder() {
        topMenuBorder.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topMenuBorder.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        topMenuBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topMenuBorder.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = UIColor(r: 24, g: 32, b: 49)
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    
    
    //Scrolling and menu highlighting
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor(r: 109, g: 127, b: 140)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showProfile() {
        print("Move to profile Page")
        
    }
}
