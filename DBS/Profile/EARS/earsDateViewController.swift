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

class earsDateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var today: UIBarButtonItem!
    @IBOutlet var yesterday: UIBarButtonItem!
    @IBOutlet var tomorrow: UIBarButtonItem!
    
    @IBOutlet var textViewView: UIView!
    @IBOutlet weak var earsDetails: UITextView!
    @IBOutlet weak var dismissButton: UIButton!
    let visualView = UIVisualEffectView()
    
    var ears : EARSByDate?
    var dateSelected = 0
    var earsSelected = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        textFieldView.frame = (UIApplication.shared.keyWindow?.frame)!
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
        
        URLSession.shared.dataTask(with: URL(string: "http://m-poll.dbs.edu.hk/poller/event.php?d=\(dateSelected)")!) { (data, response, error) in
            do {
                if data != nil {
                    self.ears = try JSONDecoder().decode(EARSByDate.self, from: data!)
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        self.title = "EARS (\((self.ears?.date)!))"
                        if (self.ears?.events.isEmpty)! {
                            self.tableView.isHidden = true
                        } else {
                            self.tableView.isHidden = false
                        }
                        self.tableView.reloadData()
                        spinner.stopAnimating()
                        
//                        self.updateText()
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
        
        textViewView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragToDismiss(_:)))
        textViewView.addGestureRecognizer(pan)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dateSelected <= 0 {
            today.tintColor = .red
            yesterday.tintColor = .white
            tomorrow.tintColor = .black
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dragToDismiss(_ recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .changed:
            if earsDetails.contentOffset == .zero {
                let translation = recognizer.translation(in: textViewView)
                recognizer.view?.center.y += translation.y
                visualView.alpha = 1 - (recognizer.view!.frame.origin.y - 60) / self.view.frame.height
                recognizer.setTranslation(.zero, in: self.view)
            }
            
        case .ended:
            if recognizer.view!.center.y > self.view.frame.height * 3/4 {
                UIView.animate(withDuration: 0.3, animations: {
                    recognizer.view?.frame.origin.y = self.view.frame.height * 1.3
                    self.visualView.alpha = 0
                }) { (success: Bool) in
                    self.dismissTextView(self)
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    recognizer.view?.center.y = self.view.center.y+60
                    self.visualView.alpha = 1
                }, completion: nil)
            }
            
        default: break
        }
        
    }
    
    func updateText() {
        //TEXT FIELD VIEW
        var content = "\((self.ears?.events[earsSelected].title)!.replacingOccurrences(of: "\\", with: ""))\n"
        
        let array = self.ears?.events[earsSelected].period.components(separatedBy: " to ")
        if array![0] == "101" {
            content += "Morning Roll-call\n\n"
        } else if array![0] == "102" {
            content += "Afternoon Roll-call\n\n"
        } else if array![0] == "0" {
            content += "\n"
        } else if array![0] != array![1] {
            content += "Period \((self.ears?.events[earsSelected].period)!)\n\n"
        } else {
            content += "Period \((array![0]))\n\n"
        }
        
        content += """
        Location
        \((self.ears?.events[earsSelected].location)!)
        
        Application Date
        \((self.ears?.events[earsSelected].applyDate)!)
        
        Participants
        
        """
        for participant in (self.ears?.events[earsSelected].participant)! {
            content += "\(participant.capitalized)\n"
        }
        
        var attributedString = NSMutableAttributedString(string: content as NSString as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0)])
        let titleFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30.0)]
        var boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0)]
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            attributedString = NSMutableAttributedString(string: content as NSString as String, attributes:
                [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")))])
            boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")+4))]
        }
        
        attributedString.addAttributes(titleFontAttribute, range: (content as NSString).range(of: (self.ears?.events[earsSelected].title)!.replacingOccurrences(of: "\\", with: "")))
        print((self.ears?.date)!)
        let wordsToBold = ["Location", "Application Date", "Participants"]
        for i in wordsToBold {
            attributedString.addAttributes(boldFontAttribute, range: (content as NSString).range(of: i))
        }
        self.earsDetails.attributedText = attributedString
        self.earsDetails.scrollsToTop = true
        self.earsDetails.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func todayAction(_ sender: Any) {
        dateSelected = 0
        tableView.setContentOffset(CGPoint.zero, animated: false)
        viewDidLoad()
        viewWillAppear(false)
    }
    @IBAction func yesterdayAction(_ sender: Any) {
        dateSelected -= 1
        if dateSelected <= 0 {
            yesterday.tintColor = .white
            yesterday.isEnabled = false
        }
        tableView.setContentOffset(CGPoint.zero, animated: false)
        viewDidLoad()
    }
    @IBAction func tomorrowAction(_ sender: Any) {
        yesterday.tintColor = .orange
        yesterday.isEnabled = true
        dateSelected += 1
        tableView.setContentOffset(CGPoint.zero, animated: false)
        viewDidLoad()
    }
    @IBAction func dismissTextView(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.textViewView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.textViewView.alpha = 0
            self.visualView.effect = nil
        }) { (success: Bool) in
            self.textViewView.removeFromSuperview()
//            self.textFieldView.frame = (UIApplication.shared.keyWindow?.frame)!
//            self.textFieldView.center.y = self.view.center.y+60
            self.visualView.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let x = self.ears?.events.count {
            return x
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "earsByDate")
        cell?.textLabel?.text = self.ears?.events[indexPath.row].title.replacingOccurrences(of: "\\", with: "")
        cell?.textLabel?.numberOfLines = 0
        
        let array = self.ears?.events[indexPath.row].period.components(separatedBy: " to ")
        if array![0] == "101" {
            cell?.detailTextLabel?.text = "Morning Roll-call"
        } else if array![0] == "102" {
            cell?.detailTextLabel?.text = "Afternoon Roll-call"
        } else if array![0] == "0" {
            cell?.detailTextLabel?.text = ""
        } else if array![0] != array![1] {
            cell?.detailTextLabel?.text = "Period \((self.ears?.events[indexPath.row].period)!)"
        } else {
            cell?.detailTextLabel?.text = "Period \((self.ears?.events[indexPath.row].period.components(separatedBy: " to ")[0])!)"
        }
        
        cell?.detailTextLabel?.textColor = .gray
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        cell?.selectionStyle = .default
        earsSelected = indexPath.row
        
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
            self.visualView.alpha = 1
            self.textViewView.alpha = 1
            self.textViewView.transform = .identity
        }, completion: { (success: Bool) in
            self.earsDetails.setContentOffset(CGPoint.zero, animated: false)
        })
        
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