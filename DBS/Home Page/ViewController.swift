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
var LoggedIn = Bool()
var UserInformation = [String]()

var OldClass = ""

var OldUser = [String]()

var EventsFromNow = [events]()

var segmentChanged = false

var tabBarPage = 0


let CurrenttableIndexKey = "CurrenttableIndexKey"

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate{
    
    
    
    var CurrentTableIndex = 0 // Detect Current Table
    
    var eventsArray = [events]()
    var array = EventsArray
    var EventsAreLoaded = false
    
    var destinationFeature = 0
    
    var lessonArray = [[String]]()
    
    func ParseEvents(){
        if EventsArray.isEmpty{
            //Parse Events
            DispatchQueue.main.async {
                if EventsArray.isEmpty{
                    let path = Bundle.main.path(forResource: "importCalendar", ofType: "csv")!
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
        //Events From Now
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
            if circulars.isEmpty{
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
        
        /*
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
                
                var ClassString1 = "\(input)"
                ClassString1.removeLast(3)
                
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
        */
        //if Int("\(timetableChoice[timetableChoice.index(timetableChoice.startIndex, offsetBy: 1)])") == nil {
        /*if teacherOrStudent() == "t" {
            
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: "import_lesson", ofType: "csv")!)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let rows = (String(data: data!, encoding: .utf8)?.split(separator: "\r\n"))!
                for row in rows {
                    let rowInfos = "\(row)".split(separator: ",")
                    var rowInfosInString = [String]()
                    for cell in rowInfos {
                        rowInfosInString += ["\(cell)"]
                    }
                    self.lessonArray += [rowInfosInString]
                }
                }.resume()
            
        } else {
            
            URLSession.shared.dataTask(with: timetableLink(ofClass: "G9D")) { (data, response, error) in
                if let data = data {
                    let rows = (String(data: data, encoding: .utf8)?.components(separatedBy: "<br />"))!
                    for row in rows {
                        let rowInfos = "\(row)".split(separator: "|")
                        var rowInfosInString = [String]()
                        for cell in rowInfos {
                            rowInfosInString += ["\(cell)"]
                        }
                        self.lessonArray += [rowInfosInString]
                    }
                    self.lessonArray.removeLast()
                    
                }
                
                
                
                }.resume()
            
        }
 */
    }
    
    func timetableLink(ofClass: String) -> URL {
        var output = ""
        switch ofClass {
        case "G10D": output = "f6e8f9da8ce06b07123eb2e992f2f132"
        case "G10J": output = "3ef0b2151af2f3f20c4ca10026c5a58a"
        case "G10M": output = "f2b06e8acfeb0dab3b6e2c77126a4f99"
        case "G10P": output = "ce50124d1dc77859c90777d285a005b9"
        case "G10S": output = "9af49fee2a011f2b3758d38c34ae4126"
        case "G10T": output = "20e7d864ee295dc24f37223e031d7590"
        case "G11D": output = "e2a701071a2a112a9ce83df4f4258b95"
        case "G11J": output = "fefd62e1ba2278143eee5736c0521069"
        case "G11M": output = "1dd97788b25fb81c568021aeeaa3eb53"
        case "G11P": output = "13fc99faae6c2aa00ac888b9ca4fc911"
        case "G11S": output = "89447e3306a9aacf062611202a271b00"
        case "G11T": output = "3d6821c9bfb98a1a462bc73f75103db6"
        case "G12D": output = "b219d793c23d2bba1e23b948e16740b5"
        case "G12J": output = "f020a06dd1d71ef2fac145c794c471f1"
        case "G12M": output = "114dbf938efa92e755b22fb8956111c1"
        case "G12P": output = "8285a77458485836df931b9e09fad634"
        case "G12S": output = "66145fabc8d52f3064e1dad1b8a6e032"
        case "G12T": output = "dbc506ccac8c1552c53db355fb4c2345"
        case "G7A": output = "b7a93faffaa9228efb616c2dbd88d585"
        case "G7D": output = "5fa130c52cf6678083076eabc1e6e47f"
        case "G7G": output = "c7f080642ede93bcad1ca7ecb29330fa"
        case "G7J": output = "24b534a35357001b881ffb81a743dafe"
        case "G7L": output = "b9cf53f1775212c6ab6ef63cc37e577e"
        case "G7M": output = "4fe929e27c0065ee6aff6bac5043a470"
        case "G7P": output = "2e83f4d6a5d6e3df9714e52c6d5bc8e0"
        case "G7S": output = "b8aaee5992b87b575531563f95e7da92"
        case "G7T": output = "e4c1504c7e6db84046098d6940f266ae"
        case "G8A": output = "1bf7e4275fbf0694f0006bdab8ab2419"
        case "G8D": output = "6a1665c6fe61879987c84e460d7a446a"
        case "G8G": output = "00893cc50ee8476e84a06f739fb3970d"
        case "G8J": output = "10500da46f17bd0f61df9718b5cc2a34"
        case "G8L": output = "596946193bb59613edd1ce5780bdc191"
        case "G8M": output = "686008acb25746092efe95b4520acc13"
        case "G8P": output = "0e8b93625e03aa32b8cf813ba82fcf60"
        case "G8S": output = "9f6115aa11e4aa5a27ff3e4798fa0c84"
        case "G8T": output = "43ddd220b50b432cc72cc2270d287ff5"
        case "G9A": output = "85efb619d4a0adc7c93b78bf42204180"
        case "G9D": output = "2a96b80065e82df8eb58f405ebdd7c51"
        case "G9G": output = "adde4c4a385ab7243e91449b17b873d5"
        case "G9J": output = "5330aa5f279e6a0327e51780e811b9b3"
        case "G9L": output = "cda67da0decb1b97a85d59b2d8d961de"
        case "G9M": output = "98fdb30587831c7dd52273f030d25161"
        case "G9P": output = "77ea4abb97e698218923971584367bd6"
        case "G9S": output = "562e7f70bd1620e1dff902a3d6c24bfa"
        case "G9T": output = "e49ca78131abb8cfe0822f354d6731ba"
        default: break
        }
        
        return URL(string: "http://www2.dbs.edu.hk/qschedule/qqexport.php?type=c&id=\(ofClass)&md5=\(ofClass)&md5=\(output)")!
    }
    
    @objc func GoToTimetable(){
        
        timetableChoice = "\(UserInformation[3])"
        timetableChoice.removeLast(3)
        
        performSegue(withIdentifier: "Home to My Timetable", sender: self)
        
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
        
        if let x = UserDefaults.standard.array(forKey: "profileData") as? [String]{
            OldUser = x
        }
        
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
        
        
        if let x = UserDefaults.standard.string(forKey: "loginID") {
            loginID = x
            LoggedIn = x != "" &&  x != nil /*|| (UserDefaults.standard.string(forKey: "loginID")?.isEmpty)!*/
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
            WelcomeLabel.text = " Welcome! \(Name) "
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
        let LeftArrowImage = #imageLiteral(resourceName: "Arrow")
        let LeftArrowImageView = UIImageView()
        LeftArrowImageView.image = LeftArrowImage
        
        let LeftArrow = UIButton()
        
        LeftArrow.frame.size.height = BandView.frame.height
        LeftArrow.frame.size.width = LeftArrow.frame.height / 2
        LeftArrow.frame.origin.y = BandView.frame.origin.y
        LeftArrow.frame.origin.x = 0
        
        LeftArrow.layer.zPosition = 100000
        LeftArrow.backgroundColor = self.view.backgroundColor
        
        var tintableImage = LeftArrowImage.withRenderingMode(.alwaysTemplate)
        LeftArrow.setImage(tintableImage, for: .normal)
        LeftArrow.imageView?.tintColor = UIColor.white.withAlphaComponent(0.6)
        LeftArrow.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
        
        LeftArrow.addTarget(self, action: #selector(ScrollLeft), for: .touchUpInside)
        
        LeftArrow.tag = 50000
        
        self.view.addSubview(LeftArrow)
        
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
        
        if lessonArray == nil{
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
            
            ParseTimetable()
            
            
            
            tableView.separatorStyle = .singleLine
            
            let IBClass = ["G10G", "G10L", "G11G", "G11L", "G12G", "G12L"]
            
            if /*isInternetAvailable()*/ true{
                
              
                
                //Date
                var DayToDisplay = 0
                var calendar = Calendar(identifier: .gregorian)
                calendar.firstWeekday = -1
                
                let CurrentDay = calendar.component(.weekday, from: Date()) - 1
                let _ : DateFormatter = {
                    let dateFormatter  = DateFormatter()
                    dateFormatter.timeZone = Calendar.current.timeZone
                    dateFormatter.locale = Calendar.current.locale
                    dateFormatter.dateFormat = "HH:mm"
                    return dateFormatter
                }()
                
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
                var Class = "S"
                
                let input = "\(UserInformation[3])"
                
                var GradeString = "\(input)"
                GradeString.removeLast(4)
                GradeString.removeFirst()
                let Grade = Int(GradeString)!
                
                var ClassString = "\(input)"
                ClassString.removeLast(3)
                
                Class = ClassString
                Class = "\(Class.last!)"
                
                
                //Elective
                var isElective = false
                
                //Adoption
                let CalendarCalendar = Calendar(identifier: .gregorian)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MM yyyy"
                
                
                //DayToDisplay Mon -> 0, Tue -> 1, Fri -> 4
                
                if (CalendarCalendar.isDateInToday(formatter.date(from: "22 11 2018")!) && Date() < TimeBoundary!) ||
                    (CalendarCalendar.isDateInToday(formatter.date(from: "21 11 2018")!) && Date() > TimeBoundary!){
                    DayToDisplay = 4
                }
               
                
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
                    
                    if (CalendarCalendar.isDateInToday(formatter.date(from: "22 11 2018")!) && Date() < TimeBoundary!) ||
                        (CalendarCalendar.isDateInToday(formatter.date(from: "21 11 2018")!) && Date() > TimeBoundary!){
                        cell.textLabel?.text = "22/11 Thu Adopts Fri Timetable"
                    }
                   
                    
                    cell.textLabel?.font = UIFont(name: "Helvetica", size: BigFont)
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: BigFont)
                    cell.textLabel?.textAlignment = .center
                    return cell
                }
                
               
                
                //Subject
                var out = ""
                if Grade >= 7 && Grade <= 9 {
                    formSection = classArrayLow
                } else if Grade >= 10 && Grade <= 12 {
                    formSection = classArrayHigh
                }
                
                let period = "\(indexPath.row)"
                
                
                cell.detailTextLabel?.textColor = UIColor.gray
                cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: SmallFont)
                
                self.lessonArray = [[String]]()
                
                    if teacherOrStudent() == "t" {
                        
                        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "import_lesson", ofType: "csv")!)
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                            let rows = (String(data: data!, encoding: .utf8)?.split(separator: "\r\n"))!
                            for row in rows {
                                let rowInfos = "\(row)".split(separator: ",")
                                var rowInfosInString = [String]()
                                for cell in rowInfos {
                                    rowInfosInString += ["\(cell)"]
                                }
                                self.lessonArray += [rowInfosInString]
                            }
                            let teacher = timetableChoice
                            var output = "", locOutput = ""
                            for row in self.lessonArray {
                                if row[0] == teacher && row[1] == "\(DayToDisplay)" && row[2] == period {
                                    output += "\(row[4]) \(row[3]) / "
                                    locOutput += "\(row[5]) / "
                                    if row.count > 6 {
                                        output += "\(row[7]) \(row[6]) / "
                                        locOutput += "\(row[8]) / "
                                    }
                                }
                            }
                            if output != "" && locOutput != "" {
                                output.removeLast(3)
                                locOutput.removeLast(3)
                            }
                            DispatchQueue.main.async {
                                cell.textLabel?.text = output.replacingOccurrences(of: "CLP C", with: "C")
                                cell.detailTextLabel?.text = locOutput
                            }
                            
                            }.resume()
                        
                    } else if teacherOrStudent() == "s" && isInternetAvailable(){
                        
                        let Class = "\(UserInformation[3].split(separator: "-")[0])"
                        
                        if IBClass.contains(Class){
                            tableView.separatorStyle = .none
                            cell.isUserInteractionEnabled = false
                            cell.textLabel?.text = ""
                            cell.detailTextLabel?.text = ""
                            tableView.reloadData()
                            setupSpinner(view: tableView)
                            //ParseTimetable()
                            tableView.reloadData()
                            return cell
                        }
                        
                        URLSession.shared.dataTask(with: timetableLink(ofClass: Class)) { (data, response, error) in
                            if let data = data {
                                let rows = (String(data: data, encoding: .utf8)?.components(separatedBy: "<br />"))!
                                for row in rows {
                                    let rowInfos = "\(row)".split(separator: "|")
                                    var rowInfosInString = [String]()
                                    for cell in rowInfos {
                                        rowInfosInString += ["\(cell)"]
                                    }
                                    
                                    self.lessonArray += [rowInfosInString]
                                }
                                self.lessonArray.removeLast()
                                
                                self.lessonArray = self.lessonArray.removeDuplicates()
                                
                                
                                var output = "", teacherOutput = ""
                                
                                for row in self.lessonArray {
                                    
                                    if row[0] == "\(DayToDisplay+1)" && row[1] == period {
                                        
                                        output += "\(row[3]) | "
                                        teacherOutput += "\(row[2]) | "
                                        
                                    }
                                }
                                if output != "" && teacherOutput != "" {
                                    output.removeLast(3)
                                    teacherOutput.removeLast(3)
                                }else{
                                    output = "Activity Period"
                                    teacherOutput = ""
                                }
                                DispatchQueue.main.async {
                                    cell.textLabel?.text = output
                                    cell.detailTextLabel?.text = teacherOutput
                                }
                                
                                
                            }
                            
                            
                            
                            }.resume()
                        
                    
                    
                
                    /*
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
                    let UpperCaseArray = ["FIS", "MACO", "MAM1", "MAM2", "BAFS", "D&T", "I&D", "ICT", "SCHD"]
                    
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
                    
                    */
                    
                    
                
            
                }else{
                    tableView.separatorStyle = .none
                    cell.isUserInteractionEnabled = false
                    cell.textLabel?.text = ""
                    cell.detailTextLabel?.text = ""
                    tableView.reloadData()
                    setupSpinner(view: tableView)
                    //ParseTimetable()
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
                
                if indexPath.row < 4 {
                    if tableView.tag == 10001 - logInNumber{
                        
                        if !array.isEmpty{
                            self.EventsAreLoaded = true
                            
                            cell.accessoryType = .disclosureIndicator
                            
                            //Title
                            cell.textLabel!.text = array[indexPath.row].Title
//                            cell.textLabel!.adjustsFontSizeToFitWidth = true
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
                            //self.ParseTimetable()
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
                if circulars.isEmpty{
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
                        //ParseTimetable()
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
                    //ParseTimetable()
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
                return self.scrollView.viewWithTag(10001)!.frame.size.height / 4 - 7
            }else{
                return 28
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var logInNumber = 0
        if !LoggedIn || teacherOrStudent() == ""{
            logInNumber = 1
        }
        
        let IBClass = ["G10G", "G10L", "G11G", "G11L", "G12G", "G12L"]
        
        if LoggedIn && teacherOrStudent() == "s" && tableView.tag == self.scrollView.viewWithTag(10000 - logInNumber)!.tag{
            if !IBClass.contains("\(UserInformation[3].split(separator: "-")[0])"){
                self.GoToTimetable()
            }
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
                if selectedSegment != 1{
                    selectedSegment = 1
                    segmentChanged = true
                }
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
                destinationFeature = 0
                if selectedSegment != 0{
                    selectedSegment = 0
                    segmentChanged = true
                }
                selectedSegment = 0
                tabBarController?.selectedIndex = 1
            }
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        if isInternetAvailable(){
            label.text = "Please Reload"
        }else{
            label.text = "Please check your Internet connectivity"
        }
        
        
        let IBClass = ["G10G", "G10L", "G11G", "G11L", "G12G", "G12L"]
        
        if LoggedIn && UserInformation.count > 3{
            var Class = "\(UserInformation[3])"
            Class.removeLast(3)
            
            if  teacherOrStudent() == "s" && IBClass.contains(Class) && view.tag == 10000{
                label.text = "Timetable for IB boys will be available soon"
                spinner.isHidden = true
            }
        }
        
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
        if LoggedIn && loginID != "" {
            if UserInformation.count >= 5 && UserInformation.count % 3 != 0{
                return "s"
            }
            
        }
        return ""
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        LoggedIn = UserDefaults.standard.string(forKey: "loginID") != "" &&  (UserDefaults.standard.string(forKey: "loginID") != nil /*|| (UserDefaults.standard.string(forKey: "loginID")?.isEmpty)!*/)
        if let x = UserDefaults.standard.string(forKey: "loginID") {
            loginID = x
        }
        //let teacherOrStudent() = "\(self.teacherOrStudent())"
        
        tabBarPage = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            var logInNumber = 0
            if !LoggedIn || self.teacherOrStudent() == ""{
                logInNumber = 1
            }else{
                logInNumber = 0
            }
            
            if LoggedIn && timetable == nil{
                DispatchQueue.main.async{
                    //self.ParseTimetable()
                    if self.scrollView.viewWithTag(10000 - logInNumber) != nil{
                        (self.scrollView.viewWithTag(10000 - logInNumber)! as! UITableView).reloadData()
                    }
                }
            }else if EventsArray.isEmpty{
                DispatchQueue.main.async{
                    self.ParseEvents()
                    if self.scrollView.viewWithTag(10001 - logInNumber) != nil{
                        (self.scrollView.viewWithTag(10001 - logInNumber)! as! UITableView).reloadData()
                    }
                }
            }else if circulars.isEmpty{
                DispatchQueue.main.async{
                    self.ParseNewsCurriculars()
                    if self.scrollView.viewWithTag(10002 - logInNumber) != nil{
                        (self.scrollView.viewWithTag(10002 - logInNumber)! as! UITableView).reloadData()
                    }
                }
            }else if news == nil{
                DispatchQueue.main.async{
                    self.ParseNewsCurriculars()
                    if self.scrollView.viewWithTag(10003 - logInNumber) != nil{
                        (self.scrollView.viewWithTag(10003 - logInNumber)! as! UITableView).reloadData()
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            
            let Page = (UserDefaults.standard.integer(forKey: CurrenttableIndexKey))
            var page = CGFloat(Page)
            
            
            if OldUser.count != UserInformation.count && page != 3{
                page = 0
            }
            
            if page > 2 && self.teacherOrStudent() == "s"{
                print(page, self.teacherOrStudent())
                self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * page, y: 0), animated: false)
            }else if page <= 2{
                self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * page, y: 0), animated: false)
            }
            
            OldUser = UserInformation
        }
        
        
        //let Page = UserDefaults.standard.integer(forKey: )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let pageNumber = round(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        CurrentTableIndex = Int(pageNumber)
        UserDefaults.standard.set(CurrentTableIndex, forKey: CurrenttableIndexKey)
        print("DidDisappear", UserDefaults.standard.set(CurrentTableIndex, forKey: CurrenttableIndexKey))
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
            
            previewingContext.sourceRect = ((previewingContext.sourceView as! UITableView).cellForRow(at: indexPath!)?.frame)!
            
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
        for i in 10001...10003{
            if teacherOrStudent() == "s"{
                let table = self.scrollView.viewWithTag(i)! as! UITableView
                
                var logInNumber = 0
                if !LoggedIn || self.teacherOrStudent() == ""{
                    logInNumber = 1
                }else{
                    logInNumber = 0
                }
                
                table.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.viewDidLoad()
            //self.ParseTimetable()
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
        
        func HideArrow(tag: Int){
            (self.view.viewWithTag(tag)! as! UIButton).isEnabled = false
            (self.view.viewWithTag(tag)! as! UIButton).isHidden = true
            for i in self.view.subviews{
                if i.tag == tag{
                    i.isHidden = true
                }
            }
        }
        
        
        func ShowArrow(tag: Int){
            (self.view.viewWithTag(tag)! as! UIButton).isEnabled = true
            (self.view.viewWithTag(tag)! as! UIButton).isHidden = false
            (self.view.viewWithTag(tag)! as! UIButton).imageView?.tintColor.withAlphaComponent(0.6)
        }
        
        
        if scrollView == self.scrollView{
            if scrollView.contentOffset.x >= scrollView.contentSize.width - self.view.frame.height{
                HideArrow(tag: 60000)
            }else{
                ShowArrow(tag: 60000)
            }
            
            if scrollView.contentOffset.x < self.view.frame.width{
                HideArrow(tag: 50000)
            }else{
                ShowArrow(tag: 50000)
            }
            
            
            if LoggedIn && teacherOrStudent() == "s"{
                if CurrentTableIndex == 1 || CurrentTableIndex == 2{
                    ShowArrow(tag: 50000)
                    ShowArrow(tag: 60000)
                }
            }else if !LoggedIn || teacherOrStudent() == ""{
                if CurrentTableIndex == 1{
                    ShowArrow(tag: 50000)
                    ShowArrow(tag: 60000)
                }
            }
        }
        
        /*
         if CurrentTableIndex == 1{
         (self.view.viewWithTag(50000)! as! UIButton).isEnabled = true
         (self.view.viewWithTag(50000)! as! UIButton).isHidden = false
         (self.view.viewWithTag(50000)! as! UIButton).imageView?.tintColor.withAlphaComponent(0.6)
         
         (self.view.viewWithTag(60000)! as! UIButton).isEnabled = true
         (self.view.viewWithTag(60000)! as! UIButton).isHidden = false
         (self.view.viewWithTag(60000)! as! UIButton).imageView?.tintColor.withAlphaComponent(0.6)
         }
         */
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        CurrentTableIndex = Int(pageNumber)
        (self.view.viewWithTag(200)! as! UIPageControl).currentPage = Int(pageNumber)
        
        UserDefaults.standard.set(CurrentTableIndex, forKey: CurrenttableIndexKey)
        
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


