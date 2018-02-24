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
        default:
            viewDidLoad()
        }
    }
    @IBAction func viewClassmates(_ sender: Any) {
        classmateChoice = classDisplay.text!
        print(classmateChoice)
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        backspaceOutlet.layer.cornerRadius = backspaceOutlet.frame.width/2
        backspaceOutlet.isEnabled = false
        viewClassmatesOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        viewClassmatesOutlet.isEnabled = false
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
