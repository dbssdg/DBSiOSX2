//
//  TeachersViewController.swift
//  DBS
//
//  Created by SDG on 6/10/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import SystemConfiguration
import MessageUI

struct Teacher : Decodable {
    let data : [[String : String]]
}

class TeachersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MFMailComposeViewControllerDelegate {
    
    var teachers : Teacher?
    var teacherArray = [String]()
    var filteredTeachers = [String]()
    
    @IBOutlet weak var teachersTable: UITableView!
    let teacherSearch = UISearchController(searchResultsController: nil)
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Teachers"
        teachersTable.delegate = self
        teachersTable.dataSource = self
        teacherSearch.searchBar.delegate = self
        teacherSearch.dimsBackgroundDuringPresentation = false
        
        let jsonURL = "http://m-poll.dbs.edu.hk/poller/load_tstaff_info.php"
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "teacherInitialLoad", ofType: "txt")!)
        
        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
        func backToInfoPage(action: UIAlertAction) { navigationController?.popViewController(animated: true) }
        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: backToInfoPage))
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        if true{//isInternetAvailable() {
            URLSession.shared.dataTask(with: url) { (datas, response, error) in
                do {
                    self.teachers = try JSONDecoder().decode(Teacher.self, from: datas!)
                    for i in (self.teachers?.data)! {
                        let engName = (i["EngName"])!
                        let initial = (i["ShortName"])!
                        var output = ""
                        for char in engName { if char != "\t" { output += "\(char)" } }
                        output += " (\(initial))"
                        self.teacherArray += [output]
                    }
                    
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        self.teachersTable.reloadData()
                    }
                } catch {
                    self.present(networkAlert, animated: true)
                    print("ERROR")
                }
                }.resume()
            
        } else {
            present(networkAlert, animated: true)
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.searchController = teacherSearch
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        teachersTable.separatorStyle = .none
        teacherSearch.searchBar.placeholder = "Search for initials or names"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Swipe to the left to Email."
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateTitle), userInfo: nil, repeats: true)
    }
    
    @objc func updateTitle() {
        if self.title == "Teachers" {
            self.title = "Swipe to the left to Email."
        } else if self.title == "Swipe to the left to Email." {
            self.title = "Teachers"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredTeachers.count
        }
        return teacherArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teachersCell") as! descriptionsTableViewCell
        cell.selectionStyle = .none
        if isSearching {
            cell.descriptionText.text = filteredTeachers.sorted()[indexPath.row]
        } else {
            cell.descriptionText.text = teacherArray.sorted()[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let email = UITableViewRowAction(style: .normal, title: "Email") { action, index in
            var teacherMail = String()
            if self.isSearching { teacherMail = self.filteredTeachers.sorted()[indexPath.row] }
            else { teacherMail = self.teacherArray.sorted()[indexPath.row] }
            teacherMail.removeLast()
            while teacherMail.count > 3  { teacherMail.removeFirst() }
            if "\(teacherMail.first!)" == "(" { teacherMail.removeFirst() }
            teacherMail = "dbs\(teacherMail.lowercased())@dbs.edu.hk"
            
            if !MFMailComposeViewController.canSendMail() {
                let cannotSendAlert = UIAlertController(title: "ERROR", message: "Mail services are not available.", preferredStyle: .alert)
                cannotSendAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(cannotSendAlert, animated: true)
            } else {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setToRecipients([teacherMail])
                composeVC.setSubject("")
                composeVC.setMessageBody("Dear ", isHTML: false)
                self.present(composeVC, animated: true, completion: nil)
            }
        }
        email.backgroundColor = UIColor(red: 67/255, green: 132/255, blue: 247/255, alpha: 1)
        return [email]
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            isSearching = true
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            isSearching = false
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text? = ""
        isSearching = false
        teachersTable.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            isSearching = false
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTeachers = teacherArray.filter({ (text) -> Bool in
            let tmp = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filteredTeachers.count == 0 && searchBar.text! == "" {
            isSearching = false
        } else {
            isSearching = true
        }
        teachersTable.reloadData()
        if !filteredTeachers.isEmpty {
            teachersTable.scrollToRow(at: [0,0], at: .top, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
