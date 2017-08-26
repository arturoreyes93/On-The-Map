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
    
    var students : [Student] = [Student]()

    @IBOutlet weak var userTableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UdacityClient.sharedInstance().downloadData() { (results, errorString) in
            if let studentData = results {
                self.students = studentData
                performUIUpdatesOnMain {
                    self.userTableView.reloadData()
                    print("success at loading students")
                }
            } else {
                self.postSimpleAlert(errorString!)
            }
        }
    }
    
    func postSimpleAlert(_ title: String) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(students.count)
        return (students.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as UITableViewCell!
        let student = self.students[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell?.detailTextLabel?.text = student.mediaURL
        cell?.imageView?.image = UIImage(named: "icon_pin")
        print("Success at returning Table View Cell")
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.students[(indexPath as NSIndexPath).row]
        let app = UIApplication.shared
        if let toOpen = URL(string: student.mediaURL) {
            if app.canOpenURL(toOpen) {
                app.open(toOpen, options: [:], completionHandler: nil)
                
            } else {
                postSimpleAlert("Cannot open this URL: \(student.mediaURL)")
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height)/10
    }
    

    
}
