//
//  earsDateDetailViewController.swift
//  DBS
//
//  Created by Ben Lou on 21/3/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class earsDateDetailViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Event"
        
        var content = "\((earsByDate?.events[earsByDateSelected].title)!.replacingOccurrences(of: "\\", with: ""))\n"
        
        let array = earsByDate?.events[earsByDateSelected].period.components(separatedBy: " to ")
        if array![0] == "101" {
            content += "Morning Roll-call\n\n"
        } else if array![0] == "102" {
            content += "Afternoon Roll-call\n\n"
        } else if array![0] == "0" {
            content += "\n"
        } else if array![0] != array![1] {
            content += "Period \((earsByDate?.events[earsByDateSelected].period)!)\n\n"
        } else {
            content += "Period \((earsByDate?.events[earsByDateSelected].period.components(separatedBy: " to ")[0])!)\n\n"
        }
        
        content += """
        Location
        \((earsByDate?.events[earsByDateSelected].location)!)
        
        Application Date
        \((earsByDate?.events[earsByDateSelected].applyDate)!)
        
        Participants
        
        """
        for participant in (earsByDate?.events[earsByDateSelected].participant)! {
            content += "\(participant.capitalized)\n"
        }
        
        var attributedString = NSMutableAttributedString(string: content as NSString as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0)])
        let titleFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30.0)]
        var boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0)]
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            attributedString = NSMutableAttributedString(string: content as NSString as String, attributes:
                [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")))])
            boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")+4))]
        }
        
        attributedString.addAttributes(titleFontAttribute, range: (content as NSString).range(of: (earsByDate?.events[earsByDateSelected].title)!))
        print((earsByDate?.date)!)
        let wordsToBold = ["Location", "Application Date", "Participants"]
        for i in wordsToBold {
            attributedString.addAttributes(boldFontAttribute, range: (content as NSString).range(of: i))
        }
        textField.attributedText = attributedString
        textField.scrollsToTop = true
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
