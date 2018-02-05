//
//  AllEventsTableViewController.swift
//  DBS
//
//  Created by Anson Ieung on 28/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit


class AllEventsTableViewController: UITableViewController {
    
    var NextEvent = events(Title: "", StartDate: Date(), EndDate: Date(), EventType: .SH )
    var NextEventindexPath = IndexPath(row: 0, section: 0)
    
    func WillAddCalendar(){
        let StringURL = "https://calendar.google.com/calendar/ical/g.dbs.edu.hk_tdmjqqq8vlv8keepi7a65f7j7s%40group.calendar.google.com/public/basic.ics"
        let url = URL(string: StringURL)
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for event in EventsArray{
            if event.EndDate >= Date(){
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
        }
        }
        
        
        
        //let AddCalendar = UIBarButtonItem(
        //let AddCalendar = UIBarButtonItem(image: UIImage(named: "imagename"), style: .plain, target: self, action: Selector("action")) // action:#selector(Class.MethodName) for swift 3
        let AddCalendar = UIBarButtonItem(title: "Add Calendar", style: .plain, target: self, action: #selector(WillAddCalendar))
        self.navigationItem.rightBarButtonItem  = AddCalendar
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        
        if !EventsFromNow.isEmpty{
            tableView.scrollToRow(at: NextEventindexPath, at: .top, animated: false)
        }
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
