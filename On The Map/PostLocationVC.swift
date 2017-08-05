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

class PostLocationVC: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure(locationTextField)
        configure(websiteTextField)
    }
    
    func getLocationFromAddress(_ location: String, _ completionHandlerForGetLocation: @escaping (_ success: Bool, _ studentLocation: MKPlacemark, _ studentCoordinate: CLLocationCoordinate2D, _ errorString: String?)) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(location) { (placemark: [CLPlacemark]?, error: NSError?) in
            if let placemark = placemark?[0] {
                let studentLocation = MKPlacemark(placemark: placemark)
                let studentCoordinate = placemark.location!.coordinate as CLLocationCoordinate2D
                
            }
        }
    }
    
    func setLocationRegion(_ location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(-.15, 0.15)
        let region = MKCoordinateRegion(center: location, span: span)
        
    }
    
    
    
    
    

}

extension PostLocationVC: UITextFieldDelegate {
    
    func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont(name: "Arial", size: 18)!]
        textField.textAlignment = NSTextAlignment.left
        
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
