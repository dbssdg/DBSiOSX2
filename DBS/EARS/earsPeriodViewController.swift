//
//  earsPeriodViewController.swift
//  DBS
//
//  Created by SDG on 26/3/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

struct EarsByPeriod : Decodable {
    let stud : String
    let title : String
    let period : String
    let location : String
    let eventDate : String
    let remark : String
}

class earsPeriodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var earsByPeriod = [Int : [EarsByPeriod]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for i in 1...6 {
            URLSession.shared.dataTask(with: URL(string: "http://m-poll.dbs.edu.hk/poller/class.php?c=\(earsChoice)&p=\(i)")!) { (data, response, error) in
                
                do {
                    self.earsByPeriod[i-1] = try JSONDecoder().decode([EarsByPeriod].self, from: data!)
                    
                    DispatchQueue.main.async {
                        print(self.earsByPeriod[i-1])
                        print(i-1)
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
                
            }.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Period \(section+1)"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.earsByPeriod[section] == nil {
            return 0
        } else if self.earsByPeriod[section]!.isEmpty {
            return 1
        } else {
            return self.earsByPeriod[section]!.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "earsByPeriod")
        if self.earsByPeriod[indexPath.section]!.isEmpty {
            cell?.textLabel?.text = "No EARS Found"
            cell?.textLabel?.font = UIFont(name: "Helvetica Light", size: 16)
            cell?.detailTextLabel?.text = ""
        } else {
            cell?.textLabel?.text = self.earsByPeriod[indexPath.section]![indexPath.row].stud.capitalized
            cell?.detailTextLabel?.text = self.earsByPeriod[indexPath.section]![indexPath.row].title
        }
        cell?.textLabel?.numberOfLines = 0
        cell?.detailTextLabel?.numberOfLines = 0
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
