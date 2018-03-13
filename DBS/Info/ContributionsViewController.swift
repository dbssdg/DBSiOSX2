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
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.text = "Acknowledgements"
        self.navigationItem.titleView = label
        
        let string = """
Diocesan Boys' School Official School Application
Version 4.0

TEACHER-IN-CHARGE
Mr. Chris Lee

SOFTWARE DEVELOPMENT GROUP (SDG) CHAIRMAN
Ng Ching Wang Kelvin

APP DEVELOPERS
Ieung Ho Kwan, Louie Chi To, Lau Cheuk Hang & Chan Yuen Ho

ICONS
https://www.flaticon.com
https://icons8.com
""" as NSString
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16.5)])
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0)]
        let titles = ["TEACHER-IN-CHARGE", "SOFTWARE DEVELOPMENT GROUP (SDG) CHAIRMAN", "APP DEVELOPERS", "ICONS"]
        for i in titles {
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: i))
        }
        
        credits.attributedText = attributedString
        credits.isEditable = false
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
