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
        print(UIScreen.main.bounds)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.text = "Acknowledgements"
        self.navigationItem.titleView = label
        
        let string = """
Diocesan Boys' School Official School Application Version 4.1.1

TEACHER-IN-CHARGE
Mr. Chris Lee

SOFTWARE DEVELOPMENT GROUP (SDG) CHAIRMAN
Ng Ching Wang Kelvin

APP DEVELOPERS
Louie Chi To
Ieung Ho Kwan
Lau Cheuk Hang
Chan Yuen Ho

REFERENCES OF ICONS
https://www.flaticon.com
https://icons8.com
""" as NSString
        var attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)])
        var boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            attributedString = NSMutableAttributedString(string: string as NSString as String, attributes:
                [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")+4))])
            boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")))]
        }
        let titles = ["TEACHER-IN-CHARGE", "SOFTWARE DEVELOPMENT GROUP (SDG) CHAIRMAN", "APP DEVELOPERS", "REFERENCES OF ICONS"]
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
