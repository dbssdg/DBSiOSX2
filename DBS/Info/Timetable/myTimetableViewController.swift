//
//  myTimetableViewController.swift
//  DBS
//
//  Created by SDG on 5/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import SystemConfiguration

struct Lessons : Decodable {
    let name : [String]
    let teacher : [String]
    let isActivityPeriod : Bool
    let isElective : Bool
}
struct Lesson: Decodable {
    let lesson : [Lessons]
}
struct Classes : Decodable {
    let name : String
    let teacher : String
    let day : [Lesson]
}
struct Timetable : Decodable {
    let `class` : [Classes]
}
struct TimetableJSON : Decodable {
    let timetable : Timetable
}
var timetable : TimetableJSON?
var formSection = [String]()
let classArrayLow = ["D", "S", "G", "P", "M", "L", "A", "J", "T"]
let classArrayHigh = ["D", "S", "P", "M", "J", "T"]



class myTimetableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TwicketSegmentedControlDelegate {
    
    @IBOutlet weak var timetableTable: UITableView!
    
    
    var group = ""
    var form = ""
    
    var selectedSegment = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentedControl()
        self.title = timetableChoice
        timetableTable.separatorColor = UIColor.gray
        timetableTable.separatorStyle = .singleLineEtched
        
//        selectedSegment = 1
        
        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
        func backToInfoPage(action: UIAlertAction) { navigationController?.popViewController(animated: true) }
        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: backToInfoPage))
        
        let noticeButton = UIBarButtonItem(title: "Notice", style: .plain, target: self, action: #selector(notice))
        self.navigationItem.rightBarButtonItem = noticeButton
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        group = "\(timetableChoice.last!)"
        form = timetableChoice
        print(timetableChoice)
        form.removeLast()
        form.removeFirst()
        print(form, group)
        
        let jsonURL = "http://cl.dbs.edu.hk/mobile/common/timetable/timetable\(form).json"
        print(jsonURL)
        let url = URL(string: jsonURL)
        
        if isInternetAvailable() {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                do {
                    if data != nil {
                        timetable = try JSONDecoder().decode(TimetableJSON.self, from: data!)
                    }
                    
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        
                        if timetable?.timetable.`class`.count == 0 {
                            self.present(networkAlert, animated: true)
                        }
                        self.timetableTable.reloadData()
                        self.title? += " (\((timetable?.timetable.`class`[formSection.index(of: self.group)!].teacher)!))"
                    }
                } catch {
                    self.present(networkAlert, animated: true)
                    print("ERROR")
                }
            }.resume()
        } else {
            present(networkAlert, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    func notice() {
        performSegue(withIdentifier: "Timetable Notice", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timetableCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        
        var out = ""
        if Int(form)! >= 7 && Int(form)! <= 9 {
            formSection = classArrayLow
        } else if Int(form)! >= 10 && Int(form)! <= 12 {
            formSection = classArrayHigh
        }
        
        if timetable != nil {
            print((timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].name)!)
            for i in (timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].name)! {
                out += "\(i.decodeUrl()) | "
            }
            if (timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].isActivityPeriod)! == true || ((timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].name)![0] == "" && indexPath.row != 5){
                out = "Activity Period   "
            }
            out.removeLast(3)
            if out.count > 30{
                
            }
            cell.textLabel?.text = out
            
            out = ""
            for i in (timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].teacher)! {
                out += "\(i.uppercased()) | "
            }
            out.removeLast(3)
            cell.detailTextLabel?.text = out
        }
        
        cell.textLabel?.numberOfLines = Int((self.view.frame.height-40)/(6+2)/30)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height-40)/(6+2)
    }
    
    func didSelect(_ segmentIndex: Int) {
        selectedSegment = segmentIndex
        self.timetableTable.reloadData()
    }
    
    
    func setUpSegmentedControl() {
        
        //Check if there is segmented Control
        var hasSegmentedControl = false
        let subviews = self.view.subviews
        for subview in subviews{
            if subview.tag == 100{
                hasSegmentedControl = true
            }
        }
        
        if hasSegmentedControl == false{
            let titles = ["Mon", "Tue", "Wed", "Thur", "Fri"]
            let frame = CGRect(x: self.view.frame.width * 0.05 , y: self.view.frame.height - ( (tabBarController?.tabBar.frame.height == nil) ? 15 : (tabBarController?.tabBar.frame.height)! ) - 40, width: self.view.frame.width * 0.9, height: 40)
            let segmentedControl = TwicketSegmentedControl(frame: frame)
            segmentedControl.setSegmentItems(titles)
            segmentedControl.delegate = self as? TwicketSegmentedControlDelegate
            
            //Init Day
            var DayToDisplay = 0
            var calendar = Calendar(identifier: .gregorian)
            calendar.firstWeekday = -1
            
            let CurrentDay = calendar.component(.weekday, from: Date()) - 1
            let TimeBoundString = "16:00"
            let formatter : DateFormatter = {
                let dateFormatter  = DateFormatter()
                dateFormatter.timeZone = Calendar.current.timeZone
                dateFormatter.locale = Calendar.current.locale
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter
            }()
            //let TimeBound = formatter.date(from: TimeBoundString)
            //let CurrentTime = calendar.dateComponents([.hour], from: Date())
            let TimeBoundary = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: Date())
            DayToDisplay = CurrentDay
            print(DayToDisplay)
            
            if Date() < TimeBoundary!{
                print("Before")
                DayToDisplay -= 1
                if DayToDisplay == 5 || DayToDisplay == 6 || DayToDisplay == -1{
                    DayToDisplay = 0
                }
            }else{
                print("After")
                if DayToDisplay == 5 || DayToDisplay == 6 || DayToDisplay == 7{
                    DayToDisplay = 0
                }
            }
            
            let CalendarCalendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = "dd MM yyyy"
            
            if CalendarCalendar.isDateInToday(formatter.date(from: "30 04 2018")!){
                DayToDisplay = 1
            }
            if CalendarCalendar.isDateInToday(formatter.date(from: "14 05 2018")!){
                DayToDisplay = 4
            }
            
            
            segmentedControl.move(to: DayToDisplay)
            selectedSegment = DayToDisplay
            view.addSubview(segmentedControl)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func decodeUrl() -> String {
        return self.removingPercentEncoding!
    }
    
}

