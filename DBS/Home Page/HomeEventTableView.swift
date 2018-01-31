//
//  HomeEventView.swift
//  DBS
//
//  Created by Anson Ieung on 1/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit


class HomeEventTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var Events = [events(Title: "output", StartDate: Date(), EndDate: Date(), EventType: .PH)]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("function run")
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AllEventTableViewCell()
        
        
        
        //Title
        cell.title.text = Events[indexPath.row].Title
        cell.title.adjustsFontSizeToFitWidth = true
        
        //Subtitle
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        if Events[indexPath.row].StartDate == Events[indexPath.row].EndDate{
            cell.dateTitle.text = formatter.string(from: Events[indexPath.row].StartDate)
        }else{
            cell.dateTitle.text = "\(formatter.string(from: Events[indexPath.row].StartDate)) - \(formatter.string(from: Events[indexPath.row].EndDate))"
        }
        
        //Event Type Bar
        switch Events[indexPath.row].EventType {
        case .PH:
            cell.EventTypeBar.backgroundColor = UIColor.red
        case .SE:
            cell.EventTypeBar.backgroundColor = UIColor(red: 97.0/255.0, green: 142.0/255.0, blue: 249.0/255.0, alpha: 1)
        case .SH:
            cell.EventTypeBar.backgroundColor = UIColor(red: 1, green: 142.0/255.0, blue: 80.0/255.0, alpha: 1)
        }
        
        return cell
    }
    
    
    var selfFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("HI")
    }
    
    
    
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
 
    
}
/*
extension HomeEventTableView{
    convenience init(array: [events]) {
        self.init(array: array)
        self.Events = array
    }
}
*/
