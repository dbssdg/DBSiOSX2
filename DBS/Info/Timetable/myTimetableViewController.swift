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
    var selectedSegment = 0
    
//    var group = ""
//    var form = ""
    var lessonArray = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = timetableChoice
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        spinner.activityIndicatorViewStyle = .white
        spinner.backgroundColor = UIColor.gray
        spinner.layer.cornerRadius = 10
        spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.tag = 12345
        self.view.addSubview(spinner)
        
        if Int("\(timetableChoice[timetableChoice.index(timetableChoice.startIndex, offsetBy: 1)])") == nil {
            
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: "import_lesson", ofType: "csv")!)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let rows = (String(data: data!, encoding: .utf8)?.split(separator: "\n"))!
                for row in rows {
                    let rowInfos = "\(row)".split(separator: ",")
                    var rowInfosInString = [String]()
                    for cell in rowInfos {
                        rowInfosInString += ["\(cell)"]
                    }
                    self.lessonArray += [rowInfosInString]
                }
                DispatchQueue.main.async {
                    self.timetableTable.reloadData()
                    spinner.stopAnimating()
                }
                
            }.resume()
            
        } else {
            
            URLSession.shared.dataTask(with: timetableLink(ofClass: timetableChoice)) { (data, response, error) in
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
                
                DispatchQueue.main.async {
                    self.timetableTable.reloadData()
                    spinner.stopAnimating()
                }
                
            }.resume()
            
        }
        
    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = timetableChoice
