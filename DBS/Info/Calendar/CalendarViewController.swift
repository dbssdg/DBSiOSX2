//
//  CalendarViewController.swift
//  DBS
//
//  Created by SDG on 18/10/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CSVImporter
import SystemConfiguration


enum EventTypes{
    case SE,PH,SH
}

struct events{
    var Title : String
    var StartDate : Date
    var EndDate : Date
    var EventType : EventTypes
    
}

var PassingEvent = ("G7-G11 Mid-year Exam (4-19)", Date(), Date(), EventTypes.SE)

var TodayEvent = [events] ()





extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var CalendarView: JTAppleCalendarView!
    @IBOutlet weak var CalendarStackView: UIStackView!
    @IBOutlet weak var EventsTableView: UITableView!
    @IBOutlet weak var StackView: UIStackView!
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var todayButton: UIButton!
    
    var didScroll = false
    
    @IBAction func TodayButton(_ sender: Any) {
        CalendarView.scrollToDate(Date())
        CalendarView.deselectAllDates()
        CalendarView.selectDates([Date()])
        EventsTableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.CalendarView.selectDates([Date()])
            self.EventsTableView.reloadData()
        })
        
    }

    
    var index = 0
    
    
    var CurrentDayEventsArray = [(Date, events)] ()

    var CurrentDay = Date()
    var DayEvents = [(Date, events)] ()
    
    var SEBlue = UIColor(red: 97.0/255.0, green: 142.0/255.0, blue: 249.0/255.0, alpha: 1)
    var SHOrange = UIColor(red: 1, green: 142.0/255.0, blue: 80.0/255.0, alpha: 1)
    
    
    
    
    var currentmonth : String = ""
    let formatter : DateFormatter = {
        let dateFormatter  = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    

    @IBOutlet weak var DaysStack: UIStackView!
    
    func addingCalendar(){
        let StringURL = "https://calendar.google.com/calendar/ical/g.dbs.edu.hk_tdmjqqq8vlv8keepi7a65f7j7s%40group.calendar.google.com/public/basic.ics"
        let url = URL(string: StringURL)!
        if isInternetAvailable(){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
            networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(networkAlert, animated: true)
        }
    }
    
    func WillAddCalendar(acrion: UIAlertAction){
        addingCalendar()
    }
    
    func ShareCalendar(action: UIAlertAction){
        let StringURL = "https://calendar.google.com/calendar/ical/g.dbs.edu.hk_tdmjqqq8vlv8keepi7a65f7j7s%40group.calendar.google.com/public/basic.ics"
        let url = URL(string: StringURL)!
        let ActivityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(ActivityController, animated: true, completion: nil)
    }
    func ActionSheetFunc(){
        //Actions
        let AddCalendarAction = UIAlertAction(title: "Add Calendar to Phone", style: .default, handler: WillAddCalendar)
        let ShareAction = UIAlertAction(title: "Share Calendar", style: .default, handler: ShareCalendar)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        //Action Sheet
        let ActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ActionSheet.addAction(AddCalendarAction)
        ActionSheet.addAction(ShareAction)
        ActionSheet.addAction(CancelAction)
        present(ActionSheet, animated: true)
    }
    
    func AllEvents(){
        performSegue(withIdentifier: "Calendar to All Events", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calendar"
        
        setUpCalendarView()
        ParseCSV()
        
        //UI Set up
        year.frame = CGRect(x: 16, y: self.view.frame.height * 0.125, width: 100, height: 30)
        
        todayButton.frame = CGRect(x: self.view.frame.width - todayButton.frame.size.width - 16, y: year.frame.origin.y, width: 0, height: 30)
        todayButton.sizeToFit()
        
        month.frame = CGRect(x: 16, y: year.frame.origin.y + year.frame.size.height, width: self.view.frame.width, height: 30)
        
        CalendarView.frame.size.width = self.view.frame.width
        CalendarView.frame.size.height = self.view.frame.height * 0.425
        CalendarView.sizeToFit()
        
        CalendarStackView.frame.origin.y = self.view.frame.height * 0.25
        CalendarStackView.frame.origin.x = 0
        CalendarStackView.frame.size.width = self.view.frame.width
        CalendarStackView.frame.size.height = DaysStack.frame.height + CalendarView.frame.height
        
        
        StackView.frame = CalendarStackView.frame
        
        
        EventsTableView.frame.origin.y = CalendarStackView.frame.origin.y + CalendarStackView.frame.size.height
        EventsTableView.frame.origin.x = 0
        EventsTableView.frame.size.width = self.view.frame.width
        EventsTableView.frame.size.height = self.view.frame.height - EventsTableView.frame.origin.y
        EventsTableView.isScrollEnabled = true
        self.registerForPreviewing(with: self, sourceView: EventsTableView)
        
        //let EventsTableViewBottomConstraint = NSLayoutConstraint(item: EventsTableView, attribute: .bottomMargin, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0)
        //NSLayoutConstraint.activate([EventsTableViewBottomConstraint])
        
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        EventsArray = [events]()
        TodayEvent = [events]()
        CurrentDayEventsArray = [(Date, events)]()
        
        CalendarView.scrollToDate(Date())
        
        
        TodayButton(self)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let AddCalendar = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ActionSheetFunc))
        
        let AllEvents = UIBarButtonItem(title: "All Events", style: .plain, target: self, action: #selector(self.AllEvents))
        
        self.navigationItem.rightBarButtonItems = [AddCalendar, AllEvents]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CalendarView.selectDates([Date()])
        
        addingCalendar()
    }
    
    func ParseCSV (){
        let path = Bundle.main.path(forResource: "2017 - 2018 School Events New", ofType: "csv")!
        
        let importer = CSVImporter<[String: String]>(path: path)
        
        importer.startImportingRecords(structure: { (headerValues) -> Void in
        }) { $0 }.onFinish { importedRecords in
            for record in importedRecords {
                self.formatter.dateFormat = "d/M/yyyy"
                let EventStartDate = self.formatter.date(from: record["Start Date"]!)
                let EventEndDate = self.formatter.date(from: record["End Date"]!)
                
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
            
            self.ParseAdoptionTimetable()
            
            for i in TodayEvent{
                self.CurrentDayEventsArray += [(Date(), i)]
            }
            
            
            self.EventsTableView.reloadData()
            
        }
        
        
    }
    
    func ParseAdoptionTimetable(){
//        if let url = URL(string: "http://www.dbs.edu.hk/index.php?section=calendar&listall=1") {
//            do {
//                let html = try String(contentsOf: url)
//                for i in html.split(separator: ">") {
//                    if i.components(separatedBy: " adopts ").count  == 2 {
//                        let String = (i.split(separator: "<")[0])
//                        print(String)
//                        //events(Title: i.split(separator: "<")[0], StartDate: <#T##Date#>, EndDate: <#T##Date#>, EventType: <#T##EventTypes#>)
//                    }
//                }
//            }catch{
//                print("ERROR")
//            }
//        }
        let Formatter = DateFormatter()
        Formatter.dateFormat = "dd MM yyyy"
        
        EventsArray += [events(Title: "30/4 Mon Adopts Tue Timetable", StartDate: Formatter.date(from: "30 04 2018")!, EndDate: Formatter.date(from: "30 04 2018")!, EventType: .SE), events(Title: "14/5 Mon Adopts Fri Timetable", StartDate: Formatter.date(from: "14 05 2018")!, EndDate: Formatter.date(from: "14 05 2018")!, EventType: .SE)]
        EventsArray = EventsArray.sorted(by: { $0.StartDate <= $1.StartDate })
    }
    
    func setUpCalendarView(){
        // Set up calendar spacing
        CalendarView.minimumLineSpacing = 0
        CalendarView.minimumInteritemSpacing = 0
        
        // Set up labels
        CalendarView.visibleDates{(visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "yyyy"
            self.year.text = self.formatter.string(from: date)
            if self.year.text == self.formatter.string(from: Date()){
                self.year.textColor = UIColor.red
            } else {
                self.year.textColor = UIColor.black
            }
            

            
            
            self.formatter.dateFormat = "MMMM"
            self.month.text = self.formatter.string(from: date)
            self.currentmonth = self.formatter.string(from: date)
            if self.month.text == self.formatter.string(from: Date()){
                self.month.textColor = UIColor.red
            } else {
                self.month.textColor = UIColor.black
            }
            
        }
        
            
        
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
        
        
    }
    
    func LoadEvents(view: JTAppleCell?, cellState: CellState) -> Any {
        guard let validCell = view as? CustomCell else {return "Load Events Error"}
        let CellDate = cellState.date
        var CellDateEventsArray = [(Date, events)] ()
        
        for event in EventsArray{
            let EventStartDate = event.StartDate
            let EventEndDate = event.EndDate
            if CellDate >= EventStartDate && CellDate <= EventEndDate{
                CellDateEventsArray += [(CellDate, event)]
            }
        }
       CurrentDayEventsArray = CellDateEventsArray
        
        if cellState.date == Date(){
            self.EventsTableView.reloadData()
        }
        
        //CurrentDate = cellState.date
        
        return CellDateEventsArray
    }
    
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        
        var isPublicHoliday = false
        for i in CurrentDayEventsArray{
            if i.1.EventType == .PH{
                isPublicHoliday = true
            }
        }
        
        if cellState.isSelected {
            validCell.datelabel.textColor = UIColor.white
            
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                //validCell.datelabel.textColor = UIColor.init(red: 253/255.0, green: 114/255.0, blue: 116.0/255.0, alpha: 1.0)
                if cellState.day == .sunday || isPublicHoliday{
                    validCell.datelabel.textColor = UIColor.red
                }else{
                    validCell.datelabel.textColor = UIColor.black
                }
                validCell.isUserInteractionEnabled = true
            }else{
                validCell.datelabel.textColor = UIColor.lightGray
                //validCell.isUserInteractionEnabled = false
            }
        }
        
        
    }
    
    func setUpViewsForCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var count = 0
        for _ in CurrentDayEventsArray{
            count += 1
        }
        if count == 0{
            return 1
        }
       return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        DayEvents = CurrentDayEventsArray
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarEventCell")! as UITableViewCell
        
        cell.isUserInteractionEnabled = true
        
        
        if CurrentDayEventsArray.isEmpty{
            cell.textLabel?.text = "No events"
            cell.textLabel?.textAlignment = .center
            cell.detailTextLabel?.text = ""
            cell.imageView?.image = nil
            cell.isUserInteractionEnabled = false
            cell.accessoryType = .none
            return cell
        }
        
        //Manage Date
        let StartDate = CurrentDayEventsArray[indexPath.row].1.StartDate
        let EndDate = CurrentDayEventsArray[indexPath.row].1.EndDate
        
        self.formatter.dateFormat = "d/M"
        let StartDateString = formatter.string(from: StartDate)
        let EndDateString = formatter.string(from: EndDate)
        
        //Image
        let EventType = CurrentDayEventsArray[indexPath.row].1.EventType
        if let image = UIImage(named: "dot"){
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            cell.imageView?.image = tintableImage
        }
        
            switch EventType {
            case .PH:
                cell.imageView?.tintColor = UIColor.red
            case .SH:
                cell.imageView?.tintColor = SHOrange
            case .SE:
                cell.imageView?.tintColor = SEBlue
            default:
                cell.imageView?.tintColor = UIColor.red
            }
        
        //Title
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        cell.textLabel?.text = String(describing: CurrentDayEventsArray[indexPath.row].1.Title)
   
        //Subtitle
        let Subtitle = "\(StartDateString) - \(EndDateString)"
        if StartDate != EndDate{
            cell.detailTextLabel?.text = Subtitle
        }else{
            cell.detailTextLabel?.text = StartDateString
        }
        
        //Arrow
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        //cell.selectionStyle = .gray
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        PassingEvent = (DayEvents[index].1.Title, DayEvents[index].1.StartDate, DayEvents[index].1.EndDate, DayEvents[index].1.EventType)
        performSegue(withIdentifier: "Detail Event", sender: self)
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController = segue.destination as! DetailedEventViewController
        DestViewController.PassingEvent = (CurrentDayEventsArray[index].1.Title, CurrentDayEventsArray[index].1.StartDate, CurrentDayEventsArray[index].1.EndDate, CurrentDayEventsArray[index].1.EventType)
        
    }
    */
    
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = EventsTableView.indexPathForRow(at: location) else {
            return nil
        }
        
        previewingContext.sourceRect = EventsTableView.cellForRow(at: indexPath)!.frame
        
        let index = indexPath.row
        PassingEvent = (DayEvents[index].1.Title, DayEvents[index].1.StartDate, DayEvents[index].1.EndDate, DayEvents[index].1.EventType)
        let destViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Detail Event") as! DetailedEventViewController
        return destViewController
        
        
        return nil
    }
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
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







extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        EventsTableView.reloadData()
    }
    
    
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 09 01")
        let endDate = formatter.date(from: "2019 08 31")
        
        let generateInDates: InDateCellGeneration = .forAllMonths
        let generateOutDates: OutDateCellGeneration = .tillEndOfGrid
        
         let firstDayOfWeek: DaysOfWeek = .sunday
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!, numberOfRows: 4, calendar: Calendar.current, generateInDates: generateInDates, generateOutDates: generateOutDates, firstDayOfWeek: firstDayOfWeek, hasStrictBoundaries: true)
        
        
        //let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        
        let CalendarCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        CalendarCell.datelabel.text = cellState.text
        
        CalendarCell.selectedView.layer.cornerRadius = CalendarCell.selectedView.frame.width/2
        CalendarCell.backgroundColor = UIColor.white
        
        CalendarCell.EventCircle.layer.cornerRadius = CalendarCell.EventCircle.frame.width / 2
        CalendarCell.EventCircle.isHidden = true
        
        CalendarCell.SchoolHolidayBar.backgroundColor = self.SHOrange
        CalendarCell.SchoolHolidayBar.isHidden = true
        
        CalendarCell.isUserInteractionEnabled = false
        if cellState.dateBelongsTo == .thisMonth{
            
            CalendarCell.isSelected = false
        }
        
        LoadEvents(view: CalendarCell, cellState: cellState)
        for i in CurrentDayEventsArray{
            if i.1.EventType == .SH{
                CalendarCell.SchoolHolidayBar.isHidden = true
                CalendarCell.EventCircle.backgroundColor = SHOrange
                CalendarCell.EventCircle.isHidden = false
                break
            }else if i.1.EventType == .PH{
                CalendarCell.datelabel.textColor = UIColor.red
            }else if i.1.EventType == .SE{
                CalendarCell.EventCircle.backgroundColor = UIColor.lightGray
                CalendarCell.EventCircle.isHidden = false
            }else{
                
            }
        }
        
        if cellState.date == Date(){
            LoadEvents(view: CalendarCell, cellState: cellState)
            EventsTableView.reloadData()
        }
        
        handleCellTextColor(view: CalendarCell, cellState: cellState)
        handleCellSelected(view: CalendarCell, cellState: cellState)
        
        
        return CalendarCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        if didScroll{
            calendar.deselect(dates: [CurrentDay])
            didScroll = false
        }
        
        CurrentDay = date
        //calendar.deselectAllDates()
        //calendar.selectDates([date])
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelected(view: cell, cellState: cellState)
        LoadEvents(view: cell, cellState: cellState)
        EventsTableView.reloadData()
        
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelected(view: cell, cellState: cellState)
        //calendar.deselect(dates: [date])
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = self.formatter.string(from: date)
        
        
        formatter.dateFormat = "MMMM"
        month.text = self.formatter.string(from: date)
        
        setUpCalendarView()
        
    }
   
    func calendarDidScroll(_ calendar: JTAppleCalendarView) {
        didScroll = true
        
        
    }
    
    
}





    
//}
