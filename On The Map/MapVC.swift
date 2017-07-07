//
//  File.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/21/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.addAnnotation(populateMap() as! MKAnnotation)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func populateMap() -> [MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]()
        
        UdacityClient.sharedInstance().getStudentLocations() { (success, studentArray, errorString) in
            
            if success {
                let studentArray = UdacityClient.sharedInstance().fromDictToStudentObject(studentArray: studentArray!)
                
                for student in studentArray {
                    
                    let lat = CLLocationDegrees(student.latitude )
                    let long = CLLocationDegrees(student.longitude )
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = student.firstName
                    let last = student.firstName
                    let mediaURL = student.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                }
            } else {
                print(errorString!)
            }
        }
        
        return annotations
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
