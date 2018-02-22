//
//  Extensions.swift
//  LUA Application
//
//  Created by Dhen Padilla on 04/09/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit

//Extension on view:

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


extension UIImageView {
    
    public func loadImageUsingUrlString(urlString: String) {
        let session = URLSession()
        guard let requestUrl = URL(string:urlString) else { return }
        let request = URLRequest(url:requestUrl)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            if error == nil {
                print(error ?? "Unknown error")
            }
            
            print("response = \(response)")
            
            if let downloadedImage = data {
                self.image = UIImage(data: downloadedImage)
            }
            
            else {
                return
            }
            
        }
        
        task.resume()
    }
 
}
