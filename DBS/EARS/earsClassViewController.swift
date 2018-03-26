//
//  earsClassViewController.swift
//  DBS
//
//  Created by SDG on 26/3/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

var earsChoice = ""
class earsClassViewController: UIViewController {
    
    @IBOutlet weak var classDisplay: UILabel!
    @IBOutlet var formButtons: [UIButton]!
    @IBOutlet var classButtons: [UIButton]!
    @IBOutlet var nonHighClassButtons: [UIButton]!
    @IBOutlet weak var backspaceOutlet: UIButton!
    @IBOutlet weak var viewClassmatesOutlet: UIButton!
    
    @IBAction func form(_ sender: Any) {
        classDisplay.textColor = UIColor.black
        classDisplay.text? = (sender as AnyObject).currentTitle as! String
        
        for i in formButtons {
            i.setTitleColor(UIColor.lightGray, for: .normal)
            i.isEnabled = false
        }
        for i in classButtons {
            i.setTitleColor(UIColor(red: 100/255, green: 200/255, blue: 200/255, alpha: 1), for: .normal)
            i.isEnabled = true
        }
        if classDisplay.text == "G10" || classDisplay.text == "G11" || classDisplay.text == "G12" {
            for i in nonHighClassButtons {
                i.setTitleColor(UIColor.lightGray, for: .normal)
                i.isEnabled = false
            }
        }
        backspaceOutlet.setTitleColor(UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1), for: .normal)
        backspaceOutlet.isEnabled = true
    }
    @IBAction func classChoices(_ sender: Any) {
        classDisplay.text? += (sender as AnyObject).currentTitle as! String
        for i in classButtons {
            i.setTitleColor(UIColor.lightGray, for: .normal)
            i.isEnabled = false
        }
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
                    i.setTitleColor(UIColor.lightGray, for: .normal)
                    i.isEnabled = false
                }
                for i in classButtons {
                    i.setTitleColor(UIColor(red: 100/255, green: 200/255, blue: 200/255, alpha: 1), for: .normal)
                    i.isEnabled = true
                }
                if classDisplay.text == "G10" || classDisplay.text == "G11" || classDisplay.text == "G12" {
                    for i in nonHighClassButtons {
                        i.setTitleColor(UIColor.lightGray, for: .normal)
                        i.isEnabled = false
                    }
                }
                backspaceOutlet.setTitleColor(UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1), for: .normal)
                backspaceOutlet.isEnabled = true
                
                viewClassmatesOutlet.setTitleColor(UIColor.lightGray, for: .normal)
                viewClassmatesOutlet.isEnabled = false
            default:
                resetDisplay()
            }
        }
    }
    @IBAction func viewClassmates(_ sender: Any) {
        earsChoice = classDisplay.text!
        print(earsChoice)
    }
    
    func resetDisplay() {
        for i in formButtons {
            i.setTitleColor(UIColor.orange, for: .normal)
            i.layer.cornerRadius = i.frame.width/2
            i.isEnabled = true
        }
        for i in classButtons {
            i.setTitleColor(UIColor.lightGray, for: .normal)
            i.layer.cornerRadius = i.frame.width/2
            i.isEnabled = false
        }
        classDisplay.text = "Enter class"
        classDisplay.textColor = UIColor.lightGray
        backspaceOutlet.setTitleColor(UIColor.lightGray, for: .normal)
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
        resetDisplay()
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

