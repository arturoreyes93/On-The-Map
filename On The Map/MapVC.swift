//
//  File.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/21/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit
import FBSDKCoreKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        loadMap()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let navigationBar = self.parent else {
            return
        }
        
        navigationBar.navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(addLocation))
        navigationBar.navigationItem.rightBarButtonItems?[0] = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(loadMap))
        navigationBar.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
        
    }
    
    func goToPostController() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PostLocationVC") as! PostLocationVC
        self.present(controller, animated: true, completion: nil)
    }
    
    func addLocation() {
        if !(StudentData.sharedInstance().localStudent[0].mapString.isEmpty) {
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
    
    public func logout() {
        
        if (FBSDKAccessToken.current()) != nil {
            let manager: FBSDKLoginManager = FBSDKLoginManager()
            manager.logOut()
            
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
            }
            
            UdacityClient.sharedInstance().deleteSession() { (success, results, errorString) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(controller, animated: true, completion: nil)
                } else {
                    self.activityIndicator.stopAnimating()
                    print(errorString!)
                    let alert = UIAlertController(title: nil, message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                    let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(dismiss)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func populateMap() -> [MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]()
        if let studentArray = StudentData.sharedInstance().students {
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
        }
        return annotations
    }
    
    
    @objc private func loadMap() {
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        UdacityClient.sharedInstance().downloadData() { (results, errorString) in
            if results != nil {
                self.mapView.addAnnotations(self.populateMap())
            } else {
                self.postSimpleAlert(errorString!)
            }
        }
    }
    
    // MARK: - MKMapViewDelegate

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
                if app.canOpenURL(URL(string: toOpen)!) {
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                    
                } else {
                    postSimpleAlert("Cannot open this URL")
                }
            }
        }
    }
}

extension UIViewController {
    
    func postSimpleAlert(_ title: String) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        
    }
}
