//
//  TodayViewController.swift
//  Timetable Widget
//
//  Created by Anson Ieung on 15/2/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    func UISetup(){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        label.text = "Timetable"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
