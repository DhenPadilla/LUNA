//
//  ProfilePageViewController.swift
//  LUA Application
//
//  Created by Dhen Padilla on 15/01/2018.
//  Copyright © 2018 dhenpadilla. All rights reserved.
//

import UIKit

class ProfilePageView: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    
    let settings: [Setting] = {
        return [Setting(name: "Log Out"), Setting(name: "Manage Societies"), Setting(name: "Privacy Settings"), Setting(name: "Change Password"), Setting(name: "Change Email"), Setting(name: "Manage Location Services"), Setting(name: "Deactivate")]
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        return cv
    }()
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.layer.cornerRadius = 25
        return view
    }()
    
    let headerImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(r: 16, g: 59, b: 48)
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.addSubview(headerImage)
        view.addSubview(profileImage)
        view.addSubview(collectionView)
        
        setupPageView()
        setupImageViews()
        setupCollectionView()
    }
    
    func setupPageView() {
        view.backgroundColor = .white
        view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setupImageViews() {
        let headerHeight = (self.view.frame.height / 10) * 2
        
        //Setup header View
        headerImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        headerImage.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        
        //Setup Profile image
        profileImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (headerHeight - 35)).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.leftAnchor.constraint(greaterThanOrEqualTo: self.view.leftAnchor, constant: 50).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setupCollectionView() {
        let headerHeight = (self.view.frame.height / 10) * 2
        
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: headerHeight).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let setting = settings[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
