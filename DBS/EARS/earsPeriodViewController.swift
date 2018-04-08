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
    
    @IBOutlet var textViewView: UIView!
    @IBOutlet weak var earsStudDetails: UITextView!
    @IBOutlet weak var dismissButton: UIButton!
    let visualView = UIVisualEffectView()
    
    var earsByPeriod = [Int : [EarsByPeriod]]()
    var earsSelected = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Today's EARS (\(earsChoice))"
        textViewView.layer.cornerRadius = 20
        textViewView.layer.borderWidth = 2
        textViewView.layer.borderColor = UIColor.lightGray.cgColor
        dismissButton.layer.cornerRadius = dismissButton.frame.height/2
        visualView.frame = (UIApplication.shared.keyWindow?.bounds)!
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        spinner.activityIndicatorViewStyle = .white
        spinner.backgroundColor = .gray
        spinner.layer.cornerRadius = 10
        spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        for i in 1...6 {
            URLSession.shared.dataTask(with: URL(string: "http://m-poll.dbs.edu.hk/poller/class.php?c=\(earsChoice)&p=\(i)")!) { (data, response, error) in
                
                do {
                    
                    if data != nil {
                        self.earsByPeriod[i-1] = try JSONDecoder().decode([EarsByPeriod].self, from: data!)
                        
                        DispatchQueue.main.async {
                            spinner.stopAnimating()
                            self.tableView.reloadData()
                        }
                    } else {
                        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
                        func backToChoosePage(action: UIAlertAction) { self.navigationController?.popViewController(animated: true) }
                        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: backToChoosePage))
                        self.present(networkAlert, animated: true)
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
    
    func updateText() {
        var content = ""
        content += "Student\n\(earsByPeriod[earsSelected.section]![earsSelected.row].stud.capitalized)\n\n"
        content += "Event\n\(earsByPeriod[earsSelected.section]![earsSelected.row].title)\n\n"
        
        let array = self.earsByPeriod[earsSelected.section]![earsSelected.row].period.components(separatedBy: " to ")
        if array[0] == "101" {
            content += "Morning Roll-call\n\n"
        } else if array[0] == "102" {
            content += "Afternoon Roll-call\n\n"
        } else if array[0] == "0" {
            content += "\n"
        } else if array[0] != array[1] {
            content += "Period \((self.earsByPeriod[earsSelected.section]![earsSelected.row].period))\n\n"
        } else {
            content += "Period \((array[0]))\n\n"
        }
        
        content += "Location\n\(earsByPeriod[earsSelected.section]![earsSelected.row].location)\n\n"
        content += "Event Date\n\(earsByPeriod[earsSelected.section]![earsSelected.row].eventDate)"
        
        var attributedString = NSMutableAttributedString(string: content as NSString as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0)])
        var boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0)]
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            attributedString = NSMutableAttributedString(string: content as NSString as String, attributes:
                [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")))])
            boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")+4))]
        }
        let wordsToBold = ["Student", "Event", "Location", "Event Date"]
        for i in wordsToBold {
            attributedString.addAttributes(boldFontAttribute, range: (content as NSString).range(of: i))
        }
        self.earsStudDetails.attributedText = attributedString
        self.earsStudDetails.scrollsToTop = true
        self.earsStudDetails.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func dismissTextView(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.textViewView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.textViewView.alpha = 0
            self.visualView.effect = nil
        }) { (success: Bool) in
            self.textViewView.removeFromSuperview()
            self.visualView.removeFromSuperview()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Period \(section+1)"
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["1", "2", "3", "4", "5", "6"]
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
            cell?.accessoryType = .none
            cell?.isUserInteractionEnabled = false
        } else {
            cell?.textLabel?.text = self.earsByPeriod[indexPath.section]![indexPath.row].stud.capitalized
            cell?.detailTextLabel?.text = self.earsByPeriod[indexPath.section]![indexPath.row].title
            cell?.accessoryType = .disclosureIndicator
            cell?.isUserInteractionEnabled = true
        }
        
        cell?.textLabel?.numberOfLines = 0
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.textColor = .gray
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        cell?.selectionStyle = .default
        earsSelected = indexPath
        
        updateText()
        textViewView.bounds.size.width = (UIApplication.shared.keyWindow?.bounds.width)!
        textViewView.bounds.size.height = (UIApplication.shared.keyWindow?.bounds.height)!
        textViewView.center.x = self.view.center.x
        textViewView.center.y = self.view.center.y+60
        textViewView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        textViewView.alpha = 0
        textViewView.layer.zPosition = 10000
        UIApplication.shared.keyWindow?.addSubview(visualView)
        UIApplication.shared.keyWindow?.addSubview(textViewView)
        UIView.animate(withDuration: 0.3, animations: {
            self.visualView.effect = UIBlurEffect(style: .light)
            self.textViewView.alpha = 1
            self.textViewView.transform = .identity
        }, completion: nil)
        self.earsStudDetails.setContentOffset(CGPoint.zero, animated: false)
        
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
