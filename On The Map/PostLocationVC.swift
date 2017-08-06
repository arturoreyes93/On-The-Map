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

    @IBOutlet weak var locationSubview: UIView!
    @IBOutlet weak var mapSubview: UIView!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var websiteText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        configure(locationText)
        configure(websiteText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setFindView()
    }
    
    func setFindView() {
        locationSubview.isHidden = false
        mapSubview.isHidden = true
    }
    
    func setMapView() {
        locationSubview.isHidden = true
        mapSubview.isHidden = false
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        getLocationFromAddress(locationText.text!)
        
    }
    
    func getLocationFromAddress(_ location: String) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(location) { placemarks, error in
            if let placemark = placemarks?[0] {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                let coordinate = placemark.location!.coordinate as CLLocationCoordinate2D
                let span = MKCoordinateSpanMake(0.15, 0.15)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                self.setMapView()
            
            } else {
                print("error with finding address")
                
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
