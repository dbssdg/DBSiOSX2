//
//  AllEventsTableViewController.swift
//  DBS
//
//  Created by Anson Ieung on 28/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import SystemConfiguration

class AllEventsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, UISearchBarDelegate {
    
    var NextEvent = events(Title: "", StartDate: Date(), EndDate: Date(), EventType: .SH )
    var NextEventindexPath = IndexPath(row: 0, section: 0)
    
    var filteredEvents = [events]()
    let EventsSearch = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        EventsSearch.searchBar.delegate = self
        
        let calendar = Calendar(identifier: .gregorian)
        
        tableView.frame = self.view.frame
        
        if let y = self.navigationController?.navigationBar{
            tableView.frame.origin.y = y.frame.height
        }else{
            tableView.frame.origin.y = self.view.frame.height * 0.1
        }
        
        for event in EventsArray{
            if event.EndDate >= Date() || (calendar.isDateInToday(event.EndDate)){
                EventsFromNow += [event]
            }
            
        }
        if EventsFromNow.isEmpty{
            NextEvent = EventsArray[0]
        }else{
        NextEvent = EventsFromNow[0]
        
        var count = 0
        
        DispatchQueue.main.async {
            for i in EventsArray{
                if i.Title == self.NextEvent.Title{
                    self.NextEventindexPath = IndexPath(row: count, section: 0)
                    break
                }
                count += 1
            }
            self.viewDidAppear(true)
        }
        }
        
        
        
        
        
        //let AddCalendar = UIBarButtonItem(
        //let AddCalendar = UIBarButtonItem(image: UIImage(named: "imagename"), style: .plain, target: self, action: Selector("action")) // action:#selector(Class.MethodName) for swift 3
        //let AddCalendar = UIBarButtonItem(title: "Add Calendar", style: .plain, target: self, action: #selector(ActionSheetFunc))
        
        
        self.registerForPreviewing(with: self, sourceView: tableView)
        
        if !EventsFromNow.isEmpty{
            if NextEventindexPath != [0,0]{
            tableView.scrollToRow(at: [NextEventindexPath.row - 1, 0], at: .top, animated: false)
            }else{
            tableView.scrollToRow(at: NextEventindexPath, at: .top, animated: false)
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var temp = [events]()
        for i in EventsArray{
            var duplicated = false
            for j in temp{
                if i.Title == j.Title{
                    duplicated = true
                }
            }
            if duplicated == false{
                temp += [i]
            }
        }
        
        EventsArray = temp
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if !EventsFromNow.isEmpty{
            tableView.scrollToRow(at: NextEventindexPath, at: .top, animated: false)
        }
    }
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return EventsFromNow.count
    }
*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EventsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell", for: indexPath) as! AllEventTableViewCell
        let CellEvent = EventsArray[indexPath.row]
        
        if !EventsArray.isEmpty{
            //Title
            cell.title.text = CellEvent.Title
            cell.title.adjustsFontSizeToFitWidth = true
            
            //Subtitle
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M/yy"
            if CellEvent.StartDate == CellEvent.EndDate{
                cell.dateTitle.text = formatter.string(from: CellEvent.StartDate)
            }else{
                cell.dateTitle.text = "\(formatter.string(from: CellEvent.StartDate)) - \(formatter.string(from: CellEvent.EndDate))"
            }
            
            //Event Type Bar
            switch CellEvent.EventType {
            case .PH:
                cell.EventTypeBar.backgroundColor = UIColor.red
            case .SE:
                cell.EventTypeBar.backgroundColor = UIColor(red: 97.0/255.0, green: 142.0/255.0, blue: 249.0/255.0, alpha: 1)
            case .SH:
                cell.EventTypeBar.backgroundColor = UIColor(red: 1, green: 142.0/255.0, blue: 80.0/255.0, alpha: 1)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SelectedEvent = EventsArray[indexPath.row]
        print(SelectedEvent, indexPath.row)
        PassingEvent = (SelectedEvent.Title, SelectedEvent.StartDate, SelectedEvent.EndDate, SelectedEvent.EventType)
        performSegue(withIdentifier: "All Events to Detail Event", sender: self)
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        previewingContext.sourceRect = tableView.cellForRow(at: indexPath)!.frame
        
        let SelectedEvent = EventsArray[indexPath.row]
        PassingEvent = (SelectedEvent.Title, SelectedEvent.StartDate, SelectedEvent.EndDate, SelectedEvent.EventType)
        let destViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Detail Event") as! DetailedEventViewController
        return destViewController
        
        
        return nil
    }
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
   

}

