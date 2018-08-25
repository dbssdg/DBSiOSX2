//
//  File.swift
//  DBS
//
//  Created by Anson Ieung on 29/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import Foundation
import CSVImporter

func EventParser() {
    
    _ = [events]()
    _ = [events]()
    _ = 3
    
    let path = Bundle.main.path(forResource: "2017 - 2018 School Events New", ofType: "csv")!

    
    
    let importer = CSVImporter<[String: String]>(path: path)
    _ = importer.startImportingRecords(structure: { (headerValues) -> Void in
    }) { $0 }.onFinish { (importedRecords) in
        for record in importedRecords {
            
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M/yyyy"
            let EventStartDate = formatter.date(from: record["Start Date"]!)
            let EventEndDate = formatter.date(from: record["End Date"]!)
            
            let string = record["Title"]!
            let input = string
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
    
    
    
   
    
}
