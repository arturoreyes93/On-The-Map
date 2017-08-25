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
    
    var students : [Student]?

    @IBOutlet weak var userTableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.downloadData(UdacityClient.sharedInstance().userKey!)
        performUIUpdatesOnMain {
            self.userTableView.reloadData()
            print("success at loading students")
        }
        
    }
    
    func postSimpleAlert(_ title: String) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        
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
                        self.students = UdacityClient.sharedInstance().students + UdacityClient.sharedInstance().localStudent
                    } else {
                        self.postSimpleAlert(errorString!)
                    }
                }
            } else {
                self.postSimpleAlert(errorString!)
            }
        }
    }
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(students?.count)
        return (students!.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as UITableViewCell!
        let student = self.students?[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = "\(student?.firstName) \(student?.lastName)"
        cell?.detailTextLabel?.text = student?.mediaURL
        print("Success at returning Table View Cell")
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height)/6
    }
    

    
}
