//
//  ViewController.swift
//  DBS
//
//  Created by SDG on 20/9/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import CSVImporter
import TwicketSegmentedControl
import SystemConfiguration

struct ScrollViewDataStruct {
    let title : String?
}
var EventsFromNow = [events]()
var LoggedIn = false
var UserInformation = [String]()

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
//Comment
  
    
    var eventsArray = [events]()
    var array = EventsArray
    var EventsAreLoaded = false
    
    var destinationFeature = 0
    
    func ParseEvents(){
        //Parse Events
        DispatchQueue.main.async {
            if EventsArray.isEmpty{
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
    }
}
        array = EventsArray
        DispatchQueue.main.async {
            for i in EventsArray{
                if i.EndDate > Date(){
                    EventsFromNow += [i]
                }
            }
        }
        
}
    
    func ParseNewsCurriculars(){
        let circularsJSONURL = "http://www.dbs.edu.hk/circulars/json.php"
        let circularsURL = URL(string: circularsJSONURL)
        let newsJSONURL  = "http://www.dbs.edu.hk/newsapp.php"
        let newsURL = URL(string: newsJSONURL)
        
        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if isInternetAvailable(){
        
            URLSession.shared.dataTask(with: circularsURL!) { (data, response, error) in
                do {
                    circulars = try JSONDecoder().decode([String:[String:String]].self, from: data!)
                    for i in 1...circulars.values.count {
                        if circulars.count > circularTitleArray.count {
                            circularTimeArray += [(circulars["\(i)"]!["time"]!)]
                            circularTitleArray += [(circulars["\(i)"]!["title"]!)]
                        }
                    }
                } catch {
                    print("ERROR")
                }
                }.resume()
            URLSession.shared.dataTask(with: newsURL!) { (data, response, error) in
                do {
                    news = try JSONDecoder().decode(newsData.self, from: data!)
                    for i in (news?.title)! {
                        if (news?.title)!.count > newsTitleArray.count {
                            newsTitleArray += [i]
                        }
                    }
                    for i in (news?.date)! {
                        var newsDate = String(describing: Date(timeIntervalSince1970: Double(i)!))
                        newsDate.removeLast(15)
                        let dateArr = newsDate.split(separator: "-")
                        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                        newsDateArray += ["\(months[Int(dateArr[1])!-1]) \(Int(dateArr[2])!), \(dateArr[0])"]
                    }
                }
                catch {
                    print("ERROR")
                }
                }.resume()
        }
    }
    
    func ParseTimetable (){
        
        let jsonURL = "http://cl.dbs.edu.hk/mobile/common/timetable/timetable\(8).json"
        let url = URL(string: jsonURL)
        
        if isInternetAvailable(){
        
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                do {
                    timetable = try JSONDecoder().decode(TimetableJSON.self, from: data!)
                } catch {
                    print("ERROR")
                }
                }.resume()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0.15), execute: {
            if timetable?.timetable.`class`.count == 0 {
                //self.present(networkAlert, animated: true)
            }
            //self.timetableTable.reloadData()
            //self.title? += " (\((self.timetable?.timetable.`class`[self.formSection.index(of: self.group)!].teacher)!))"
        })
        }
    }
    
    @objc func GoToTimetable(){
        timetableChoice = "G8S"
        
        performSegue(withIdentifier: "Home to My Timetable", sender: self)
        
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

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollViewLoggedInData = [ScrollViewDataStruct.init(title: "Timetable"),
                          ScrollViewDataStruct.init(title: "Upcoming"),
                          ScrollViewDataStruct.init(title: "Circular"),
                          ScrollViewDataStruct.init(title: "News")]
    
    var scrollViewData = [ScrollViewDataStruct.init(title: "Upcoming"),
                          ScrollViewDataStruct.init(title: "Circular"),
                          ScrollViewDataStruct.init(title: "News")]
    
    var viewTagValue = 10
    var LabelTagValue = 100
    var LabelBackgroundTagValue = 1000
    
    
    var ViewTimesLoaded = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let x = UserDefaults.standard.string(forKey: "loginID") {
            LoggedIn = x != ""
        }
        if let User = UserDefaults.standard.array(forKey: "profileData"){
            UserInformation = User as! [String]
        }
        
        
        
        ViewTimesLoaded += 1
        
        DispatchQueue.main.async {
            self.ParseEvents()
            self.ParseNewsCurriculars()
            self.ParseTimetable()
        }
        
        
        scrollView.delegate = self
        
        var arrayData = scrollViewLoggedInData
        
        //LoggedIn = false
        
        //May need to change after KL finishes his log in thingy
        if LoggedIn{
            arrayData = scrollViewLoggedInData
        }else{
            arrayData = scrollViewData
        }
        
        
        //Scroll View
        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        scrollView.isHidden = false
        scrollView.reloadInputViews()
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(arrayData.count)
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.backgroundColor = UIColor.init(red: 37.0/255.0, green: 44.0/255.0, blue: 110.0/255.0, alpha: 0)
        scrollView.frame.origin.y = self.view.frame.height * 0.4
        scrollView.frame.size.height = self.view.frame.height * 0.6 - (self.tabBarController?.tabBar.frame.size.height)!
        scrollView.layer.zPosition = 50
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        
        
        
        //Welcome Label
        let WelcomeLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height * 0.125, width: self.view.frame.width*0.9, height: self.view.frame.height * 0.06))
        if UserInformation.isEmpty{
            WelcomeLabel.text = " Welcome to DBS! "
        }else{
            let Name = String(UserInformation[1].capitalized)!
            var ClassAndNumber = String(UserInformation[3])!
            ClassAndNumber.removeFirst()
            var Out = ""
            for char in ClassAndNumber{
                if char == "-"{
                    Out += " "
                }else{
                    Out += "\(char)"
                }
            }
            swap(&ClassAndNumber, &Out)
            
            WelcomeLabel.text = " Hi! \(Name) \(ClassAndNumber) "
        }
        WelcomeLabel.textColor = UIColor.white
        WelcomeLabel.font = UIFont(name: "Helvetica", size: 24)
        WelcomeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        WelcomeLabel.textAlignment = .center
        WelcomeLabel.adjustsFontSizeToFitWidth = true
        WelcomeLabel.center.x = view.center.x
        WelcomeLabel.backgroundColor = UIColor.init(red: 69.0/255.0, green: 73.0/255.0, blue: 127.0/255.0, alpha: 1)
        WelcomeLabel.layer.cornerRadius = WelcomeLabel.frame.height * 0.4
        WelcomeLabel.clipsToBounds = true
        self.view.addSubview(WelcomeLabel)
        
        
        //Home Logo
        let HomeLogo = UIImage(named: "Home Logo")
        let HomeLogoView = UIImageView(frame: CGRect(x: 8, y: WelcomeLabel.frame.origin.y + WelcomeLabel.frame.size.height + self.view.frame.height * 0.02, width: self.view.frame.width - 16, height: (HomeLogo?.size.height)!))
        HomeLogoView.image = HomeLogo
        HomeLogoView.contentMode = .scaleAspectFit
        
        
        //HomeLogo?.size
        //let HomeLogoY = NSLayoutConstraint(item: HomeLogoView, attribute:.topMargin, relatedBy: .equal, toItem: WelcomeLabel, attribute: .bottomMargin, multiplier: 1.0, constant: self.view.frame.height * 0.03)
        //NSLayoutConstraint.activate([HomeLogoY])
        
        self.view.addSubview(HomeLogoView)
        
        //Band
        let Band = UIImage(named: "Band")
        let BandView = UIImageView(frame: CGRect(x: 0, y: self.scrollView.frame.origin.y, width: self.view.frame.height, height: (Band?.size.height)!))
        BandView.image = Band
        BandView.layer.zPosition = 1
        self.view.addSubview(BandView)
        
            


        //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0.2), execute: {
        
            var i = 0
            for data in arrayData{
                
                let DistanceBetweenTableViewAndBand = self.view.frame.height * 0.0125
                let a = DistanceBetweenTableViewAndBand
                
                //if !LoggedIn
                let view = HomeCustomView(frame: CGRect(x: self.scrollView.frame.width * (CGFloat(i) + 0.05), y: DistanceBetweenTableViewAndBand + BandView.frame.height, width: self.view.frame.width * 0.9, height: (self.scrollView.frame.height - BandView.frame.height - a * 2)))
                //let view = HomeCustomView(frame: CGRect(x: self.scrollView.frame.width * (CGFloat(i) + 0.05), y: BandView.frame.height, width: self.view.frame.width * 0.9, height: self.scrollView.frame.height - BandView.frame.height ))
                view.backgroundColor = UIColor.red
                view.layer.cornerRadius = view.frame.width * 0.1
                view.clipsToBounds = true
                
                view.tag = i + self.viewTagValue
                self.scrollView.addSubview(view)
                
                
                
                
                //Label
                let label = UILabel(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 150, height: 100)))
                label.text = data.title
                label.font = UIFont.boldSystemFont(ofSize: 32)
                label.font = UIFont(name: "Helvetica", size: 32)
                label.textAlignment = .center
                label.textColor = UIColor.white
                label.backgroundColor = self.view.backgroundColor
                label.sizeToFit()
                label.layer.zPosition = 100
                //label.frame.origin.x = view.frame.size.width * 0.2
                label.frame.origin.x = self.scrollView.viewWithTag(i + self.viewTagValue)!.frame.origin.x + self.view.frame.width * 0.15
                
                /*
                if i == 0{
                    label.frame.origin.x = view.frame.width * 0.2
                }else{
                    //label.frame.origin.x = view.frame.width * CGFloat(Double(i) + 0.2)
                    label.frame.origin.x = view.frame.width * (CGFloat(i) + 0.1 * CGFloat(i) + 0.2)
                    //label.frame.origin.x = view.frame.width * 0.1
                }
 */
 
                
                label.tag = i + self.LabelTagValue
                
                
                let LabelBackgroundView = UIView(frame: CGRect(x: label.frame.origin.x - 10 , y: 0, width: label.frame.width + 20, height: BandView.frame.height))
                LabelBackgroundView.tag = i + self.LabelBackgroundTagValue
                LabelBackgroundView.backgroundColor = self.view.backgroundColor
                
                label.frame.origin.y = (BandView.frame.height - label.frame.height) / 2
                
                self.scrollView.addSubview(LabelBackgroundView)
                self.scrollView.addSubview(label)
                self.scrollView.bringSubview(toFront: label)
                if i == 0{
                    
                }

                
                /*
                 let ViewUnderLabel = UIView(frame: label.frame)
                 ViewUnderLabel.backgroundColor = UIColor.white
                 self.scrollView.addSubview(ViewUnderLabel)
                 */
                
                
                
                //Table View
                let TableView = HomeEventTableView(frame: view.frame, style: .plain)
                TableView.delegate = self
                TableView.dataSource = self
                TableView.Events = EventsArray
                TableView.layer.cornerRadius = view.layer.cornerRadius
                TableView.clipsToBounds = true
                TableView.frame = view.frame
                TableView.isScrollEnabled = true
                
                TableView.tag = i + 10000
                self.scrollView.addSubview(TableView)
                
                //Button on top of Table View
                if i == 0 && LoggedIn{
                    let TableButton = UIButton(frame: self.scrollView.viewWithTag(i + 10000)!.frame)
                    TableButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                    //TableButton.target(forAction: #selector(GoToTimetable), withSender: self)
                    TableButton.addTarget(self, action: #selector(self.GoToTimetable),  for: .touchUpInside)
                    self.scrollView.addSubview(TableButton)
                    
                }
                
                
                
                var refresher = UIRefreshControl()
                refresher.attributedTitle = NSAttributedString(string: "Pull to Reload")
                refresher.tag = i + 100000 + 50
                refresher.addTarget(self, action: #selector(reloadTableData(_:)), for: UIControlEvents.valueChanged)
                self.scrollView.viewWithTag(i + 10000)!.addSubview(refresher)
                
                
                
                
                //Stays at bottom
                i += 1
            }
    
        if ViewTimesLoaded == 1{
            //viewDidLoad()
            scrollViewDidScroll(scrollView)
        }
        
        
        
        //usleep(20000)
        scrollView.reloadInputViews()
        
        
    }
    
    func reloadTableData(_ refreshControl: UIRefreshControl){
        
        if EventsArray.isEmpty{
            self.ParseEvents()
        }
        
        self.ParseTimetable()
        
        if newsDateArray.isEmpty||circularTimeArray.isEmpty{
            self.ParseNewsCurriculars()
        }
        
        let tableTag = refreshControl.tag - 50
        //let TableToReload = self.scrollView.viewWithTag(tableTag)! as! UITableView
        //TableToReload.reloadData()
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scrollView.isHidden = true
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if LoggedIn{
            if tableView.tag == 10000{
                return 7
            }else{
                return 5
            }
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        DispatchQueue.main.async {
            self.array = self.eventsArray
        }
        
        
        
            
        
        var array = EventsFromNow
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        
        var logInNumber = 0
        if !LoggedIn{
            logInNumber = 1
        }else{
            logInNumber = 0
        }
        
        //Timetable
        if LoggedIn == true && tableView.tag == self.scrollView.viewWithTag(10000 - logInNumber)!.tag{
            if isInternetAvailable(){
            //Date
            var DayToDisplay = 0
            var calendar = Calendar(identifier: .gregorian)
            calendar.firstWeekday = -1
            
            var CurrentDay = calendar.component(.weekday, from: Date()) - 1
            var CurrentTime = calendar.component(.hour, from: Date())
            
            DayToDisplay = CurrentDay
            if DayToDisplay == 5 || DayToDisplay == -1 {
                DayToDisplay = 0
            }
            
            //Class
                var Grade = 8
                var Class = "S"
                var GradeString = UserInformation[3]
                
                //if let grade = UserDefaults
            
            if indexPath.row == 0{
                switch DayToDisplay{
                    case 0: cell.textLabel?.text = "Monday's Timetable"
                    case 1: cell.textLabel?.text = "Tuesday's Timetable"
                    case 2: cell.textLabel?.text = "Wednesday's Timetable"
                    case 3: cell.textLabel?.text = "Thursday's Timetable"
                    case 4: cell.textLabel?.text = "Friday's Timetable"
                    
                default:
                    cell.textLabel?.text = "Monday's Timetable"
                }
                
                cell.textLabel?.font = UIFont(name: "Helvetica", size: 18)
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                cell.textLabel?.textAlignment = .center
                return cell
            }
            
            
            //Subject
            var out = ""
            formSection = classArrayLow
            
            if timetable != nil {
                
                for i in (timetable?.timetable.`class`[formSection.index(of: "S")!].day[DayToDisplay].lesson[indexPath.row - 1].name)! {
                    out += "\(i.decodeUrl()) | "
                }
                if (timetable?.timetable.`class`[formSection.index(of: "S")!].day[DayToDisplay].lesson[indexPath.row - 1].isActivityPeriod)! == true || (timetable?.timetable.`class`[formSection.index(of: "S")!].day[DayToDisplay].lesson[indexPath.row - 1].name)![0] == "" {
                    out = "Activity Period   "
                }
                out.removeLast(3)
                cell.textLabel?.text = out
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                
                out = ""
                for i in (timetable?.timetable.`class`[formSection.index(of: "S")!].day[DayToDisplay].lesson[indexPath.row - 1].teacher)! {
                    out += "\(i.uppercased()) | "
                }
                out.removeLast(3)
                
                /*
                if out != "D%T"{
                    out = out.lowercased()
                    //out = out.first
                }
 */
                
                
                
                cell.detailTextLabel?.text = out
                cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 12)
                
                cell.isUserInteractionEnabled = false
            }
            }else{
                tableView.separatorStyle = .none
                cell.isUserInteractionEnabled = false
                setupSpinner(view: tableView)
            }
            
        //Upcoming
        }else if tableView.tag == self.scrollView.viewWithTag(10001 - logInNumber)!.tag{
            
            
            
            array = EventsFromNow
            DispatchQueue.main.async {
                
                usleep(12000)
                if indexPath.row < 4{
                    if tableView.tag == self.scrollView.viewWithTag(10001 - logInNumber)!.tag{
                        
                        if !array.isEmpty{
                            self.EventsAreLoaded = true
                            
                            cell.accessoryType = .disclosureIndicator
                            
                            //Title
                            cell.textLabel!.text = array[indexPath.row].Title
                            cell.textLabel!.adjustsFontSizeToFitWidth = true
                            cell.textLabel!.numberOfLines = 2
                            cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 17)
                            
                            //Subtitle
                            cell.detailTextLabel!.textColor = UIColor.gray
                            cell.detailTextLabel!.font = UIFont(name: "Helvetica", size: 13)
                            cell.detailTextLabel!.numberOfLines = 0
                            let formatter = DateFormatter()
                            formatter.dateFormat = "d/M/yy"
                            if array[indexPath.row].StartDate == array[indexPath.row].EndDate{
                                cell.detailTextLabel!.text = formatter.string(from: array[indexPath.row].StartDate)
                            }else{
                                cell.detailTextLabel!.text = "\(formatter.string(from: array[indexPath.row].StartDate)) - \(formatter.string(from: array[indexPath.row].EndDate))"
                            }
                            
                            //Event Type Bar
                            if let image = UIImage(named: "dot"){
                                let tintableImage = image.withRenderingMode(.alwaysTemplate)
                                cell.imageView?.image = tintableImage
                            }
                            
                            
                            switch array[indexPath.row].EventType {
                            case .PH:
                                cell.imageView?.tintColor = UIColor.red
                            case .SE:
                                cell.imageView?.tintColor = UIColor(red: 97.0/255.0, green: 142.0/255.0, blue: 249.0/255.0, alpha: 1)
                            case .SH:
                                cell.imageView?.tintColor = UIColor(red: 1, green: 142.0/255.0, blue: 80.0/255.0, alpha: 1)
                            }
                            
                        }else{
                            cell.textLabel!.text = "empty event array"
                            
                        }
                    }
                }else{
                    
                    cell.textLabel!.text = "    See More..."
                    cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 20)
                }
            }
            
            
        }
        
        //Circular
        else if tableView.tag == self.scrollView.viewWithTag(10002 - logInNumber)!.tag{
            if isInternetAvailable(){
            if indexPath.row < 4{
                
                if !circularTitleArray.isEmpty && !circularTimeArray.isEmpty{
                    
                    //Title
                    cell.textLabel!.text = circularTitleArray[indexPath.row]
                    cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 17)
                    cell.textLabel?.numberOfLines = 2
                    cell.textLabel!.adjustsFontSizeToFitWidth = true
                    
                    //Subtitle
                    cell.detailTextLabel!.text = circularTimeArray[indexPath.row]
                    cell.detailTextLabel!.textColor = UIColor.gray
                    cell.detailTextLabel!.font = UIFont(name: "Helvetica", size: 13)
                    
                    //Accessory Type
                    cell.accessoryType = .disclosureIndicator
                }else{
                    cell.textLabel!.text = "Error loading"
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }else{
                cell.textLabel!.text = "    See More..."
                cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 20)
            }
            }else{
                tableView.separatorStyle = .none
                cell.isUserInteractionEnabled = false
                setupSpinner(view: tableView)
            }
            
            
        
        //News
        }else if tableView.tag == self.scrollView.viewWithTag(10003 - logInNumber)!.tag{
            if isInternetAvailable(){
            if indexPath.row < 4{
                
                if !newsDateArray.isEmpty && !newsTitleArray.isEmpty{
                //Title
                cell.textLabel!.text = newsTitleArray[indexPath.row]
                cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 17)
                cell.textLabel!.adjustsFontSizeToFitWidth = true
                cell.textLabel?.numberOfLines = 2
                
                //Subtitle
                cell.detailTextLabel!.text = newsDateArray[indexPath.row]
                cell.detailTextLabel!.textColor = UIColor.gray
                cell.detailTextLabel!.font = UIFont(name: "Helvetica", size: 13)
                
                //Accessory Type
                cell.accessoryType = .disclosureIndicator
                }else{
                    cell.textLabel!.text = "Error loading"
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }else{
                cell.textLabel!.text = "    See More..."
                cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 16)
            }
            
        }else{
            
            setupSpinner(view: tableView)
            tableView.separatorStyle = .none
            cell.isUserInteractionEnabled = false
        }
        }
 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if LoggedIn && tableView.tag == 10000{
            if indexPath.row == 0{
                return 35
            }else{
                return self.scrollView.viewWithTag(11)!.frame.size.height / 6 - 5
            }
            
            
        }else{
            if indexPath.row < 4{
                return self.scrollView.viewWithTag(11)!.frame.size.height / 4 - 6
            }else{
                return 24
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var logInNumber = 0
        if !LoggedIn{
            logInNumber = 1
        }
        
        if tableView.tag == self.scrollView.viewWithTag(10001 - logInNumber)!.tag{
            if indexPath.row < 4 {
                let event = EventsFromNow[indexPath.row]
                PassingEvent = (event.Title, event.StartDate, event.EndDate, event.EventType)
                performSegue(withIdentifier: "Home to Detail Event", sender: self)
            }else{
                DispatchQueue.main.async {
                    for event in EventsArray{
                        if event.EndDate >= Date(){
                            EventsFromNow += [event]
                        }
                    }
                }
                performSegue(withIdentifier: "Home to All Events", sender: self)
            }
        } else if tableView.tag == self.scrollView.viewWithTag(10003 - logInNumber)!.tag{
            if indexPath.row < 4{
                if !newsTitleArray.isEmpty{
                    newsIndex = indexPath.row
                    newsTotal = newsTitleArray.count
                    performSegue(withIdentifier: "Home to News Detailed", sender: self)
                }
            }else{
                //prepare(for: UIStoryboardSegue.init(identifier: "Home to Featured", source: ViewController, destination: FeaturedPageViewController), sender: self)
                destinationFeature = 1
                //performSegue(withIdentifier: "Home to Featured", sender: nil)
                tabBarController?.selectedIndex = 1
                //performSegue(withIdentifier: "Home to Featured", sender: self)
            }
        }else if tableView.tag == self.scrollView.viewWithTag(10002 - logInNumber)!.tag{
            if indexPath.row < 4{
                if !circularTitleArray.isEmpty{
                    circularViewURL = (circulars["\(indexPath.row+1)"]!["attach_url"]!)
                    performSegue(withIdentifier: "Home to Circular Detailed", sender: self)
                }
            }else{
                //prepare(for: UIStoryboardSegue.init(identifier: "Home to Featured", source: ViewController, destination: FeaturedPageViewController), sender: self)
                
                //performSegue(withIdentifier: "Home to Featured", sender: nil)
                tabBarController?.selectedIndex = 1
                //performSegue(withIdentifier: "Home to Featured", sender: self)
            }
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Home to Timetable"{
        if let dest = segue.destination as? myTimetableViewController{
            //dest.selectedSegment = 
        }
        }
        
    }
    
    func setupSpinner(view: UITableView){
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.hidesWhenStopped = true
        
        let label = UILabel(frame: CGRect(x: 0, y: spinner.frame.origin.y + 20, width: view.frame.width, height: 40))
        label.text = "Please check your Internet connectivity"
        label.textColor = spinner.color
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textAlignment = .center
        //spinner.frame.origin.y = spinner.frame.origin.y + 40
        //label.sizeToFit()
        view.addSubview(label)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        
        DispatchQueue.main.async {
            self.viewDidLoad()
            self.scrollView.viewWithTag(10000)!.reloadInputViews()
        }
        
        /*
        DispatchQueue.main.async {
            if !self.EventsAreLoaded{
                DispatchQueue.main.async {
                    for event in EventsArray{
                        if event.EndDate >= Date(){
                            
                            EventsFromNow += [event]
                            
                        }
                        
                    }
                    self.viewDidLoad()
                }
            }
        }
       */
 
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var apple = 0
        if scrollView == scrollView{
            for i in 0..<scrollViewLoggedInData.count{
                /*
                let label = scrollView.viewWithTag(i + LabelTagValue) as! UILabel
                let view = scrollView.viewWithTag(i + viewTagValue) as! HomeCustomView
                let labelBackground = scrollView.viewWithTag(i + LabelBackgroundTagValue) as! UIView
                
                var scrollContentOffset = scrollView.contentOffset.x + self.scrollView.frame.width
                var viewOffset = view.center.x - scrollView.bounds.width / 4 - scrollContentOffset
                
                //label.center.x =  scrollContentOffset - ((scrollView.bounds.width / 4 - viewOffset) / 2 )
               // labelBackground.center.x =  scrollContentOffset - ((scrollView.bounds.width / 4 - viewOffset) / 2 )
                */
                
                
                DispatchQueue.main.async {
                    self.array = self.eventsArray
                    
                    if !self.EventsAreLoaded && i < 10{
                        DispatchQueue.main.async {
                            apple += 1
                            for event in EventsArray{
                                if event.EndDate >= Date(){
                                    
                                    EventsFromNow += [event]
                                    
                                }
                            }
                            self.viewDidLoad()
                            let TableView = self.scrollView.viewWithTag(10001)! as! UITableView
                            TableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}


class HomeCustomView: UIView {
    
    let WhiteView : UIView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = imageView.frame.width * 0.1
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(WhiteView)
        WhiteView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        WhiteView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        WhiteView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        WhiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


