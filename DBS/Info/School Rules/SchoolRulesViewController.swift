//
//  SchoolRulesViewController.swift
//  DBS
//
//  Created by SDG on 10/10/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

let textView = UITextView()
class SchoolRulesViewController: UIViewController {


    var button = dropDownBtn()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usleep(5000)
        textView.frame.size.width = self.view.frame.width - 16
        textView.center.x = self.view.center.x
//        textView.frame.origin.y = self.view.frame.origin.y + 40 + 16
        textView.center.y = self.view.center.y
        textView.frame.origin.y = self.view.frame.height / 5.5
        textView.layoutIfNeeded()
        textView.sizeToFit()
        textView.frame.size.height = self.view.frame.height - textView.frame.origin.y
        textView.layer.borderWidth = 1
        textView.textAlignment = NSTextAlignment.justified
        textView.backgroundColor = UIColor.clear
        print(self.view.frame.height, textView.frame.origin.y, textView.frame.height)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let exit = UIButton(frame: CGRect(x: 8, y: 8, width: 40, height: 40))
//        exit.setTitle("╳", for: .normal)
//        exit.setTitleColor(.white, for: .normal)
//        exit.backgroundColor = .gray
//        exit.layer.cornerRadius = self.view.frame.height/2
//        exit.layer.zPosition = 100000
//        exit.addTarget(self, action: #selector(exitView), for: .touchUpInside)
//        self.view.addSubview(exit)
        
        self.title = "School Rules"
        
        // Update UITextView font size and colour
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.white
        
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.font = UIFont(name: "Verdana", size: 17)
        
        // Make UITextView corners rounded
        textView.layer.cornerRadius = 10
        
        // Make UITextView Not Editable
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        
        textView.layer.zPosition = -1000
        
        self.view.addSubview(textView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        //Configure the button
        button = dropDownBtn.init(frame: CGRect(x: 8, y: 8, width: self.view.frame.width, height: self.view.frame.height ))
        
        
        button.setTitle("▼ Introduction", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        //Add Button to the View Controller
        self.view.addSubview(button)
        
        //button Constraints
//        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.view.frame.width-16).isActive = true
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height/9).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        print(button.frame)
//        button.frame = CGRect(x: 8, y: 8, width: self.view.frame.width, height: self.view.frame.height)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        //Set the drop down menu's options
        button.dropView.dropDownOptions = ["Introduction", "Forbidden", "Out of Bounds", "The Hall", "Physical Education", "Lateness", "Absence/Early leave from School", "Prefects", "Rules of using Mobile Phone in School Campus", "Uniform", "Rules for Using Lockers"]
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func exitView() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

