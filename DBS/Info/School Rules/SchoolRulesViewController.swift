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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let exit = UIButton(frame: CGRect(x: 8, y: 8, width: 40, height: 40))
        exit.setTitle("╳", for: .normal)
        exit.setTitleColor(.white, for: .normal)
        exit.backgroundColor = .gray
        exit.layer.cornerRadius = self.view.frame.height/2
        exit.layer.zPosition = 100000
        exit.addTarget(self, action: #selector(exitView), for: .touchUpInside)
        self.view.addSubview(exit)
        
        textView.frame = CGRect(x: 8, y: 0, width: self.view.frame.width-16, height: self.view.frame.height-40-16)
        textView.layer.borderWidth = 5
        textView.frame.origin.y = self.view.frame.height/9 + 200
        textView.frame.size.height = self.view.frame.height - textView.frame.origin.y
        textView.center = self.view.center
        textView.textAlignment = NSTextAlignment.justified
        textView.backgroundColor = UIColor.clear
        print(textView.frame)
        
        
        // Update UITextView font size and colour
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.white
        
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.font = UIFont(name: "Verdana", size: 17)
        
        // Make UITextView corners rounded
        textView.layer.cornerRadius = 10
        
        
        // Make UITextView Not Editable
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        
        self.view.addSubview(textView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
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
        
//        if UITableViewDelegate.dropDownPressed(string: dropDownOptions[0])  {
//            textView.text  = { """
//        a. Fighting and/or Bullying.
//        b. Willful damage to school property, e.g. trees, furniture, paint, newspaper, notices.
//        (This is a serious offense. Accidental damage, if reported immediately, is not punished.)
//        c. Shouting, playing games and rowdy behaviour in classrooms.
//        d. Creating a disturbance when going from one room to another. (Boys should take a route passing the least number of classrooms.)
//        e. Disrespectful behavior to janitors, watchmen and supporting staff.
//        f. Taking into classroom or the Hall any radios, cameras, tape-recorders or electronic equipment without permission.
//        g. Duplicating and / or possessing classroom or special room key.
//        h. Running or loitering in the corridors, climbing trees, running up or down the banks.
//        i. Drinking and eating in the Hall, in the Gymnasium, in the classrooms or in other study room.
//        j. Playing ball games and keeping basketball, football or volleyball in the classroom. (Boys should leave them to the gymnasium keeper.)
//        k. Staying in the tuck shop during school hours other than recess and lunch time.
//        l. Using the chapel for any purpose other than private prayer or quiet meditation or without prior approval from the school.
//        m. Scattering rubbish instead of putting it in the bins provided.
//        n. Walking up and down the School Drive; boys must use the footpath provided.
//        o. Throwing or slinging stones or other objects likely to cause injury.
//        p. Putting up notices without proper authorization and/or writing on walls.
//        q. Entering the Gymnasium and tennis courts when not wearing rubber shoes.
//        r. Playing balls other than Ping-Pong balls in the Covered Playground.
//        s. Playing card games without teacher supervision.
//        t. Handling any tools or equipment belonging to the teaching or supporting staff without permission.
//        u. The possession of a pager or a mobile phone without prior approval from the Headmaster.
//        v. Using the lift in the SIP and Michiko Miyakawa Building.
//        w. Breaking into the server of the School or to access files not opened to students.
//        x. Using of foul language.
//        y. Smoking, spitting, gambling, chewing gum.
//        """ }()
//
//        }
//
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func exitView() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

