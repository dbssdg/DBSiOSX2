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
}

protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

class dropDownBtn: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle("▼ \(string)", for: .normal)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGray
        
        dropView = dropDownView.init(frame: CGRect.init(x: 8, y: 100, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            //            if self.dropView.tableView.contentSize.height > 400 {
            //                self.height.constant = 400
            //            } else {
            //                self.height.constant = self.dropView.tableView.contentSize.height
            //            }
            self.height.constant = self.dropView.tableView.contentSize.height+8
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        updateSchoolRules(0)
        
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.backgroundColor = UIColor.clear
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.contentView.backgroundColor = UIColor.lightText
        cell.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.layer.shadowOpacity = 0.2
        cell.contentView.sendSubview(toBack: cell)
        return cell
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //
        //        cell.contentView.backgroundColor = UIColor.clear
        //
        //        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.frame.size.width - 20, height: 120))
        //
        //        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        //        whiteRoundedView.layer.masksToBounds = false
        //        whiteRoundedView.layer.cornerRadius = 2.0
        //        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        //        whiteRoundedView.layer.shadowOpacity = 0.2
        //
        //        cell.contentView.addSubview(whiteRoundedView)
        //        cell.contentView.sendSubview(toBack: whiteRoundedView)
        //
        //        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        updateSchoolRules(indexPath.row)
    }
    
    func updateSchoolRules(_ n: Int) {
        switch n {
            
        case 0:
            textView.attributedText = NSAttributedString(string: """
00
""")
            
        case 1:
            textView.attributedText = NSAttributedString(string: """
01
""")
            
        case 2:
            textView.attributedText = NSAttributedString(string: """
02
""")

        case 3:
            textView.attributedText = NSAttributedString(string: """
03
""")

        case 4:
            textView.attributedText = NSAttributedString(string: """
04
""")

        case 5:
            textView.attributedText = NSAttributedString(string: """
05
""")

            
        case 6:
            textView.attributedText = NSAttributedString(string: """
06
""")
            
        case 7:
            textView.attributedText = NSAttributedString(string: """
07
""")

        case 8:
            textView.attributedText = NSAttributedString(string: """
08
""")

        case 9:
            textView.attributedText = NSAttributedString(string: """
09
""")

        default: break
        }
    }
    

}
