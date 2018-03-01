//
//  DetailedEventViewController.swift
//  
//
//  Created by Anson Ieung on 27/12/2017.
//

import UIKit


class DetailedEventViewController: UIViewController {

    @IBOutlet weak var EventTitle: UILabel!
    @IBOutlet weak var EventType: UILabel!
    @IBOutlet weak var StartDate: UILabel!
    @IBOutlet weak var EndDate: UILabel!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var DaysToGo: UILabel!
    
    
    
    var Event: events = events(Title: PassingEvent.0, StartDate: PassingEvent.1, EndDate: PassingEvent.2 , EventType: PassingEvent.3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event"
        
        //Title
        EventTitle.text = Event.Title
        switch Event.EventType {
        case .PH:
            EventTitle.textColor = UIColor.red
        case .SH:
            EventTitle.textColor = UIColor(red: 1, green: 142.0/255.0, blue: 80.0/255.0, alpha: 1)
        case .SE:
            EventTitle.textColor = UIColor(red: 97.0/255.0, green: 142.0/255.0, blue: 249.0/255.0, alpha: 1)
        default:
            EventTitle.textColor = UIColor(red: 97.0/255.0, green: 142.0/255.0, blue: 249.0/255.0, alpha: 1)
        }
        EventTitle.numberOfLines = 2
        EventTitle.adjustsFontSizeToFitWidth = true
        EventType.numberOfLines = 0
        
        //Event Type
        switch Event.EventType {
        case .PH:
            EventType.text = "Public Holiday"
        case .SH:
            EventType.text = "School Holiday"
        case .SE:
            EventType.text = "School Event"
        }
        
        //Start Date & End Date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        StartDate.text = "Start Date: \(formatter.string(from: Event.StartDate))"
        EndDate.text = "End Date: \(formatter.string(from: Event.EndDate))"
        
        //Duration
        var duration = Calendar.current.dateComponents([.day], from: Event.StartDate, to: Event.EndDate)
        
        if duration.day! > 0{
            Duration.text = "Duration: \(duration.day! + 1) days"
        }else{
            Duration.text = "Duration: \(duration.day! + 1) day"
        }
        
        
        //Days to Go
        let WeeksFromNow = Calendar.current.dateComponents([.weekOfYear], from: Date(), to: Event.StartDate).weekOfYear! + 1
        let DaysFromNow = Calendar.current.dateComponents([.day], from: Date(), to: Event.StartDate).day! + 1
        print(DaysFromNow, "Days from now")
        let calendar = Calendar(identifier: .gregorian)
        //let Today = calendar.da
        print(calendar.isDateInToday(Event.EndDate))
        if Event.EndDate < Date() && !calendar.isDateInToday(Event.EndDate){
            DaysToGo.text = "\(Event.Title) is over"
        }else if (Event.StartDate <= Date() && Event.EndDate >= Date()) || DaysFromNow == 0 || calendar.isDateInToday(Event.StartDate) || calendar.isDateInToday(Event.EndDate){
            DaysToGo.text = "It is now \(Event.Title)"
        }else if DaysFromNow == 1{
            DaysToGo.text = "1 more day before \(Event.Title)"
        }else if DaysFromNow < 14 {
            DaysToGo.text = "\(Event.Title) is in \(DaysFromNow) days"
        }else{
            DaysToGo.text = "\(Event.Title) is in \(WeeksFromNow) weeks"
        }
        DaysToGo.numberOfLines = 0
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    

}
