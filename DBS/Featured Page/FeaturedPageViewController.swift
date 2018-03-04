//
//  FeaturedPageViewController.swift
//  DBS
//
//  Created by SDG on 9/10/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import SystemConfiguration

struct newsData : Decodable {
    let title : [String]
    let date : [String]
}
var circularViewURL = ""
var newsIndex = Int()
var newsTotal = Int()

var circulars = [String : [String : String]]()
var circularTimeArray = [String]()
var circularTitleArray = [String]()
var pinnedCircular = 2

var news : newsData?
var newsTitleArray = [String]()
var newsDateArray = [String]()

var selectedSegment = 0

class FeaturedPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TwicketSegmentedControlDelegate, UISearchBarDelegate, UIViewControllerPreviewingDelegate {
    
    
    var isSearching = false
    
    /*
    var circulars = [String : [String : String]]()
    var circularTimeArray = [String]()
    var circularTitleArray = [String]()
    
    var news : newsData?
    var newsTitleArray = [String]()
    var newsDateArray = [String]()
    */
    
    var filteredCirculars = [String]()
    var filteredNews = [String]()
    
    @IBOutlet weak var featuredTable: UITableView!
    let featuredSearch = UISearchController(searchResultsController: nil)
    
    @IBAction func reloadPage(_ sender: Any) {
        didSelect(0)
        viewDidLoad()
    }
    
