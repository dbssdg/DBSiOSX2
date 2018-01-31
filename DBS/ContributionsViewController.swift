//
//  ContributionsViewController.swift
//  DBS
//
//  Created by SDG on 17/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class ContributionsViewController: UIViewController {

    @IBOutlet weak var credits: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let string = """
TEACHER-IN-CHARGE
Mr. Chris Lee

SOFTWARE DEVELOPMENT GROUP (SDG)
Ng Ching Wang Kelvin

APP DEVELOPERS
Louie Chi To
Ieung Ho Kwan
Chan Yuen Ho
Lau Cheuk Hang

""" as NSString
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 24.0)])
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0)]
        let titles = ["TEACHER-IN-CHARGE", "SOFTWARE DEVELOPMENT GROUP (SDG)", "APP DEVELOPERS"]
        for i in titles {
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: i))
        }
        
        credits.attributedText = attributedString
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
