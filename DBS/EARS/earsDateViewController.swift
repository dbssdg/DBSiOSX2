//
//  earsDateViewController.swift
//  DBS
//
//  Created by Ben Lou on 21/3/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

struct EARSEvent : Decodable {
    let id : String
    let title : String
    let link : String
    let period : String
    let location : String
    let remark : String
    let applyDate : String
    let participant : [String]
}
struct EARSByDate : Decodable {
    let date : String
    let events : [EARSEvent]
}
var earsByDate : EARSByDate?
var earsByDateSelected = Int()

class earsDateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var today: UIBarButtonItem!
    @IBOutlet var yesterday: UIBarButtonItem!
    @IBOutlet var tomorrow: UIBarButtonItem!
    
    var dateSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        spinner.activityIndicatorViewStyle = .white
        spinner.backgroundColor = .gray
        spinner.layer.cornerRadius = 10
        spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        URLSession.shared.dataTask(with: URL(string: "http://m-poll.dbs.edu.hk/poller/event.php?d=\(dateSelected)")!) { (data, response, error) in
            do {
                earsByDate = try JSONDecoder().decode(EARSByDate.self, from: data!)
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                    self.title = "EARS (\((earsByDate?.date)!))"
                    if (earsByDate?.events.isEmpty)! {
                        self.tableView.isHidden = true
                    } else {
                        self.tableView.isHidden = false
//                        print(self.tableView(self.tableView, cellForRowAt: [0,0]))
//                        self.tableView.scrollToRow(at: [0,0], at: .top, animated: false)
                    }
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dateSelected <= 0 {
            today.tintColor = .red
            yesterday.tintColor = .lightGray
            tomorrow.tintColor = .black
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func todayAction(_ sender: Any) {
        dateSelected = 0
        viewDidLoad()
        viewWillAppear(false)
    }
    @IBAction func yesterdayAction(_ sender: Any) {
        dateSelected -= 1
        if dateSelected <= 0 {
            yesterday.tintColor = .lightGray
            yesterday.isEnabled = false
        }
        viewDidLoad()
    }
    @IBAction func tomorrowAction(_ sender: Any) {
        yesterday.tintColor = .orange
        yesterday.isEnabled = true
        dateSelected += 1
        viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let x = earsByDate?.events.count {
            return x
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "earsByDate")
        cell?.textLabel?.text = earsByDate?.events[indexPath.row].title.replacingOccurrences(of: "\\", with: "")
        cell?.textLabel?.numberOfLines = 0
        
        let array = earsByDate?.events[indexPath.row].period.components(separatedBy: " to ")
        if array![0] == "101" {
            cell?.detailTextLabel?.text = "Morning Roll-call"
        } else if array![0] == "102" {
            cell?.detailTextLabel?.text = "Afternoon Roll-call"
        } else if array![0] == "0" {
            cell?.detailTextLabel?.text = ""
        } else if array![0] != array![1] {
            cell?.detailTextLabel?.text = "Period \((earsByDate?.events[indexPath.row].period)!)"
        } else {
            cell?.detailTextLabel?.text = "Period \((earsByDate?.events[indexPath.row].period.components(separatedBy: " to ")[0])!)"
        }
        
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        cell?.selectionStyle = .default
        earsByDateSelected = indexPath.row
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