    func ParseJSON() {
        let circularsJSONURL = "http://www.dbs.edu.hk/circulars/json.php"
        let circularsURL = URL(string: circularsJSONURL)
        let newsJSONURL  = "http://www.dbs.edu.hk/newsapp.php"
        let newsURL = URL(string: newsJSONURL)
        
        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        circularTitleArray.removeAll()
        circularTimeArray.removeAll()
        newsTitleArray.removeAll()
        newsDateArray.removeAll()
        
        removeSpinner(view: featuredTable)
        setupSpinner(view: featuredTable)
        
        if isInternetAvailable() {
            URLSession.shared.dataTask(with: circularsURL!) { (data, response, error) in
                if data != nil {
                    do {
                        circulars = try JSONDecoder().decode([String:[String:String]].self, from: data!)
                    
                        pinnedCircular = 2
                        for i in 1...circulars.values.count {
                            if circulars.count > circularTitleArray.count {
                                circularTimeArray += [(circulars["\(i)"]!["time"]!)]
                                circularTitleArray += [(circulars["\(i)"]!["title"]!)]
                            }
                        }
                        DispatchQueue.main.async {
                            self.removeSpinner(view: self.featuredTable)
                            self.featuredTable.reloadData()
                            print("\(circularTitleArray.count)A")
                        }
                        
                    } catch {
                        print("ERROR")
                    }
                }
            }.resume()
            URLSession.shared.dataTask(with: newsURL!) { (data, response, error) in
                if data != nil {
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
                        DispatchQueue.main.async {
                            self.featuredTable.reloadData()
                            print("\(newsTitleArray.count)A")
                        }
                    
                    }
                    catch {
                        print("ERROR")
                    }
                }
            }.resume()
            
        } else {
            //present(networkAlert, animated: true)
//            if newsDateArray.isEmpty{
                featuredTable.reloadData()
                removeSpinner(view: featuredTable)
                setupSpinner(view: featuredTable)
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featuredTable.delegate = self
        featuredTable.dataSource = self
        featuredSearch.searchBar.delegate = self
        featuredSearch.dimsBackgroundDuringPresentation = false
        
        ParseJSON()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = featuredSearch
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        setUpSegmentedControl()
        
        //Refresher
        let refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Reload")
        refresher.tag = 10000
        refresher.addTarget(self, action: #selector(reloadTableData(_:)), for: UIControlEvents.valueChanged)
        featuredTable.addSubview(refresher)
        
        
        registerForPreviewing(with: self, sourceView: featuredTable)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        while tableView(featuredTable, numberOfRowsInSection: 0) <= 0 && isInternetAvailable() {
            for i in self.view.subviews { if i.tag == 1 {
                (i as! TwicketSegmentedControl).isEnabled = false
                } }
            featuredTable.reloadData()
        }
        
        for i in self.view.subviews { if i.tag == 1 {
            (i as! TwicketSegmentedControl).isEnabled = true
            } }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isInternetAvailable() && !circularTimeArray.isEmpty{
            removeSpinner(view: featuredTable)
        }
        
        if selectedSegment == 0 {
            if isSearching {
                return filteredCirculars.count
            }
            return circularTitleArray.count
        } else if selectedSegment == 1 {
            if isSearching {
                return filteredNews.count
            }
            return newsTitleArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pinnedCircular > 0 {
            pinnedCircular -= 1
            print("\(pinnedCircular)th post")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "featuredCell")! as UITableViewCell
        if !circularTimeArray.isEmpty {
            if selectedSegment == 0 {
                if isSearching {
                    cell.textLabel?.text = filteredCirculars[indexPath.row]
                    cell.detailTextLabel?.text = ""
                } else {
                    if circulars.count <= circularTitleArray.count {
                        let circularTimes = (circularTimeArray[indexPath.row]).split(separator: " ")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy"
                        if Int(circularTimes[2])! > Int(dateFormatter.string(from: Date()))! {
                            cell.detailTextLabel?.text = "Pinned"
                        } else {
                            cell.detailTextLabel?.text = (circularTimeArray[indexPath.row])
                        }
                        cell.textLabel?.text = circularTitleArray[indexPath.row]
                    }
                    
                }
            } else if selectedSegment == 1 {
                if isSearching {
                    cell.textLabel?.text = filteredNews[indexPath.row]
                    cell.detailTextLabel?.text = ""
                } else {
                    cell.textLabel?.text = newsTitleArray[indexPath.row]
                    cell.detailTextLabel?.text = newsDateArray[indexPath.row]
                }
            }
        } else {
            setupSpinner(view: featuredTable)
        }
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.textColor = .black
        
        if cell.detailTextLabel?.text! == "Pinned"{
            cell.detailTextLabel?.textColor = UIColor.orange
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSegment == 0 {
            
            if isSearching {
               let indexInNonFiltered = circularTitleArray.index(of: filteredCirculars[indexPath.row])
                circularViewURL = (circulars["\(indexInNonFiltered!+1)"]!["attach_url"]!)
            } else {
                circularViewURL = (circulars["\(indexPath.row+1)"]!["attach_url"]!)
            }
            
            searchBarCancelButtonClicked(featuredSearch.searchBar)
            searchBarTextDidEndEditing(featuredSearch.searchBar)
            featuredSearch.isActive = false
            
            performSegue(withIdentifier: "Circular Segue", sender: self)
            
        } else if selectedSegment == 1 {
            
            if isSearching {
                let indexInNonFiltered = newsTitleArray.index(of: filteredNews[indexPath.row])
                newsIndex = indexInNonFiltered!
            } else {
                newsIndex = indexPath.row
            }
            
            newsTotal = newsTitleArray.count
            searchBarCancelButtonClicked(featuredSearch.searchBar)
            searchBarTextDidEndEditing(featuredSearch.searchBar)
            featuredSearch.isActive = false
            performSegue(withIdentifier: "News Segue", sender: self)
        
        }
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        tableView.cellForRow(at: indexPath)?.selectionStyle = .default
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = featuredTable.indexPathForRow(at: location) else {
            return nil
        }
        if selectedSegment == 0 {
            circularViewURL = (circulars["\(indexPath.row+1)"]!["attach_url"]!)
            let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Circular Web") as! circularsWebViewController
            return detailViewController
        } else if selectedSegment == 1 {
            newsIndex = indexPath.row
            newsTotal = newsTitleArray.count
            let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "News Detail") as! newsDetailViewController
            return detailViewController
        }
        return nil
    }
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text! != "" {
            isSearching = true
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text? = ""
        isSearching = false
        featuredTable.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { filteredCirculars = circularTitleArray.filter({ (text) -> Bool in
            let tmp = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        filteredNews = newsTitleArray.filter({ (text) -> Bool in
            let tmp = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filteredCirculars.count == 0 && filteredNews.count == 0 && searchBar.text! == "" {
            isSearching = false
        } else {
            isSearching = true
        }
        featuredTable.reloadData()
    }
    
    func didSelect(_ segmentIndex: Int) {
        selectedSegment = segmentIndex
        featuredTable.reloadData()
        if tableView(featuredTable, numberOfRowsInSection: 1) > 0 {
            featuredTable.scrollToRow(at: [0,0], at: .top, animated: true)
        }
    }
    
    func setUpSegmentedControl() {
        let titles = ["Circulars", "News"]
        let frame = CGRect(x: self.view.frame.width / 2 - self.view.frame.width * 0.45 , y: self.view.frame.height * 0.85, width: self.view.frame.width * 0.9, height: 40)
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self as? TwicketSegmentedControlDelegate
        segmentedControl.tag = 1
        segmentedControl.move(to: selectedSegment)
        view.addSubview(segmentedControl)
        
    }
    
    func setupSpinner(view: UITableView) {
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = self.view.center
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.tag = 1000
        featuredTable.addSubview(spinner)
        
        let label = UILabel(frame: CGRect(x: 0, y: spinner.frame.origin.y + 20, width: view.frame.width, height: 40))
        
        if isInternetAvailable() {
            label.text = ""
        } else {
            label.text = "Please check your Internet connectivity"
        }
        label.textColor = spinner.color
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textAlignment = .center
        label.tag = 2000
        featuredTable.addSubview(label)
        
        
        featuredTable.separatorStyle = .none
        
    }
    
    func removeSpinner(view: UITableView){
        for subview in featuredTable.subviews{
            if subview.tag == 1000 || subview.tag == 2000 {
                subview.removeFromSuperview()
            }
        }
        featuredTable.separatorStyle = .singleLine
    }
    
    func reloadTableData(_ refreshControl: UIRefreshControl) {
        ParseJSON()
//        didSelect(0)
        featuredTable.reloadData()
        refreshControl.endRefreshing()
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

    

