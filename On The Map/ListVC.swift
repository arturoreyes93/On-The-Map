//
//  ListVC.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/29/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

class ListVC: UITableViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    
    var students = UdacityClient.sharedInstance().students
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userTableView.reloadData()
        print("success at loading students")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (students?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
        let student = self.students?[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(student?.firstName) \(student?.lastName)"
        cell.detailTextLabel?.text = student?.mediaURL
        print("Success at returning Table View Cell")
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height)/6
    }
    
}
