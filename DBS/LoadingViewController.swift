//
//  LoadingViewController.swift
//  DBS
//
//  Created by SDG on 23/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit
import CSVImporter

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ParseEvents()
        
        usleep(200000)
        print("Perform Segue")
        //performSegue(withIdentifier: "LoadingToHome", sender: self)
        
    }
    
    func ParseEvents(){
        //Parse Events
        DispatchQueue.main.async {
            let path = Bundle.main.path(forResource: "2017 - 2018 School Events New", ofType: "csv")!
            let importer = CSVImporter<[String: String]>(path: path)
            
            
            importer.startImportingRecords(structure: { (headerValues) -> Void in
            }) { $0 }.onFinish { (importedRecords) in
                for record in importedRecords {
                    
                    var formatter = DateFormatter()
                    formatter.dateFormat = "d/M/yyyy"
                    var EventStartDate = formatter.date(from: record["Start Date"]!)
                    var EventEndDate = formatter.date(from: record["End Date"]!)
                    
                    let string = record["Title"]!
                    var input = string
                    var output = ""
                    var didColon = false
                    for i in input{
                        if didColon{
                            output += "\(i)"
                        }
                        if i == Character(":"){
                            didColon = true
                        }
                    }
                    output.removeFirst()
                    
                    
                    
                    
                    switch record["Type"]! {
                    case "PH" :
                        EventsArray += [events(Title: output, StartDate: EventStartDate!, EndDate: EventEndDate!, EventType: .PH)]
                        
                        if EventStartDate! <= Date() && EventEndDate! >= Date(){
                            TodayEvent += [events(Title: output, StartDate: EventStartDate!, EndDate: EventEndDate!, EventType: .PH)]
                        }
                    case "SH" :
                        EventsArray += [events(Title: output, StartDate: EventStartDate!, EndDate: EventEndDate!, EventType: .SH)]
                        
                        if EventStartDate! <= Date() && EventEndDate! >= Date(){
                            TodayEvent += [events(Title: output, StartDate: EventStartDate!, EndDate: EventEndDate!, EventType: .SH)]
                            
                        }
                        
                    case "SE" :
                        EventsArray += [events(Title: output, StartDate: EventStartDate!, EndDate: EventEndDate!, EventType: .SE)]
                        
                        if EventStartDate! <= Date() && EventEndDate! >= Date(){
                            TodayEvent += [events(Title: output, StartDate: EventStartDate!, EndDate: EventEndDate!, EventType: .SE)]
                        }
                        
                    default:
                        print("ERROR")
                    }
                }
                
            }
            if EventsArray.isEmpty{
                //self.ParseEvents()
            }
        }
        
        
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
