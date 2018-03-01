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
//var LoggedIn = UserDefaults.standard.string(forKey: "loginID") != "" &&  (UserDefaults.standard.string(forKey: "loginID") != nil || !(UserDefaults.standard.string(forKey: "loginID")?.isEmpty)!)
var LoggedIn = Bool()
var UserInformation = [String]()

var OldClass = ""

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate{
    
    var CurrentTableIndex = 0
    
    /*override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.presentedViewController.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
                
            } else {
                let indexPath = indexPath(item: self.pageControl.currentPage, section : 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
            } { (_) in
 
            }
        })
        
        
        
    }*/ 
    
    
    var eventsArray = [events]()
    var array = EventsArray
    var EventsAreLoaded = false
    
    var destinationFeature = 0
    
    func ParseEvents(){
        if EventsArray.isEmpty{
        //Parse Events
        DispatchQueue.main.async {
            if EventsArray.isEmpty{
        let path = Bundle.main.path(forResource: "2017 - 2018 School Events New", ofType: "csv")!
        let importer = CSVImporter<[String: String]>(path: path)
        
        
        importer.startImportingRecords(structure: { (headerValues) -> Void in
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
    }
}
        
       
        
        
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.array = EventsArray
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
            if circulars == nil || circulars.isEmpty{
            URLSession.shared.dataTask(with: circularsURL!) { (data, response, error) in
                do {
                    if data != nil{
                    circulars = try JSONDecoder().decode([String:[String:String]].self, from: data!)
                    for i in 1...circulars.values.count {
                        if circulars.count > circularTitleArray.count {
                            circularTimeArray += [(circulars["\(i)"]!["time"]!)]
                            circularTitleArray += [(circulars["\(i)"]!["title"]!)]
                        }
                    }
                    }
                } catch {
                    print("ERROR")
                }
                }.resume()
            }
            
            if news == nil || newsTitleArray.isEmpty{
            URLSession.shared.dataTask(with: newsURL!) { (data, response, error) in
                do {
                    if data != nil{
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
                }
                catch {
                    print("ERROR")
                }
                }.resume()
            }
        }
    }
    
    func ParseTimetable (){
        
        if let User = UserDefaults.standard.array(forKey: "profileData"){
            UserInformation = User as! [String]
        }
        
        if LoggedIn && teacherOrStudent() == "s"{
            var CurrentClass = UserInformation[3]
            CurrentClass.removeFirst()
            CurrentClass.removeLast(3)
            
            
            
        if timetable == nil || (timetableChoice != CurrentClass) || OldClass != UserInformation[3]{
        
        timetableChoice = CurrentClass
            
        let input = "\(UserInformation[3])"
        OldClass = UserInformation[3]
        
        var GradeString = "\(input)"
        GradeString.removeLast(4)
        GradeString.removeFirst()
            _ = Int(GradeString)!
        
        var ClassString1 = "\(input)"
        ClassString1.removeLast(3)
<<<<<<< HEAD
        
=======
            
>>>>>>> 14b00ca11805b7477ac0cdda434024b8b076f930
        let jsonURL = "http://cl.dbs.edu.hk/mobile/common/timetable/timetable\(GradeString).json"
        let url = URL(string: jsonURL)
            DispatchQueue.main.async {
                if self.isInternetAvailable(){
                    
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        do {
                            if data != nil {
                                
                                timetable = try JSONDecoder().decode(TimetableJSON.self, from: data!)
                                
                            }
                            
                        } catch {
                            print("ERROR")
                        }
                    }.resume()
                }
                
            }
        }
    }
    }
    
    @objc func GoToTimetable(){
        
        timetableChoice = "\(UserInformation[3])"
        timetableChoice.removeLast(3)
        
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
        
        ViewTimesLoaded += 1
        
        DispatchQueue.main.async {
            self.ParseEvents()
            self.ParseNewsCurriculars()
            if let User = UserDefaults.standard.array(forKey: "profileData"){
                UserInformation = User as! [String]
            }
        }
        
        
        scrollView.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.UISetup()
            var logInNumber = 0
            if !LoggedIn && self.teacherOrStudent() == "s"{
                logInNumber = 1
            }else{
                logInNumber = 0
            }
            
//            for i in (10001 - logInNumber)...(10004 - logInNumber) {
//                let View = self.scrollView.viewWithTag(i)
//                if let TableView = View {
//                    self.registerForPreviewing(with: self, sourceView: TableView as! UITableView)
//                }
//
//            }
            
            
        }
        
        
        
        
    }
    
    func ScrollLeft(){
        if self.scrollView.contentOffset.x >= self.view.frame.width{
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x - self.view.frame.width,y :0), animated: false)
        }
    }
    
    func ScrollRight(){
        if self.scrollView.contentOffset.x < self.scrollView.contentSize.width - self.view.frame.width{
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + self.view.frame.width,y :0), animated: false)
        }
    }
    
    func UISetup(){
        
        LoggedIn = UserDefaults.standard.string(forKey: "loginID") != "" &&  (UserDefaults.standard.string(forKey: "loginID") != nil /*|| (UserDefaults.standard.string(forKey: "loginID")?.isEmpty)!*/)
        if let x = UserDefaults.standard.string(forKey: "loginID") {
            loginID = x
        }
        
        var arrayData = scrollViewLoggedInData
        
        if LoggedIn && teacherOrStudent() == "s"{
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
        scrollView.backgroundColor = UIColor.init(red: 37.0/255.0, green: 44.0/255.0, blue: 110.0/255.0, alpha: 0)
        scrollView.frame.origin.y = self.view.frame.height * 0.4
        scrollView.frame.size.height = self.view.frame.height * 0.6 - (self.tabBarController?.tabBar.frame.size.height)!
        scrollView.frame.size.width = self.view.frame.width
        scrollView.layer.zPosition = 50
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.isPagingEnabled = true
        
        
        
        //Welcome Label
        let WelcomeLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height * 0.125, width: self.view.frame.width*0.9, height: self.view.frame.height * 0.06))
        if !LoggedIn || UserInformation.isEmpty {
            WelcomeLabel.text = "Welcome to DBS!"
        }else if teacherOrStudent() == "s"{
            let Name = String(UserInformation[1].capitalized)!
            var ClassAndNumber = String(UserInformation[3])!
            ClassAndNumber.removeFirst()
            ClassAndNumber = ClassAndNumber.replacingOccurrences(of: "-", with: " ")
            WelcomeLabel.text = " Hi! \(Name) \(ClassAndNumber) "
        }else if teacherOrStudent() == ""{
            let Name = String(UserInformation[1].capitalized)!
            WelcomeLabel.text = " Hi! \(Name) "
        }
        WelcomeLabel.reloadInputViews()
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
        
        
        
        self.view.addSubview(HomeLogoView)
        
        //Band
        let Band = UIImage(named: "Band")
        let BandView = UIImageView(frame: CGRect(x: 0, y: self.scrollView.frame.origin.y, width: self.view.frame.height, height: (Band?.size.height)!))
        BandView.image = Band
        BandView.layer.zPosition = 1
        BandView.tag = 20
        self.view.addSubview(BandView)
        
        
        //Arrows
        //Left Arrow
        let LeftArrrowImage = #imageLiteral(resourceName: "Arrow")
        let LeftArrowImageView = UIImageView()
        LeftArrowImageView.image = LeftArrrowImage
        
        let LeftArrow = UIButton()
        
        LeftArrow.frame.size.height = BandView.frame.height
        LeftArrow.frame.size.width = LeftArrow.frame.height / 2
        LeftArrow.frame.origin.y = BandView.frame.origin.y
        LeftArrow.frame.origin.x = 0
        
        LeftArrow.layer.zPosition = 100000
        LeftArrow.backgroundColor = self.view.backgroundColor
        
        var tintableImage = LeftArrrowImage.withRenderingMode(.alwaysTemplate)
        LeftArrow.setImage(tintableImage, for: .normal)
        LeftArrow.imageView?.tintColor = UIColor.white.withAlphaComponent(0.6)
        LeftArrow.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
        
        LeftArrow.addTarget(self, action: #selector(ScrollLeft), for: .touchUpInside)
        
        LeftArrow.tag = 50000
        
        self.view.addSubview(LeftArrow)
        print(LeftArrow.imageView?.tintColor)
        
        //Right Arrow
        let RightArrowImage = #imageLiteral(resourceName: "Arrow")
        let RightArrowImageView = UIImageView()
        RightArrowImageView.image = RightArrowImage
        
        
        let RightArrow = UIButton()
        
        RightArrow.frame.size.height = BandView.frame.height
        RightArrow.frame.size.width = RightArrow.frame.height / 2
        RightArrow.frame.origin.y = BandView.frame.origin.y
        RightArrow.frame.origin.x = self.view.frame.width - RightArrow.frame.width
        
        RightArrow.layer.zPosition = 100000
        RightArrow.backgroundColor = self.view.backgroundColor
        
        tintableImage = RightArrowImage.withRenderingMode(.alwaysTemplate)
        RightArrow.setImage(tintableImage, for: .normal)
        RightArrow.imageView?.tintColor = UIColor.white.withAlphaComponent(0.6)
        
        RightArrow.tag = 60000
        
        RightArrow.addTarget(self, action: #selector(ScrollRight), for: .touchUpInside)
        
        self.view.addSubview(RightArrow)
        
        var i = 0
        for data in arrayData{
            
            let DistanceBetweenTableViewAndBand = self.view.frame.height * 0.0125
            let a = DistanceBetweenTableViewAndBand
            
            
            let view = HomeCustomView(frame: CGRect(x: self.scrollView.frame.width * (CGFloat(i) + 0.05), y: DistanceBetweenTableViewAndBand + BandView.frame.height, width: self.view.frame.width * 0.9, height: (self.scrollView.frame.height - BandView.frame.height - a * 3)))
            
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
            label.frame.origin.x = self.scrollView.viewWithTag(i + self.viewTagValue)!.frame.origin.x + self.view.frame.width * 0.2
            
            
            
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
            
            
            //Table View
            let IndentValue : CGFloat = 2
            
            let TableView = HomeEventTableView(frame: view.frame, style: .plain)
            TableView.delegate = self
            TableView.dataSource = self
            TableView.Events = EventsArray
            TableView.layer.cornerRadius = view.layer.cornerRadius
            TableView.clipsToBounds = true
            TableView.frame = view.frame
            TableView.frame.origin.y += IndentValue
            TableView.frame.size.height -= IndentValue * 2
            TableView.isScrollEnabled = true
            self.registerForPreviewing(with: self, sourceView: TableView)
            
            TableView.tag = i + 10000
            self.scrollView.addSubview(TableView)
            
            
            let refresher = UIRefreshControl()
            refresher.attributedTitle = NSAttributedString(string: "Pull to Reload")
            refresher.tag = i + 100000 + 50
            refresher.addTarget(self, action: #selector(reloadTableData(_:)), for: UIControlEvents.valueChanged)
            self.scrollView.viewWithTag(i + 10000)!.addSubview(refresher)
            
            
            i += 1
        }
        
        if ViewTimesLoaded == 1{
            scrollViewDidScroll(scrollView)
        }
        if let pageControl = self.view.viewWithTag(200){
            pageControl.removeFromSuperview()
        }
        
        //Page Control
        let PageControl = UIPageControl(frame: CGRect(x: 0, y: self.view.frame.height * 0.5, width: 200, height: 50))
        var numberOfPages = 0
        numberOfPages = arrayData.count
        PageControl.removeFromSuperview()
        PageControl.numberOfPages = numberOfPages
        PageControl.reloadInputViews()
        PageControl.currentPage = 0
        PageControl.pageIndicatorTintColor = UIColor.gray
        PageControl.currentPageIndicatorTintColor = UIColor.white
        
        PageControl.layer.zPosition = 1000
        PageControl.sizeToFit()
        PageControl.frame.origin.x = (self.view.frame.width - PageControl.frame.width) / 2
        PageControl.frame.origin.y = self.scrollView.frame.origin.y + (self.scrollView.viewWithTag(10)!.frame.origin.y + self.scrollView.viewWithTag(10)!.frame.height) - PageControl.frame.height * 0.3
        PageControl.tag = 200
        PageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(PageControl)
        
        
        
        //scrollView.reloadInputViews()
    }
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat((self.view.viewWithTag(200)! as! UIPageControl).currentPage) * self.view.frame.size.width
        CurrentTableIndex = (self.view.viewWithTag(200)! as! UIPageControl).currentPage
        self.scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func reloadTableData(_ refreshControl: UIRefreshControl){
        
        if EventsArray.isEmpty{
            self.ParseEvents()
        }
        
        if newsDateArray.isEmpty||circularTimeArray.isEmpty{
            self.ParseNewsCurriculars()
        }
        
        if timetable == nil{
            self.ParseTimetable()
            
        }
        
        var logInNumber = 0
        if !LoggedIn && teacherOrStudent() == "s"{
            logInNumber = 1
        }else{
            logInNumber = 0
        }
        let tableTag = refreshControl.tag - 50
        if let Table =  self.scrollView.viewWithTag(tableTag - logInNumber){
            let TableToReload = Table as! UITableView
            TableToReload.reloadData()
        }
        
        refreshControl.endRefreshing()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scrollView.isHidden = true
        
        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        (self.view.viewWithTag(20)! as! UIImageView).removeFromSuperview()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if LoggedIn && teacherOrStudent() == "s"{
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
        
        var BigFont : CGFloat = 18
        var SmallFont : CGFloat = 13
        /*
        if UIScreen.main.bounds.width < 700{
            BigFont = 14
            SmallFont = 11
        }else if UIScreen.main.bounds.width <= 750{
            BigFont = 17
            SmallFont = 13
        }
 */
        
        if UIScreen.main.bounds.height < 667 &&  UIScreen.main.bounds.width < 375{
            BigFont = 14
            SmallFont = 11
        }
        
        removeSpinner(view: tableView)
        tableView.separatorStyle = .singleLine
        
        DispatchQueue.main.async {
            self.array = self.eventsArray
        }
        
        var array = EventsFromNow
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        
        var logInNumber = 0
        if !LoggedIn || teacherOrStudent() == ""{
            logInNumber = 1
        }else{
            logInNumber = 0
        }
        
        //Timetable
        if LoggedIn == true && teacherOrStudent() == "s" && tableView.tag == self.scrollView.viewWithTag(10000 - logInNumber)!.tag{
            tableView.separatorStyle = .singleLine
            if isInternetAvailable(){
                
                DispatchQueue.main.async {
                    if timetable == nil{
                        self.ParseTimetable()
                    }
                }
                
              
            //Date
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
                
            if Date() < TimeBoundary!{
                
                DayToDisplay -= 1
                if DayToDisplay == 5 || DayToDisplay == 6 || DayToDisplay == -1{
                    DayToDisplay = 0
                }
            }else{
                
                if DayToDisplay == 5 || DayToDisplay == 6 || DayToDisplay == 7{
                    DayToDisplay = 0
                }
            }
            
            //Class
                var Grade = 8
                var Class = "S"
                
                
                //if UserInformation != nil{
                let input = "\(UserInformation[3])"
                
                var GradeString = "\(input)"
                GradeString.removeLast(4)
                GradeString.removeFirst()
                let GradeInt = Int(GradeString)!
                
                var ClassString1 = "\(input)"
                ClassString1.removeLast(3)
                var ClassString2 = ClassString1.index(before: ClassString1.endIndex)
                
                if GradeInt != nil{
                    Grade = GradeInt
                }
                
                Class = ClassString1
                Class.removeFirst(2)
 
                
                
             //Elective
                var isElective = false
                
                
            
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
                
                cell.textLabel?.font = UIFont(name: "Helvetica", size: BigFont)
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: BigFont)
                cell.textLabel?.textAlignment = .center
                return cell
            }
            
            
                
            //Subject
            var out = ""
                if GradeInt >= 7 && GradeInt <= 9 {
                    formSection = classArrayLow
                } else if GradeInt >= 10 && GradeInt <= 12 {
                    formSection = classArrayHigh
                }
            
               
                
            if timetable != nil {
                
                    
                    for i in (timetable?.timetable.`class`[formSection.index(of: Class)!].day[DayToDisplay].lesson[indexPath.row - 1].name)! {
                        out += "\(i.decodeUrl()) | "
                    }
                    if (timetable?.timetable.`class`[formSection.index(of: Class)!].day[DayToDisplay].lesson[indexPath.row - 1].isActivityPeriod)! == true || ((timetable?.timetable.`class`[formSection.index(of: Class)!].day[DayToDisplay].lesson[indexPath.row - 1].name)![0] == "" && indexPath.row-1 != 5){
                        out = "Activity Period   "
                    }
                    out.removeLast(3)
                    if out.count > 25{
                        isElective = true
                        out = "Elective"
                    }
                let UpperCaseArray = ["FIS", "MACO", "MAM1", "MAM2", "BAFS", "D&T", "I&D", "ICT"]
                
                if !UpperCaseArray.contains(out){
                    out = out.capitalized
                }
                
                cell.textLabel?.text = out
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                
                out = ""
                
                
                    for i in (timetable?.timetable.`class`[formSection.index(of: Class)!].day[DayToDisplay].lesson[indexPath.row - 1].teacher)! {
                        out += "\(i.uppercased()) | "
                    }
                    out.removeLast(3)
                    
                    if isElective{
                        out = ""
                    }
                
                
                
                cell.detailTextLabel?.text = out
                cell.detailTextLabel?.textColor = UIColor.gray
                cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: SmallFont)
                
            }else{
                tableView.separatorStyle = .none
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                tableView.reloadData()
                setupSpinner(view: tableView)
                ParseTimetable()
                tableView.reloadData()
                }
                
            }else{
                
                tableView.separatorStyle = .none
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                tableView.reloadData()
                setupSpinner(view: tableView)
            }
            
        //Upcoming
        }else if tableView.tag == self.scrollView.viewWithTag(10001 - logInNumber)!.tag{
            
            if EventsArray.isEmpty{
            ParseEvents()
            }
            
            array = EventsFromNow
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                
<<<<<<< HEAD
                if indexPath.row < 4 {
                    if tableView.tag == self.scrollView.viewWithTag(10001 - logInNumber)!.tag{
=======
                if indexPath.row < 4 {                    if tableView.tag == 10001 - logInNumber{
>>>>>>> 14b00ca11805b7477ac0cdda434024b8b076f930
                        
                        if !array.isEmpty{
                            self.EventsAreLoaded = true
                            
                            cell.accessoryType = .disclosureIndicator
                            
                            //Title
                            cell.textLabel!.text = array[indexPath.row].Title
                            cell.textLabel!.adjustsFontSizeToFitWidth = true
                            cell.textLabel!.numberOfLines = 2
                            cell.textLabel!.font = UIFont.boldSystemFont(ofSize: BigFont)
                            
                            //Subtitle
                            cell.detailTextLabel!.textColor = UIColor.gray
                            cell.detailTextLabel!.font = UIFont(name: "Helvetica", size: SmallFont)
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
                        tableView.separatorStyle = .none
                        cell.isUserInteractionEnabled = false
                        cell.textLabel?.text = ""
                        cell.detailTextLabel?.text = ""
                        tableView.reloadData()
                        self.setupSpinner(view: tableView)
                        self.ParseTimetable()
                        tableView.reloadData()
                        }
                        }
                    
                }else{
                    
                    cell.textLabel!.text = "    See More..."
                    cell.textLabel!.font = UIFont.boldSystemFont(ofSize: BigFont)
                }
            }
            if indexPath.row == 4{
            scrollViewDidScroll(scrollView)
            }
            
            
        }
        
        //Circular
        else if tableView.tag == self.scrollView.viewWithTag(10002 - logInNumber)!.tag{
            DispatchQueue.main.async{
                if circulars == nil{
                    self.ParseNewsCurriculars()
                }
            }
            
            if isInternetAvailable(){
                removeSpinner(view: tableView)
            if indexPath.row < 4{
                
                if !circularTitleArray.isEmpty && !circularTimeArray.isEmpty{
                    
                    //Title
                    cell.textLabel!.text = circularTitleArray[indexPath.row]
                    cell.textLabel!.font = UIFont.boldSystemFont(ofSize: BigFont)
                    cell.textLabel?.numberOfLines = 2
                    //cell.textLabel!.adjustsFontSizeToFitWidth = true
                    
                    //Subtitle
                    let circularTimes = (circularTimeArray[indexPath.row]).split(separator: " ")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy"
                    if Int(circularTimes[2])! > Int(dateFormatter.string(from: Date()))! {
                        cell.detailTextLabel?.text = ""
                    } else {
                        cell.detailTextLabel?.text = (circularTimeArray[indexPath.row])
                    }
                    cell.detailTextLabel!.textColor = UIColor.gray
                    cell.detailTextLabel!.font = UIFont(name: "Helvetica", size: SmallFont)
                    
                    //Accessory Type
                    cell.accessoryType = .disclosureIndicator
                }else{
                        tableView.separatorStyle = .none
                        cell.isUserInteractionEnabled = false
                        cell.textLabel?.text = ""
                        cell.detailTextLabel?.text = ""
                        tableView.reloadData()
                        setupSpinner(view: tableView)
                        ParseTimetable()
                        tableView.reloadData()
                    }
                
                
            }else{
                cell.textLabel!.text = "    See More..."
                cell.textLabel!.font = UIFont.boldSystemFont(ofSize: BigFont)
            
            }
            }else{
                tableView.separatorStyle = .none
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                //tableView.reloadData()
                setupSpinner(view: tableView)
            }
            
            
        
        //News
        }else if tableView.tag == self.scrollView.viewWithTag(10003 - logInNumber)!.tag{
            DispatchQueue.main.async{
                if news == nil{
                    self.ParseNewsCurriculars()
                }
            }
            if isInternetAvailable(){
                removeSpinner(view: tableView)
                if !newsDateArray.isEmpty && !newsTitleArray.isEmpty{
                if indexPath.row < 4{
                   
                
                //Title
                cell.textLabel!.text = newsTitleArray[indexPath.row]
                cell.textLabel!.font = UIFont.boldSystemFont(ofSize: BigFont)
                //cell.textLabel!.adjustsFontSizeToFitWidth = true
                cell.textLabel?.numberOfLines = 2
                
                //Subtitle
                cell.detailTextLabel!.text = newsDateArray[indexPath.row]
                cell.detailTextLabel!.textColor = UIColor.gray
                cell.detailTextLabel!.font = UIFont(name: "Helvetica", size: SmallFont)
                
                //Accessory Type
                cell.accessoryType = .disclosureIndicator
                }else{
                    cell.textLabel!.text = "    See More..."
                    cell.textLabel!.font = UIFont.boldSystemFont(ofSize: BigFont)
                    
                    }
                }else{
                    tableView.separatorStyle = .none
                    cell.isUserInteractionEnabled = false
                    cell.textLabel?.text = ""
                    cell.detailTextLabel?.text = ""
                    tableView.reloadData()
                    setupSpinner(view: tableView)
                    ParseTimetable()
                    tableView.reloadData()
            }
            
            
        }else{
            
            tableView.separatorStyle = .none
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            cell.isUserInteractionEnabled = false
            //tableView.reloadData()
            setupSpinner(view: tableView)
        }
        }
 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if LoggedIn && teacherOrStudent() == "s" && tableView.tag == 10000{
            if indexPath.row == 0{
                return 30
            }else if indexPath.row == 6{
                return self.scrollView.viewWithTag(10001)!.frame.size.height / 6 - 5
            }else{
                return self.scrollView.viewWithTag(10001)!.frame.size.height / 6 - 5
            }
            
            
        }else{
            if indexPath.row < 4{
                return self.scrollView.viewWithTag(10001)!.frame.size.height / 4 - 6
            }else{
                return 24
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var logInNumber = 0
        if !LoggedIn || teacherOrStudent() == ""{
            logInNumber = 1
        }
        
        if LoggedIn && teacherOrStudent() == "s" && tableView.tag == self.scrollView.viewWithTag(10000 - logInNumber)!.tag{
            self.GoToTimetable()
            
        }else if tableView.tag == self.scrollView.viewWithTag(10001 - logInNumber)!.tag{
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
                
                destinationFeature = 1
                selectedSegment = 1
                tabBarController?.selectedIndex = 1
            }
        }else if tableView.tag == self.scrollView.viewWithTag(10002 - logInNumber)!.tag{
            if indexPath.row < 4{
                if !circularTitleArray.isEmpty{
                    circularViewURL = (circulars["\(indexPath.row+1)"]!["attach_url"]!)
                    performSegue(withIdentifier: "Home to Circular Detailed", sender: self)
                }
            }else{
                selectedSegment = 0
                tabBarController?.selectedIndex = 1
            }
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Home to Timetable"{
        if let dest = segue.destination as? myTimetableViewController{
            
        }
        }
        
    }
    
    func setupSpinner(view: UITableView){
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.tag = view.tag + 30
        view.addSubview(spinner)
        
        
        let label = UILabel(frame: CGRect(x: 0, y: spinner.frame.origin.y + 20, width: view.frame.width, height: 40))
        label.text = "Please check your Internet connectivity"
        label.textColor = spinner.color
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textAlignment = .center
        label.tag = view.tag + 40
        view.addSubview(label)
        
        
        
    }
    
    func removeSpinner(view: UITableView){
        let tableTag = view.tag
        let subViews = view.subviews
        for subview in subViews{
            if subview.tag == tableTag + 30 || subview.tag == tableTag + 40{
                subview.removeFromSuperview()
            }
        }
        
    }
    
    func teacherOrStudent() -> String {
<<<<<<< HEAD
=======
        
>>>>>>> 14b00ca11805b7477ac0cdda434024b8b076f930
        if LoggedIn && loginID != "" {
            if UserInformation.count >= 5 && UserInformation.count % 3 != 0{
                return "s"
            }
            
        }
        return ""
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
<<<<<<< HEAD
=======
        
>>>>>>> 14b00ca11805b7477ac0cdda434024b8b076f930
        LoggedIn = UserDefaults.standard.string(forKey: "loginID") != "" &&  (UserDefaults.standard.string(forKey: "loginID") != nil /*|| (UserDefaults.standard.string(forKey: "loginID")?.isEmpty)!*/)
        if let x = UserDefaults.standard.string(forKey: "loginID") {
            loginID = x
        }
        //let teacherOrStudent() = "\(self.teacherOrStudent())"
        
        
 
//        if shortcutItemIdentifier == "upcoming" {
//            performSegue(withIdentifier: "Home to All Events", sender: self)
//            shortcutItemIdentifier = "false"
//        } else if shortcutItemIdentifier == "timetable" || shortcutItemIdentifier == "schoolrules" {
//            tabBarController?.selectedIndex = 2
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            var logInNumber = 0
            if !LoggedIn || self.teacherOrStudent() == ""{
                logInNumber = 1
            }else{
                logInNumber = 0
            }
            
            if LoggedIn && timetable == nil{
                DispatchQueue.main.async{
                    self.ParseTimetable()
                    if self.scrollView.viewWithTag(10000 - logInNumber) != nil{
                        (self.scrollView.viewWithTag(10000 - logInNumber)! as! UITableView).reloadData()
                    }
                }
            }else if EventsArray.isEmpty{
                DispatchQueue.main.async{
                    self.ParseEvents()
                    (self.scrollView.viewWithTag(10001 - logInNumber)! as! UITableView).reloadData()
                }
            }else if circulars == nil{
                DispatchQueue.main.async{
                    self.ParseNewsCurriculars()
                    (self.scrollView.viewWithTag(10002 - logInNumber)! as! UITableView).reloadData()
                }
            }else if news == nil{
                DispatchQueue.main.async{
                    self.ParseNewsCurriculars()
                    (self.scrollView.viewWithTag(10003 - logInNumber)! as! UITableView).reloadData()
                }
            }
        }
        
    }
    
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        
        CurrentTableIndex = Int(round(self.scrollView.contentOffset.x / self.scrollView.frame.size.width))
        
        var logInNumber = 0
        if !LoggedIn || teacherOrStudent() == "" {
            logInNumber = 1
        }else{
            logInNumber = 0
        }
        var indexPath : IndexPath? = nil
        
        if let x = (self.scrollView.viewWithTag(10000 + CurrentTableIndex)! as! UITableView).indexPathForRow(at: location){
            indexPath = x
        }
            if indexPath != nil{
                
                let RealIndexPath = (indexPath?.row)!
                
                
                if CurrentTableIndex == 0 - logInNumber{
                    
                    if isInternetAvailable() && timetable != nil{
                    timetableChoice = "\(UserInformation[3])"
                    timetableChoice.removeLast(3)
                    let destViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "My Timetable") as! myTimetableViewController
                    return destViewController
                    }else{
                        return nil
                    }
                    
                }else if CurrentTableIndex == 1 - logInNumber{
                    
                    if !EventsArray.isEmpty{
                    if RealIndexPath < 4{
                        let event = EventsFromNow[RealIndexPath]
                        PassingEvent = (event.Title, event.StartDate, event.EndDate, event.EventType)
                        let destViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Detail Event") as! DetailedEventViewController
                        return destViewController
                    }else{
                        return nil
                    }
                    }else{
                        return nil
                    }
                    
                }else if CurrentTableIndex == 2 - logInNumber{
                    
                    if isInternetAvailable() && !circulars.isEmpty{
                    if RealIndexPath < 4{
                        circularViewURL = (circulars["\(RealIndexPath+1)"]!["attach_url"]!)
                        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Circular Web") as! circularsWebViewController
                        return detailViewController
                    }else{
                        return nil
                    }
                }else{
                    return nil
                }
                }else if CurrentTableIndex == 3 - logInNumber{
                    
                    if isInternetAvailable() && !newsTitleArray.isEmpty{
                    if RealIndexPath < 4{
                        newsIndex = RealIndexPath
                        newsTotal = newsTitleArray.count
                        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "News Detail") as! newsDetailViewController
                        return detailViewController
                    }else{
                        return nil
                    }
                    }else{
                        return nil
                    }
                }
                
            }else{
                return nil
            }
        
        return nil
    }
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
    func reloadAllTables(){
        let tablesArray = [UITableView]()
        for i in 10000...10002{
            let table = self.scrollView.viewWithTag(i)! as! UITableView
            
            var logInNumber = 0
            if !LoggedIn || self.teacherOrStudent() == ""{
                logInNumber = 1
            }else{
                logInNumber = 0
            }
            
            (self.scrollView.viewWithTag(i)! as! UITableView).reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.viewDidLoad()
            self.ParseTimetable()
        }
        }
        
        
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageNumber = round(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        CurrentTableIndex = Int(pageNumber)
        (self.view.viewWithTag(200)! as! UIPageControl).currentPage = Int(pageNumber)
        
        if EventsArray.isEmpty || timetable == nil{
            DispatchQueue.main.async {
                self.array = self.eventsArray
                if !self.EventsAreLoaded{
                    DispatchQueue.main.async {
                        for event in EventsArray{
                            if event.EndDate >= Date(){
                                EventsFromNow += [event]
                            }
                        }
                        self.reloadAllTables()
                        //self.viewDidLoad()
                        let TableView = self.scrollView.viewWithTag(10001)! as! UITableView
                        TableView.reloadData()
                    }
                }
            }
        }
        
        
        
        if scrollView.contentOffset.x >= scrollView.contentSize.width - self.view.frame.height{
            (self.view.viewWithTag(60000)! as! UIButton).isEnabled = false
            (self.view.viewWithTag(60000)! as! UIButton).isHidden = true
            for i in self.view.subviews{
                if i.tag == 60000{
                    i.isHidden = true
                }
            }
        }else{
            (self.view.viewWithTag(60000)! as! UIButton).isEnabled = true
            (self.view.viewWithTag(60000)! as! UIButton).isHidden = false
            (self.view.viewWithTag(60000)! as! UIButton).imageView?.tintColor.withAlphaComponent(0.6)
        }
        
        if scrollView.contentOffset.x <= self.view.frame.width{
            (self.view.viewWithTag(50000)! as! UIButton).isEnabled = false
            (self.view.viewWithTag(50000)! as! UIButton).isHidden = true
            for i in self.view.subviews{
                if i.tag == 50000{
                    i.isHidden = true
                }
            }
        }else{
            (self.view.viewWithTag(50000)! as! UIButton).isEnabled = true
            (self.view.viewWithTag(50000)! as! UIButton).isHidden = false
            (self.view.viewWithTag(50000)! as! UIButton).imageView?.tintColor.withAlphaComponent(0.6)
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        CurrentTableIndex = Int(pageNumber)
        (self.view.viewWithTag(200)! as! UIPageControl).currentPage = Int(pageNumber)
        
        
       
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


