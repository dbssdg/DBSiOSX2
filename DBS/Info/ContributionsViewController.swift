//
//  ContributionsViewController.swift
//  DBS
//
//  Created by SDG on 29/8/2018.
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
Diocesan Boys' School Official School Application Version 4.3.0

TEACHER-IN-CHARGE
Mr. Quintak Lee

APP DEVELOPERS
9S Louie Chi To (Department Head)
9G Lau Cheuk Hang
Mr. Chris Lee
10L Chan Yuen Ho

SOFTWARE DEVELOPMENT GROUP (SDG) 2018-2019
Chairman: 10L Ng Ching Wang Kelvin
Vice-Chairman: 9D Ieung Ho Kwan
Vice-Chairman: 10G Lai Hei Man Herman

ICONS
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
        let titles = ["TEACHER-IN-CHARGE", "APP DEVELOPERS", "SOFTWARE DEVELOPMENT GROUP (SDG) 2018-2019", "ICONS"]
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
