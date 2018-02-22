//
//  FiltersLauncher.swift
//  LUA Application
//
//  Created by Dhen Padilla on 10/09/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit

class FilterLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var parentViewController: HomeViewController?
    
    /**** FILTER ****/
    
    let blackView = UIView()
    
    let collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor(red: 24/255, green: 32/255, blue: 49/255, alpha: 0.9)//.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let cellId = "cellid"
    
    let filters: [Filter] = {
       return [Filter(name: "Date"), Filter(name: "Location"), Filter(name: "Alphabet"), Filter(name: "Cancel")]
    }()
    
    //Cell Height:
    let cellHeight:CGFloat = 50
    
    //Show filter method
    func showFilters() {
        
        if let window = UIApplication.shared.keyWindow {
            
            //Background colour
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            //Add subviews
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            //Collection View Frame
            let height:CGFloat = CGFloat(filters.count + 1) * cellHeight - 10
            let y = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            self.blackView.frame = window.frame
            self.blackView.alpha = 0
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: height)
            }, completion: nil)
            
        }
    }
    
    //Dismisses SubMenu
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.width)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let filter = filters[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FilterCell
        
        cell.filter = filter
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            
            if indexPath.item == 3 {
                cell.backgroundColor = UIColor(red: 24/255, green: 32/255, blue: 49/255, alpha: 0)
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.handleDismiss()
                })
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.parentViewController?.orderEventsBy(filterTitle: "\(self.filters[indexPath.item].name)")
                    self.handleDismiss()
                })
            }
        }
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: cellId)
    }
}
