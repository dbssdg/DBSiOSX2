//
//  myClassmatesViewController.swift
//  DBS
//
//  Created by Ben Lou on 19/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import SystemConfiguration


class myClassmatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myClassmates = [[String]]()
    @IBOutlet weak var myClassmatesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = classmateChoice
        
        let jsonURL = "http://ears.dbs.edu.hk/json/LoadClassInfo.php?op=getInfo_ClassMem&request=\(classmateChoice)"
        let url = URL(string: jsonURL)
        
        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
        func backToChoosePage(action: UIAlertAction) { navigationController?.popViewController(animated: true) }
        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: backToChoosePage))
        
        if isInternetAvailable() {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                do {
                    self.myClassmates = try JSONDecoder().decode([[String]].self, from: data!)
                    for i in self.myClassmates {
                        print(i)
                    }
                    
                    DispatchQueue.main.async {
                        if self.myClassmates.count == 0 {
                            self.present(networkAlert, animated: true)
                        }
                        self.myClassmatesTable.reloadData()
                    }
                } catch {
                    self.present(networkAlert, animated: true)
                    print("ERROR")
                }
            }.resume()
            
        } else {
            present(networkAlert, animated: true)
        }
        myClassmatesTable.separatorStyle = .none
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myClassmates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myClassmatesCell") as! descriptionsTableViewCell
        cell.descriptionText?.text = "(\(classmateChoice)-\(indexPath.row+1)) \(myClassmates[indexPath.row][2])"
        cell.selectionStyle = .none
        return cell
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
