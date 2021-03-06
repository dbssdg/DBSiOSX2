//
//  classmatesViewController.swift
//  DBS
//
//  Created by Ben Lou on 19/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

var classmateChoice = ""
class classmatesViewController: UIViewController {
    
    @IBOutlet weak var classDisplay: UILabel!
    @IBOutlet var formButtons: [UIButton]!
    @IBOutlet var classButtons: [UIButton]!
    @IBOutlet var nonHighClassButtons: [UIButton]!
    @IBOutlet weak var backspaceOutlet: UIButton!
    @IBOutlet weak var viewClassmatesOutlet: UIButton!
    
    @IBAction func form(_ sender: Any) {
        for i in formButtons {
            i.backgroundColor = .lightGray
            i.isEnabled = false
        }
        for i in classButtons {
            i.backgroundColor = UIColor(red: 100/255, green: 200/255, blue: 200/255, alpha: 1)
            i.isEnabled = true
        }
        if classDisplay.text == "G10" || classDisplay.text == "G11" || classDisplay.text == "G12" {
            for i in nonHighClassButtons {
                i.backgroundColor = .lightGray
                i.isEnabled = false
            }
        }
        
        classDisplay.textColor = UIColor.black
        classDisplay.text? = (sender as AnyObject).currentTitle as! String
        backspaceOutlet.backgroundColor = UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1)
        backspaceOutlet.isEnabled = true
    }
    @IBAction func classChoices(_ sender: Any) {
        for i in classButtons {
            i.backgroundColor = .lightGray
            i.isEnabled = false
        }
        classDisplay.text? += (sender as AnyObject).currentTitle as! String
        viewClassmatesOutlet.setTitleColor(UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1), for: .normal)
        viewClassmatesOutlet.isEnabled = true
    }
    @IBAction func backspace(_ sender: Any) {
        if (sender as AnyObject).currentTitle == "CLR" {
            resetDisplay()
        } else if (sender as AnyObject).currentTitle == "DEL" {
            switch "\((classDisplay.text?.last)!)" {
            case "D", "S", "G", "P", "M", "L", "A", "J", "T":
                classDisplay.text?.removeLast()
                for i in formButtons {
                    i.backgroundColor = .lightGray
                    i.isEnabled = false
                }
                for i in classButtons {
                    i.backgroundColor = UIColor(red: 100/255, green: 200/255, blue: 200/255, alpha: 1)
                    i.isEnabled = true
                }
                if classDisplay.text == "G10" || classDisplay.text == "G11" || classDisplay.text == "G12" {
                    for i in nonHighClassButtons {
                        i.backgroundColor = .lightGray
                        i.isEnabled = false
                    }
                }
                backspaceOutlet.backgroundColor = UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1)
                backspaceOutlet.isEnabled = true
                
                viewClassmatesOutlet.setTitleColor(UIColor.lightGray, for: .normal)
                viewClassmatesOutlet.isEnabled = false
            default:
                resetDisplay()
            }
        }
    }
    @IBAction func viewClassmates(_ sender: Any) {
        classmateChoice = classDisplay.text!
        print(classmateChoice)
    }
    
    func resetDisplay() {
        for i in formButtons {
            i.backgroundColor = .orange
            i.layer.cornerRadius = i.frame.width/2
            i.isEnabled = true
        }
        for i in classButtons {
            i.backgroundColor = .lightGray
            i.layer.cornerRadius = i.frame.width/2
            i.isEnabled = false
        }
        classDisplay.text = "Enter class"
        classDisplay.textColor = UIColor.lightGray
        backspaceOutlet.backgroundColor = .lightGray
        backspaceOutlet.setTitle("DEL", for: .normal)
        backspaceOutlet.layer.cornerRadius = backspaceOutlet.frame.width/2
        backspaceOutlet.isEnabled = false
        viewClassmatesOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        viewClassmatesOutlet.setTitle("View Classmates", for: .normal)
        viewClassmatesOutlet.isEnabled = false
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in formButtons {
            i.setTitleColor(.white, for: .normal)
        }
        for i in classButtons {
            i.setTitleColor(.white, for: .normal)
        }
        backspaceOutlet.setTitleColor(.white, for: .normal)
        
        resetDisplay()
        if let array = UserDefaults.standard.array(forKey: "profileData") {
            if array.count > 3 {
                classDisplay.text = array[3] as? String
                classDisplay.text?.removeLast(3)
                classDisplay.textColor = UIColor.black
                
                for i in formButtons {
                    i.backgroundColor = .lightGray
                    i.isEnabled = false
                }
                for i in classButtons {
                    i.backgroundColor = .lightGray
                    i.isEnabled = false
                }
                backspaceOutlet.backgroundColor = UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1)
                backspaceOutlet.setTitle("CLR", for: .normal)
                backspaceOutlet.isEnabled = true
                
                viewClassmatesOutlet.setTitleColor(UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1), for: .normal)
                viewClassmatesOutlet.setTitle("View My Classmates", for: .normal)
                viewClassmatesOutlet.isEnabled = true
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
