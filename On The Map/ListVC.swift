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
    
    var students = UdacityClient.sharedInstance().students + UdacityClient.sharedInstance().localStudent
    
    @IBOutlet weak var userTableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        students = UdacityClient.sharedInstance().students + UdacityClient.sharedInstance().localStudent
        performUIUpdatesOnMain {
            self.userTableView.reloadData()
            print("success at loading students")
        }
        
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
        print("Success at returning Table View Cell")
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height)/6
    }
    

    
}
