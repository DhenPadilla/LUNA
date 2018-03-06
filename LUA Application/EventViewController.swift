//
//  EventViewController.swift
//  LUA Application
//
//  Created by Dhen Padilla on 12/10/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit
import AutoScrollLabel

class EventViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    let items = ["Unsure", "Attending", "Interested"]
    
    //For Defining the animation
    private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    let eventCoverImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        
        return view
    }()
    
    let eventOrganisationImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        return view
    }()
    
    let eventTitleView: CBAutoScrollLabel = {
        let view = CBAutoScrollLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 18)
        
        //Auto Scroll Label
        view.labelSpacing = 50 // distance between start and end labels
        view.pauseInterval = 1.7 // seconds of pause before scrolling starts again
        view.scrollSpeed = 30 // pixels per second
        view.textAlignment = .left // left aligns text when no auto-scrolling is applied
        view.fadeLength = 12
        
        return view
    }()
    
    let descriptionTitle: UILabel = {
        let label = UILabel()
        label.text = "Description:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray
        return label
    }()
    
    let eventDescriptionTextView:UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray
        return label
    }()
    
    let dateTitle: CBAutoScrollLabel = {
        let label = CBAutoScrollLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        
        //Auto Scroll Label
        label.labelSpacing = 50 // distance between start and end labels
        label.pauseInterval = 1.7 // seconds of pause before scrolling starts again
        label.scrollSpeed = 30 // pixels per second
        label.textAlignment = .left // left aligns text when no auto-scrolling is applied
        label.fadeLength = 5
        return label
    }()

    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray
        return label
    }()
    
    let locationTitle: CBAutoScrollLabel = {
        let label = CBAutoScrollLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        
        //Auto Scroll Label
        label.labelSpacing = 50 // distance between start and end labels
        label.pauseInterval = 1.7 // seconds of pause before scrolling starts again
        label.scrollSpeed = 30 // pixels per second
        label.textAlignment = .left // left aligns text when no auto-scrolling is applied
        label.fadeLength = 12
        
        return label
    }()
    
    var event: Event? {
        didSet {
            eventTitleView.text = event?.eventTitle
            eventDescriptionTextView.text = event?.eventDescription
            eventCoverImageView.image = event?.eventThumbnailImage
            eventCoverImageView.contentMode = .scaleAspectFill
            
            if let eventThumbnailURL = event?.eventThumbnailImageURL {
                if let eventOwnerPictureURL = URL(string: String(describing: eventThumbnailURL)) {
                    URLSession.shared.dataTask(with: eventOwnerPictureURL, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(String(describing: error))
                            return
                        }
                        
                        let eventImage = UIImage(data: data!)
                        DispatchQueue.main.async {
                            self.eventOrganisationImageView.image = eventImage
                        }
                    }).resume()
                }
            }
            if let eventLocation = event?.eventLocationStreet {
                locationTitle.text = eventLocation
            }
            if let eventDate = event?.eventDate {
                dateTitle.text = convertDateToString(date: eventDate)
            }
        }
    }
    
    override func viewDidLoad() {
        setNeedsStatusBarAppearanceUpdate()
        
        // SWIPE GESTURE SETUP
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeWindow))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        //Set up Carousel - if dates > 1
        let carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        carousel.center = view.center
        carousel.dataSource = self
        carousel.delegate = self
        carousel.type = .rotary
        carousel.backgroundColor = .clear
        carousel.translatesAutoresizingMaskIntoConstraints = false
        
        // VIEW SETUP
        self.view.backgroundColor = .white
        self.view.addSubview(eventCoverImageView)
        self.view.addSubview(eventOrganisationImageView)
        self.view.addSubview(eventTitleView)
        self.view.addSubview(descriptionTitle)
        self.view.addSubview(locationLabel)
        self.view.addSubview(locationTitle)
        self.view.addSubview(dateLabel)
        self.view.addSubview(dateTitle)
        self.view.addSubview(eventDescriptionTextView)
        self.view.addSubview(carousel)
        
        carousel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        carousel.widthAnchor.constraint(equalTo: self.view.widthAnchor/*, multiplier: 8 / 10*/).isActive = true
        carousel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/12).isActive = true
        carousel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true

        eventDescriptionTextView.bottomAnchor.constraint(equalTo: carousel.topAnchor, constant: -20).isActive = true
        
        setupViews()
    }
    
    func setupViews() {
        let eventCoverImageHeight = (view.frame.width * (9 / 16))
        
        //eventCoverImage
        eventCoverImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        eventCoverImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        eventCoverImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        eventCoverImageView.heightAnchor.constraint(equalToConstant: eventCoverImageHeight).isActive = true

        //eventOrganiserIcon
        eventOrganisationImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: eventCoverImageHeight - 50).isActive = true
        eventOrganisationImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        eventOrganisationImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        eventOrganisationImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //eventTitle
        eventTitleView.topAnchor.constraint(equalTo: eventCoverImageView.bottomAnchor, constant: 0).isActive = true
        eventTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        eventTitleView.leftAnchor.constraint(equalTo: eventOrganisationImageView.rightAnchor, constant: 10).isActive = true
        eventTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Date Label - `Date: `
        dateLabel.topAnchor.constraint(equalTo: eventOrganisationImageView.bottomAnchor, constant: 15).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: eventOrganisationImageView.widthAnchor, multiplier: 0.5).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //Date Title - Actual Date
        dateTitle.leftAnchor.constraint(equalTo: dateLabel.rightAnchor).isActive = true
        dateTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        dateTitle.topAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        dateTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
 
        //Location Label - `Location: `
        locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: eventOrganisationImageView.widthAnchor, multiplier: 0.8).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //Location Title - Actual Location
        locationTitle.leftAnchor.constraint(equalTo: locationLabel.rightAnchor).isActive = true
        locationTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        locationTitle.topAnchor.constraint(equalTo: locationLabel.topAnchor).isActive = true
        locationTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true

        //Description Title
         descriptionTitle.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
         descriptionTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
         descriptionTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
         descriptionTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
         
         //eventDescription
         eventDescriptionTextView.topAnchor.constraint(equalTo: descriptionTitle.bottomAnchor, constant: 5).isActive = true
         eventDescriptionTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
         eventDescriptionTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIView
        
        //reuse view if available, otherwise create a new view
        if let view = view {
            itemView = view
            //get a reference to the label in the recycled view
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.layer.bounds.width - 20, height: 50))
            itemView.contentMode = .center
            itemView.backgroundColor = UIColor(r: 24, g: 32, b: 49)
            itemView.layer.cornerRadius = 15
            
            itemView.layer.shadowColor = UIColor.black.cgColor
            itemView.layer.shadowOpacity = 0.4
            itemView.layer.shadowOffset = CGSize.zero
            itemView.layer.shadowRadius = 10
            
            label = UILabel(frame: itemView.bounds)
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = .white
            label.tag = 1
            itemView.addSubview(label)
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = "\(items[index])"
        return itemView
    }
    
    
    override func viewDidLayoutSubviews() {
        eventDescriptionTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        eventOrganisationImageView.layer.cornerRadius = 15
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func closeWindow() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.none
        formatter.dateStyle = DateFormatter.Style.long
        return formatter.string(from: date)
    }
}
