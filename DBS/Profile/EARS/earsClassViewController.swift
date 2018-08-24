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
    @IBOutlet weak var viewEARSOutlet: UIButton!
    
    @IBAction func form(_ sender: Any) {
        classDisplay.textColor = UIColor.black
        classDisplay.text? = (sender as AnyObject).currentTitle as! String
        
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
    }
    @IBAction func classChoices(_ sender: Any) {
        classDisplay.text? += (sender as AnyObject).currentTitle as! String
        for i in classButtons {
            i.backgroundColor = .lightGray
            i.isEnabled = false
        }
        viewEARSOutlet.setTitleColor(UIColor(red: 48/255, green: 123/255, blue: 246/255, alpha: 1), for: .normal)
        viewEARSOutlet.isEnabled = true
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
                
                viewEARSOutlet.setTitleColor(UIColor.lightGray, for: .normal)
                viewEARSOutlet.isEnabled = false
            default:
                resetDisplay()
            }
        }
    }
    @IBAction func viewEARS(_ sender: Any) {
        earsChoice = classDisplay.text!
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
        viewEARSOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        viewEARSOutlet.setTitle("View EARS", for: .normal)
        viewEARSOutlet.isEnabled = false
        
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
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetDisplay()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

