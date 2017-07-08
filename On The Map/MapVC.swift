//
//  File.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/21/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import UIKit
import MapKit


class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("populating map")
        self.mapView.addAnnotations(populateMap())
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLocation() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func logout() {
        UdacityClient.sharedInstance().deleteSession() { (success, results, errorString) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                print(errorString)
            }
        }
        
    }
    
    
    private func populateMap() -> [MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]()
        let studentArray = UdacityClient.sharedInstance().students + UdacityClient.sharedInstance().localStudent
        
        for student in studentArray {
            
            let lat = CLLocationDegrees(student.latitude )
            let long = CLLocationDegrees(student.longitude )
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }

        return annotations
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
   
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tap function  running")
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    //    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //
    //        if control == annotationView.rightCalloutAccessoryView {
    //            let app = UIApplication.sharedApplication()
    //            app.openURL(NSURL(string: annotationView.annotation.subtitle))
    //        }
    //    }
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.

}
