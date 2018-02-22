//
//  VideoCell.swift
//  LUA Application
//
//  Created by Dhen Padilla on 04/09/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit
import AutoScrollLabel

class EventCell: BaseCell {
    
    var event: Event? {
        didSet {
            eventTitleLabel.text = event?.eventTitle
            eventDescriptionLabel.text = event?.eventDescription
            eventDescriptionLabel.sizeToFit()
            
            if let eventThumbnailURL = event?.eventThumbnailImageURL {
                
                if let eventOwnerPictureURL = URL(string: String(describing: eventThumbnailURL)) {
                    URLSession.shared.dataTask(with: eventOwnerPictureURL, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(String(describing: error))
                            return
                        }
                    
                        let eventImage = UIImage(data: data!)
                        DispatchQueue.main.async {
                            self.companyThumbnailImageView.image = eventImage
                        }
                    }).resume()
                }
            }
            eventLocationLabel.text = event?.eventLocationStreet
            eventDateTimeLabel.text = convertDateToString(date: (event?.eventDate)!)
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white// UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: -1, height: 1)
        imageView.layer.shadowRadius = 1
        
        imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        
        return imageView
    }()
    
    let companyThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 180/225, green: 180/225, blue: 180/225, alpha: 0.8)
        return view
    }()
    
    let eventTitleLabel: CBAutoScrollLabel = {
        let label = CBAutoScrollLabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false

        //Auto Scroll Label
        label.labelSpacing = 50 // distance between start and end labels
        label.pauseInterval = 1.7 // seconds of pause before scrolling starts again
        label.scrollSpeed = 30 // pixels per second
        label.textAlignment = .left // left aligns text when no auto-scrolling is applied
        label.fadeLength = 12 // length of the left and right edge fade, 0 to disable
        
        return label

    }()
    
    /*
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        //label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.text = "Event Title here"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 */
    
    let eventDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        label.text = "Description Text Here"
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.none
        formatter.dateStyle = DateFormatter.Style.long
        return formatter.string(from: date)
    }
    
    let eventDateTimeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        label.text = "Date Here"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let eventLocationLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        label.text = "Location Here"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        
        //backgroundColor = UIColor. white
        addSubview(thumbnailImageView)
        addSubview(seperatorView)
        addSubview(companyThumbnailImageView)
        addSubview(eventTitleLabel)
        addSubview(eventDescriptionLabel)
        addSubview(eventDateTimeLabel)
        addSubview(eventLocationLabel)
        
        //---------- Seperator Constraint ----------
        addConstraintsWithFormat(format: "H:|[v0]|", views: seperatorView)

        //---------- Event Cell Constraints ----------
        addConstraintsWithFormat(format: "H:|[v0]|", views: thumbnailImageView)
        //Vertical Constraints - Contains Seperator View
        addConstraintsWithFormat(format: "V:|[v0]-16-|", views: thumbnailImageView)
        
        
        //---------- Event Company Image Constraints - Contains Title Constraint ----------
        addConstraintsWithFormat(format: "H:|-16-[v0(54)]-16-[v1]-16-|", views: companyThumbnailImageView, eventTitleLabel)
        companyThumbnailImageView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: 16).isActive = true
        companyThumbnailImageView.leftAnchor.constraint(equalTo: thumbnailImageView.leftAnchor, constant: 8).isActive = true
        companyThumbnailImageView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        companyThumbnailImageView.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        
        //---------- Event Title Constraints ----------
        eventTitleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: 16).isActive = true
        eventTitleLabel.leftAnchor.constraint(equalTo: companyThumbnailImageView.rightAnchor, constant: 16).isActive = true
        eventTitleLabel.rightAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 16).isActive = true
        eventTitleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        //---------- Event Description Constraints ----------
        eventDescriptionLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 4).isActive = true
        /*eventDescriptionLabel.leftAnchor.constraint(equalTo: companyThumbnailImageView.rightAnchor, constant: 16).isActive = true
        eventDescriptionLabel.rightAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 16).isActive = true
         */
        addConstraintsWithFormat(format: "H:|-86-[v0]-24-|", views: eventDescriptionLabel)
        eventDescriptionLabel.bottomAnchor.constraint(equalTo: eventLocationLabel.topAnchor, constant: 0).isActive = true
        
        //---------- Event Location Constraints ----------
        eventLocationLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor).isActive = true
        eventLocationLabel.rightAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 16).isActive = true
        eventLocationLabel.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 1/4).isActive = true
        eventLocationLabel.widthAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1/2).isActive = true
        
        
        //---------- Event Date-Time Constraints ----------
        eventDateTimeLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor).isActive = true
        eventDateTimeLabel.leftAnchor.constraint(equalTo: thumbnailImageView.leftAnchor, constant: 16).isActive = true
        eventDateTimeLabel.heightAnchor.constraint(equalTo: eventLocationLabel.heightAnchor).isActive = true
        eventDateTimeLabel.widthAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1/3).isActive = true
        
    }
}