//        timetableTable.separatorColor = UIColor.gray
//        timetableTable.separatorStyle = .singleLineEtched
//
//        //        selectedSegment = 1
//
//        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
//        func backToInfoPage(action: UIAlertAction) { navigationController?.popViewController(animated: true) }
//        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: backToInfoPage))
//
//
//        group = "\(timetableChoice.last!)"
//        form = timetableChoice
//        print(timetableChoice)
//        form.removeLast()
//        form.removeFirst()
//        print(form, group)
//
//        let jsonURL = "http://cl.dbs.edu.hk/mobile/common/timetable/timetable\(form).json"
//        print(jsonURL)
//        let url = URL(string: jsonURL)
//
//        if isInternetAvailable() {
//            URLSession.shared.dataTask(with: url!) { (data, response, error) in
//                do {
//                    if data != nil {
//                        timetable = try JSONDecoder().decode(TimetableJSON.self, from: data!)
//                    }
//
//                    DispatchQueue.main.async {
//                        spinner.stopAnimating()
//
//                        if timetable?.timetable.`class`.count == 0 {
//                            self.present(networkAlert, animated: true)
//                        }
//                        self.timetableTable.reloadData()
//                        self.title? += " (\((timetable?.timetable.`class`[formSection.index(of: self.group)!].teacher)!))"
//                    }
//                } catch {
//                    self.present(networkAlert, animated: true)
//                    print("ERROR")
//                }
//                }.resume()
//        } else {
//            present(networkAlert, animated: true)
//        }
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSegmentedControl()
        let noticeButton = UIBarButtonItem(title: "Notice", style: .plain, target: self, action: #selector(notice))
        self.navigationItem.rightBarButtonItem = noticeButton
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
        let day = "\(selectedSegment+1)", period = "\(indexPath.row+1)"
        
        print(timetableChoice[timetableChoice.index(timetableChoice.startIndex, offsetBy: 1)])
        if Int("\(timetableChoice[timetableChoice.index(timetableChoice.startIndex, offsetBy: 1)])") == nil {
            
//            let teacher = timetableChoice
//            var output = "", locOutput = ""
//            for row in lessonArray {
//                if row[0] == teacher && row[1] == day && row[2] == period {
//                    output += "\(row[4]) \(row[3]) / "
//                    locOutput += "\(row[5]) / "
//                    if row.count > 6 {
//                        output += "\(row[7]) \(row[6]) / "
//                        locOutput += "\(row[8]) / "
//                    }
//                }
//            }
//            if output != "" && locOutput != "" {
//                output.removeLast(3)
//                locOutput.removeLast(3)
//            }
//            cell.textLabel?.text = output.replacingOccurrences(of: "CLP C", with: "C")
            
//            cell.detailTextLabel?.text = locOutput
            
            
            var classes = "", location = "", subject = ""
            
            for ROW in lessonArray {
                
                if ROW[0] == timetableChoice && ROW[1] == "\(day)" && ROW[2] == period {
                    
                    classes += "\(ROW[4]) / "
                    subject += "\(ROW[3]) / "
                    location += "\(ROW[5]) / "
                    if ROW.count > 6 {
                        classes += "\(ROW[7]) / "
                        subject += "\(ROW[6]) / "
                    }
                }
            }
            
            
            
            if classes != "" && location != "" {
                classes.removeLast(3)
                location.removeLast(3)
            }
            let textLabelString = String(classes.components(separatedBy: " / ").removeDuplicates().joined(separator: ", ") + " — " + subject.components(separatedBy: " / ").removeDuplicates().joined()).replacingOccurrences(of: "CLP — C", with: "C")
            if !(self.view.viewWithTag(12345) as! UIActivityIndicatorView).isHidden {
                cell.textLabel?.text = ""
            } else if textLabelString == " — " {
                cell.textLabel?.text = "--"
            } else {
                cell.textLabel?.text = textLabelString
            }
            
            cell.detailTextLabel?.text = location.components(separatedBy: " / ").removeDuplicates().joined(separator: ", ")
            
        } else {
            
            var output = "", teacherOutput = ""
            for row in self.lessonArray {
                if row[0] == day && row[1] == period {
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
            if !(self.view.viewWithTag(12345) as! UIActivityIndicatorView).isHidden || !isInternetAvailable(){
                cell.textLabel?.text = ""
            } else {
                cell.textLabel?.text = output
            }
            cell.detailTextLabel?.text = teacherOutput
            
        }
        
//        var out = ""
//        if Int(form)! >= 7 && Int(form)! <= 9 {
//            formSection = classArrayLow
//        } else if Int(form)! >= 10 && Int(form)! <= 12 {
//            formSection = classArrayHigh
//        }
//
//        if timetable != nil {
//            print((timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].name)!)
//            for i in (timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].name)! {
//                out += "\(i.decodeUrl().capitalized.replacingOccurrences(of: "Schd", with: "SCHD").replacingOccurrences(of: "Fis", with: "FIS").replacingOccurrences(of: "Maco", with: "MACO").replacingOccurrences(of: "Mam", with: "MAM").replacingOccurrences(of: "Bafs", with: "BAFS").replacingOccurrences(of: "Ict", with: "ICT").replacingOccurrences(of: "Dse", with: "DSE")) | "
//            }
//            if (timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].isActivityPeriod)! == true || ((timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].name)![0] == "" && indexPath.row != 5){
//                out = "Activity Period   "
//            }
//            out.removeLast(3)
//            if out.count > 30{
//
//            }
//            cell.textLabel?.text = out
//
//            out = ""
//            for i in (timetable?.timetable.`class`[formSection.index(of: self.group)!].day[selectedSegment].lesson[indexPath.row].teacher)! {
//                out += "\(i.uppercased()) | "
//            }
//            out.removeLast(3)
//            cell.detailTextLabel?.text = out
//        }

        cell.textLabel?.numberOfLines = Int((self.view.frame.height-40)/(6+2)/30)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        //cell.textLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: 0)
        cell.detailTextLabel?.textColor = .gray
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
        for subview in self.view.subviews {
            if (subview as? TwicketSegmentedControl) != nil {
                hasSegmentedControl = true
            }
        }

        if !hasSegmentedControl {
            let titles = ["Mon", "Tue", "Wed", "Thur", "Fri"]
            let segmentedControl = TwicketSegmentedControl()
            if let tabBarY = self.tabBarController?.tabBar.frame.origin.y {
                segmentedControl.frame = CGRect(x: 0, y: tabBarY - 40, width: self.view.frame.width, height: 40)
            } else {
                segmentedControl.frame = CGRect(x: 0, y: self.view.frame.height - 40, width: self.view.frame.width, height: 40)
            }
            segmentedControl.setSegmentItems(titles)
            segmentedControl.delegate = self

            //Init Day
            var DayToDisplay = 0
            var calendar = Calendar(identifier: .gregorian)
            calendar.firstWeekday = -1

            let CurrentDay = calendar.component(.weekday, from: Date()) - 1
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
            if CalendarCalendar.isDateInToday(formatter.date(from: "14 05 2018")!) || CalendarCalendar.isDateInToday(formatter.date(from: "13 06 2018")!) || CalendarCalendar.isDateInToday(formatter.date(from: "12 06 2018")!){
                DayToDisplay = 4
            }
            if CalendarCalendar.isDateInToday(formatter.date(from: "04 06 2018")!) || CalendarCalendar.isDateInToday(formatter.date(from: "03 06 2018")!) || CalendarCalendar.isDateInToday(formatter.date(from: "02 06 2018")!){
                DayToDisplay = 2
            }


            segmentedControl.move(to: DayToDisplay)
            selectedSegment = DayToDisplay
            view.addSubview(segmentedControl)
        } else {
            for subview in self.view.subviews {
                if let segmentedControl = (subview as? TwicketSegmentedControl) {
                    if let tabBarY = self.tabBarController?.tabBar.frame.origin.y {
                        if segmentedControl.frame.origin.y + segmentedControl.frame.height != tabBarY {
                            segmentedControl.removeFromSuperview()
                            setUpSegmentedControl()
                        }
                    }
                }
            }

        }
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
        
        return URL(string: "http://www2.dbs.edu.hk/qschedule/qqexport.php?type=c&id=\(ofClass)&md5=\(output)")!
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

