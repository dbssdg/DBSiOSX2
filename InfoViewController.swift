//
//  InfoViewController.swift
//  DBS
//
//  Created by SDG on 20/9/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

var functions = ["Links, Contact & Steps", "School Hymn", "School Rules", "Teachers", "Classmates", "Photo Album", "Credits"]
var functionIcon = ["worldwide", "piano", "SchoolRules", "Teacher", "Student", "photos-1", "star"]

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewView: UIView!
    @IBOutlet weak var calendar: UIButton!
    @IBOutlet weak var about: UIButton!
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var timetable: UIButton!
    
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var ButtonView: UIView!
    @IBOutlet weak var customizeButton: UIButton!
    
    let buttonGapRatio = 43
    
    @IBAction func customizeButton(_ sender: Any) {
        if customizeButton.currentTitle! == "Customize" {
            customizeButton.setTitle("Done", for: .normal)
            calendar.isOpaque = false
            calendar.isEnabled = false
            about.isOpaque = false
            about.isEnabled = false
            map.isOpaque = false
            map.isEnabled = false
            timetable.isOpaque = false
            timetable.isEnabled = false
            menuTable.isEditing = true
            
        } else if customizeButton.currentTitle! == "Done" {
            customizeButton.setTitle("Customize", for: .normal)
            calendar.isOpaque = true
            calendar.isEnabled = true
            about.isOpaque = true
            about.isEnabled = true
            map.isOpaque = true
            map.isEnabled = true
            timetable.isOpaque = true
            timetable.isEnabled = true
            menuTable.isEditing = false
            
            UserDefaults.standard.set(functions, forKey: "functionsCustomization")
            UserDefaults.standard.set(functionIcon, forKey: "functionIcon")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeButton.setTitle("Customize", for: .normal)
        self.UISetup()
        
        menuTable.dataSource = self
        menuTable.delegate = self
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        menuTable.isScrollEnabled = false
        
        if let x = UserDefaults.standard.object(forKey: "functionsCustomization") as? [String] {
            functions = x
        }
        if let x = UserDefaults.standard.object(forKey: "functionIcon") as? [String] {
            functionIcon = x
            
        }
        menuTable.reloadData()
        
    }
    
    
    func UISetup() {
        let selfWidth = self.view.frame.width
        let selfHeight = self.view.frame.height
        
        
        let ButtonSize = selfWidth/CGFloat(buttonGapRatio)*20
        let ButtonGap = selfWidth/CGFloat(buttonGapRatio)
        let Radius = ButtonSize * 0.075
        
        ButtonView.frame = CGRect(x: 0, y: selfHeight * 0, width: selfWidth, height: selfWidth)

        menuTable.frame = CGRect(x: 0, y: ButtonView.frame.height , width: selfWidth, height: ButtonView.frame.height + self.view.frame.height * 0.1)
        
        calendar.layer.cornerRadius = Radius
        calendar.clipsToBounds = true
        calendar.layer.frame = CGRect(x: ButtonGap  , y: ButtonGap, width: ButtonSize, height: ButtonSize)
        
        about.layer.cornerRadius = Radius
        about.clipsToBounds = true
        about.layer.frame = CGRect(x: selfWidth - ButtonGap - ButtonSize  , y: ButtonGap, width: ButtonSize, height: ButtonSize)
        
        map.layer.cornerRadius = Radius
        map.clipsToBounds = true
        map.layer.frame = CGRect(x: ButtonGap , y: selfWidth - ButtonGap - ButtonSize, width: ButtonSize, height: ButtonSize)
        
        
        timetable.layer.cornerRadius = Radius
        timetable.clipsToBounds = true
        timetable.layer.frame = CGRect(x: selfWidth - ButtonGap - ButtonSize , y: selfWidth - ButtonGap - ButtonSize, width: ButtonSize, height: ButtonSize)
    
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: timetable.frame.origin.y + timetable.frame.size.height)
        
    } 

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell")! as UITableViewCell
        cell.textLabel?.text = functions[indexPath.row]
        cell.imageView?.image = UIImage(named: "\(functionIcon[indexPath.row])")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = functions[sourceIndexPath.row]
        let movedIcon = functionIcon[sourceIndexPath.row]
        functions.remove(at: sourceIndexPath.row)
        functions.insert(movedObject, at: destinationIndexPath.row)
        functionIcon.remove(at: sourceIndexPath.row)
        functionIcon.insert(movedIcon, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if functions[indexPath.row] == "Classmates" && loginID == "" {
            let loginAlert = UIAlertController(title: "Login", message: "Please login before you see your classmates.", preferredStyle: .alert)
            loginAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            func goToLoginPage(action: UIAlertAction) { self.tabBarController?.selectedIndex = 3 }
            loginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: goToLoginPage))
            present(loginAlert, animated: true)
        } else {
            performSegue(withIdentifier: "\(functions[indexPath.row]) Segue", sender: self)
        }
    }
    
    
}
