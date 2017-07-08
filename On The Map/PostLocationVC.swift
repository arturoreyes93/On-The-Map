//
//  PostLocationVC.swift
//  On The Map
//
//  Created by Arturo Reyes on 7/8/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

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
