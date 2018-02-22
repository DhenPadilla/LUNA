//
//  EventViewController.swift
//  LUA Application
//
//  Created by Dhen Padilla on 12/10/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
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
    
    let eventTitleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textAlignment = .center
        return view
    }()
    
    let RSVPSegmentedControl: UISegmentedControl = { //Bryan uses lazy var again to access self
        let sc = UISegmentedControl(items: ["Attending", "Interested", "Disregard"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(r: 61, g: 91, b: 151)
        sc.layer.backgroundColor = .none
        //sc.addTarget(self, action: #selector(handleRSVPChange), for: .valueChanged)
        return sc
    }()

    let descriptionTitle: UILabel = {
        let label = UILabel()
        label.text = "Description"
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
    

    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray
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
            //eventLocationLabel.text = event?.eventLocationStreet
            //eventDateTimeLabel.text = convertDateToString(date: (event?.eventDate)!)
            //setupThumbnailImage()
        }
    }
    
    override func viewDidLoad() {
        setNeedsStatusBarAppearanceUpdate()
        
        // SWIPE GESTURE SETUP
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeWindow))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        // VIEW SETUP
        self.view.backgroundColor = .white
        
        self.view.addSubview(eventCoverImageView)
        self.view.addSubview(eventOrganisationImageView)
        self.view.addSubview(eventTitleView)
        self.view.addSubview(RSVPSegmentedControl)
        self.view.addSubview(descriptionTitle)
        self.view.addSubview(locationLabel)
        self.view.addSubview(dateLabel)
        self.view.addSubview(eventDescriptionTextView)
        
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
        //CENTER eventOrganisationImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        eventOrganisationImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        eventOrganisationImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        eventOrganisationImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //eventTitle
        eventTitleView.topAnchor.constraint(equalTo: eventCoverImageView.bottomAnchor, constant: 0).isActive = true
        //eventTitleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        eventTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10)
        eventTitleView.leftAnchor.constraint(equalTo: eventOrganisationImageView.rightAnchor, constant: 10).isActive = true
        eventTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        //Date Title
        dateLabel.topAnchor.constraint(equalTo: eventOrganisationImageView.bottomAnchor, constant: 15).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: eventOrganisationImageView.widthAnchor, multiplier: 0.8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
 
        //Location Title
        locationLabel.topAnchor.constraint(equalTo: eventTitleView.bottomAnchor, constant: 15).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: eventOrganisationImageView.widthAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        
        //Description Title
        descriptionTitle.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: eventCoverImageHeight + 150).isActive = true
        descriptionTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        descriptionTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        descriptionTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        //eventDescription
        eventDescriptionTextView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: eventCoverImageHeight + 150).isActive = true
        eventDescriptionTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        eventDescriptionTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        eventDescriptionTextView.bottomAnchor.constraint(equalTo: RSVPSegmentedControl.topAnchor, constant: -20) .isActive = true
        
        //RSVPEventSC
        //RSVPSegmentedControl.topAnchor.constraint(equalTo: eventDescriptionTextView.bottomAnchor, constant: 15).isActive = true
        RSVPSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        RSVPSegmentedControl.widthAnchor.constraint(equalTo: self.view.widthAnchor/*, multiplier: 8 / 10*/).isActive = true
        RSVPSegmentedControl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/12).isActive = true
        RSVPSegmentedControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 5).isActive = true
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
}
