//
//  timetableViewController.swift
//  DBS
//
//  Created by Ben Lou on 19/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

var timetableChoice = ""
class timetableViewController: UIViewController {
    
    @IBOutlet weak var classDisplay: UILabel!
    @IBOutlet var formButtons: [UIButton]!
    @IBOutlet var classButtons: [UIButton]!
    @IBOutlet var nonHighClassButtons: [UIButton]!
    @IBOutlet weak var backspaceOutlet: UIButton!
    @IBOutlet weak var viewTimetableOutlet: UIButton!
    
    @IBAction func form(_ sender: Any) {
        classDisplay.textColor = UIColor.black
        classDisplay.text? = (sender as AnyObject).currentTitle as! String
        
        for i in formButtons {
            i.backgroundColor = .lightGray
            i.isEnabled = false
        }
        for i in classButtons {
            i.backgroundColor = UIColor(red: 75/255, green: 200/255, blue: 200/255, alpha: 1)
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
    }
    @IBAction func classChoices(_ sender: Any) {
        classDisplay.text? += (sender as AnyObject).currentTitle as! String
        for i in classButtons {
            i.backgroundColor = .lightGray
            i.isEnabled = false
        }
        viewTimetableOutlet.setTitleColor(UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1), for: .normal)
        viewTimetableOutlet.isEnabled = true
        
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
                
                viewTimetableOutlet.setTitleColor(UIColor.lightGray, for: .normal)
                viewTimetableOutlet.isEnabled = false
            default:
                resetDisplay()
            }
        }
    }
    @IBAction func viewTimetable(_ sender: Any) {
        timetableChoice = classDisplay.text!
        print(timetableChoice)
        performSegue(withIdentifier: "My Timetable", sender: self)
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
        viewTimetableOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        viewTimetableOutlet.setTitle("View Timetable", for: .normal)
        viewTimetableOutlet.isEnabled = false
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        // Do any additional setup after loading the view.
    }
    
    func goToTimetable() {
        timetableChoice = self.navigationItem.rightBarButtonItem!.title!
        performSegue(withIdentifier: "My Timetable", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let teacherButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(goToTimetable))
        
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
                
                viewTimetableOutlet.setTitleColor(UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1), for: .normal)
                viewTimetableOutlet.setTitle("View My Timetable", for: .normal)
                viewTimetableOutlet.isEnabled = true
            } else {
                teacherButton.title = array[0] as? String
                self.navigationItem.rightBarButtonItem  = teacherButton
            }
        }
        switch classDisplay.text! {
        case "G10G", "G10L", "G11G", "G11L", "G12G", "G12L":
            resetDisplay()
            classDisplay.adjustsFontSizeToFitWidth = true
            classDisplay.text = " Timetable for IB boys will be available soon "
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                if self.classDisplay.text == " Timetable for IB boys will be available soon " {
                    self.classDisplay.text = "Enter class"
                }
            })
        default: break
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

