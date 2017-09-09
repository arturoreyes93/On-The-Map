//
//  ListVC.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/29/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit


class ListVC: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.activityIndicator.hidesWhenStopped = true
        if (StudentData.sharedInstance().students) != nil {
            performUIUpdatesOnMain {
                self.userTableView.reloadData()
                print("success at loading students")
            }
        }
    }
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let students = StudentData.sharedInstance().students!
        return (students.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as UITableViewCell!
        let students = StudentData.sharedInstance().students!
        let student = students[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell?.detailTextLabel?.text = student.mediaURL
        cell?.imageView?.image = UIImage(named: "icon_pin")
        print("Success at returning Table View Cell")
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let students = StudentData.sharedInstance().students!
        let student = students[(indexPath as NSIndexPath).row]
        let app = UIApplication.shared
        if let toOpen = URL(string: (student.mediaURL)) {
            if app.canOpenURL(toOpen) {
                app.open(toOpen, options: [:], completionHandler: nil)
                
            } else {
                postSimpleAlert("Cannot open this URL: \(student.mediaURL)")
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowsPerView: CGFloat = 10
        return (self.view.frame.height)/rowsPerView
    }
    

    
}
