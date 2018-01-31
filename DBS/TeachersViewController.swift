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
        
        let jsonURL = "http://m-poll.dbs.edu.hk/poller/load_staff_info.php"
        let url = URL(string: jsonURL)
        
        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
        func backToInfoPage(action: UIAlertAction) { navigationController?.popViewController(animated: true) }
        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: backToInfoPage))
        
        if isInternetAvailable() {
            URLSession.shared.dataTask(with: url!) { (datas, response, error) in
                do {
                    self.teachers = try JSONDecoder().decode(Teacher.self, from: datas!)
                    for i in (self.teachers?.data)! {
                        let temp = (i["ENNAME"])!
                        var output = ""
                        for char in temp { if char != "\t" { output += "\(char)" } }
                        self.teacherArray += [output]
                    }
                    
                    DispatchQueue.main.async {
                        if self.teacherArray.count == 0 {
                            self.present(networkAlert, animated: true)
                        }
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
            cell.descriptionText.text = filteredTeachers[indexPath.row]
        } else {
            cell.descriptionText.text = teacherArray[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var teacherMail = String()
        if isSearching { teacherMail = filteredTeachers[indexPath.row] }
        else { teacherMail = teacherArray[indexPath.row] }
        teacherMail.removeLast()
        while teacherMail.count > 3  { teacherMail.removeFirst() }
        if "\(teacherMail.first!)" == "(" { teacherMail.removeFirst() }
        teacherMail = "dbs\(teacherMail.lowercased())@dbs.edu.hk"
        
        func configureMailController() -> MFMailComposeViewController {
            let mailComposerViewController = MFMailComposeViewController()
            mailComposerViewController.mailComposeDelegate = self
            mailComposerViewController.setToRecipients([teacherMail])
            mailComposerViewController.setSubject("")
            mailComposerViewController.setMessageBody("Dear", isHTML: false)
            return mailComposerViewController
        }
        func sendMail() {
            let mailComposeViewController = configureMailController()
            if MFMailComposeViewController.canSendMail() {
                present(mailComposeViewController, animated: true, completion: nil)
            } else {
                let networkAlert = UIAlertController(title: "ERROR", message: "Please check your mail availability.", preferredStyle: .alert)
                networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(networkAlert, animated: true)
                print("CAN'T SEND EMAIL")
            }
        }
        print(teacherMail)
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
        teachersTable.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
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
