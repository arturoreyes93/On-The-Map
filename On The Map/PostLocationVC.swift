//
//  PostLocationVC.swift
//  On The Map
//
//  Created by Arturo Reyes on 7/8/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostLocationVC: UIViewController, MKMapViewDelegate  {
    
    var newData = [String:String]()
    

    @IBOutlet weak var locationSubview: UIView!
    @IBOutlet weak var mapSubview: UIView!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var websiteText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        configure(locationText)
        configure(websiteText)
        self.activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        enableMapView(false)
    }

    
    func enableMapView(_ enabled: Bool) {
        locationSubview.isHidden = enabled
        mapSubview.isHidden = !(enabled)
        self.submitButton.isHidden = !(enabled)
    }
    
    @IBAction func cancelMain(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelMap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        if locationText.text!.isEmpty {
            self.postSimpleAlert("Please enter a location")
            return
        } else {
             getLocationFromAddress(locationText.text!)
            
        }
        
    }
    
    @IBAction func submit(_ sender: Any) {
        
        if (websiteText.text?.isEmpty)! {
            self.postSimpleAlert("Please enter your website link")
            return
        } else {
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
            }
            self.newData["URL"] = self.websiteText.text
            
            print(self.newData)
    
            if StudentData.sharedInstance().localStudent[0].mapString.isEmpty {
                UdacityClient.sharedInstance().postStudentLocation(self.newData) { (success, errorString) in
                    performUIUpdatesOnMain {
                        if success {
                            self.activityIndicator.stopAnimating()
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.postSimpleAlert(errorString!)
                            return
                        }
                    }
                }
                
            } else {
                performUIUpdatesOnMain {
                    self.activityIndicator.startAnimating()
                }
                UdacityClient.sharedInstance().putStudentLocation(self.newData) { (success, errorString) in
                    performUIUpdatesOnMain {
                        if success {
                            self.activityIndicator.stopAnimating()
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.postSimpleAlert(errorString!)
                            return
                        }
                    }
                }
            }
        }
    }
    
    
    func getLocationFromAddress(_ location: String) {
        
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
        }
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(location) { placemarks, error in
            if let placemark = placemarks?[0] {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                let coordinate = placemark.location!.coordinate as CLLocationCoordinate2D
                let span = MKCoordinateSpanMake(0.15, 0.15)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.enableMapView(true)
                }
                
                self.newData["latitude"] = String(coordinate.latitude)
                self.newData["longitude"] = String(coordinate.longitude)
                self.newData["mapString"] = self.locationText.text!
                
            } else {
                
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                }
                
                self.postSimpleAlert("Error in finding adress")
        
            }
        }
    }
}

extension PostLocationVC: UITextFieldDelegate {
    
    func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Arial", size: 32)!]
        textField.textAlignment = NSTextAlignment.center
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
}
