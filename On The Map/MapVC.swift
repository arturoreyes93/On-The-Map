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
        
        guard let tabBar = self.parent else {
            return
        }
        
        tabBar.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocation))
        tabBar.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(self.logout))
        
        print("downloading data")
        self.downloadData(UdacityClient.sharedInstance().userKey!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadData(_ userKey: String) {
        UdacityClient.sharedInstance().getSingleStudentLocation(studentKey: userKey) { (success, localStudentArray, errorString) in
            if success {
                UdacityClient.sharedInstance().localStudent = UdacityClient.sharedInstance().fromDictToStudentObject(studentArray: localStudentArray!)
                print(UdacityClient.sharedInstance().localStudent[0])
                UdacityClient.sharedInstance().getStudentLocations() { (success, studentArray, errorString) in
                    if success {
                        print("converting dict to student array")
                        UdacityClient.sharedInstance().students = UdacityClient.sharedInstance().fromDictToStudentObject(studentArray: studentArray!)
                        print("populating map")
                        self.mapView.addAnnotations(self.populateMap())
                    } else {
                        self.postSimpleAlert(errorString!)
                    }
                }
            } else {
                self.postSimpleAlert(errorString!)
            }
        }
    }
    
    func goToPostController() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PostLocationVC") as! PostLocationVC
        self.present(controller, animated: true, completion: nil)
    }
    
    func postSimpleAlert(_ title: String) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addLocation() {
        if !(UdacityClient.sharedInstance().localStudent[0].mapString.isEmpty) {
            let alertString = "You Have Already Posted a Student Location. Would You Like To Overwrite Your Location?"
            let alert = UIAlertController(title: nil, message: alertString, preferredStyle: UIAlertControllerStyle.alert)
            let overwrite = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { action in self.goToPostController() }
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(overwrite)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            self.goToPostController()
        }
    }
    
    func logout() {
        UdacityClient.sharedInstance().deleteSession() { (success, results, errorString) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                print(errorString)
                let alert = UIAlertController(title: nil, message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(dismiss)
                self.present(alert, animated: true, completion: nil)
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
