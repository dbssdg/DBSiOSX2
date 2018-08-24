//
//  earsStudRecordViewController.swift
//  
//
//  Created by Ben Lou on 29/3/2018.
//

import UIKit

struct EARSStudRecordEvent : Decodable {
    let EventName : String
    let EventDate : String
    let SkippedLesson : Int
    let OLE_Hours : String
    let EventTeacher : String
}
struct EARSStudRecord : Decodable {
    var data : [EARSStudRecordEvent]
    let totalCount : Int
}

class earsStudRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var studRecordTable: UITableView!
    var earsStudRecord : EARSStudRecord?
    var recordSelected = Int()
    
    @IBOutlet var textViewView: UIView!
    @IBOutlet weak var earsDetails: UITextView!
    @IBOutlet weak var dismissButton: UIButton!
    let visualView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var startsWithDBS = loginID
        if loginID == "" {
            return
        }
        startsWithDBS.removeFirst(3)
        let startsWith20 = "20\(startsWithDBS)"
        
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
        
        URLSession.shared.dataTask(with: URL(string: "https://project.dbs.edu.hk/nis/serverside/LoadStudECA.php?all=1&req_stuid=\(startsWith20)")!) { (data, response, error) in
            do {
                if data != nil {
                    self.earsStudRecord = try JSONDecoder().decode(EARSStudRecord.self, from: data!)
                    DispatchQueue.main.async {
                        self.earsStudRecord?.data = (self.earsStudRecord?.data)!.reversed()
                        if (self.earsStudRecord?.data.isEmpty)! {
                            self.studRecordTable.isHidden = true
                        } else {
                            self.studRecordTable.isHidden = false
                        }
                        self.studRecordTable.reloadData()
                        spinner.stopAnimating()
                        
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
        
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateTitle), userInfo: nil, repeats: true)
        
        textViewView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragToDismiss(_:)))
        textViewView.addGestureRecognizer(pan)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateTitle() {
        if self.title == "My EARS Record" {
            
            if let data = self.earsStudRecord?.data {
                var oleHours = 0.0
                for i in data {
                    oleHours += Double(i.OLE_Hours)!
                }
                self.title = "My Total OLE Hours: \(oleHours)"
            }
            
        } else {
            self.title = "My EARS Record"
        }
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
        var content = String()
        let record = (self.earsStudRecord?.data[recordSelected])!
        content += "\(record.EventName.replacingOccurrences(of: "\\", with: "").capitalized)\n"
        content += "\(record.EventDate)\n\n"
        content += "\(record.OLE_Hours) OLE \(Double(record.OLE_Hours)! > 1 ? "Hours":"Hour")\n"
        content += "Skipped \(record.SkippedLesson) \(record.SkippedLesson > 1 ? "Lessons":"Lesson")\n\n"
        content += "Event Teacher\n\(record.EventTeacher)"
        
        var attributedString = NSMutableAttributedString(string: content as NSString as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0)])
        let titleFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30.0)]
        var boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0)]
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            attributedString = NSMutableAttributedString(string: content as NSString as String, attributes:
                [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")))])
            boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "fontSize")+4))]
        }
        
        attributedString.addAttributes(titleFontAttribute, range: (content as NSString).range(of: (self.earsStudRecord?.data[recordSelected].EventName)!.replacingOccurrences(of: "\\", with: "").capitalized))
        let wordsToBold = ["Event Teacher"]
        for i in wordsToBold {
            attributedString.addAttributes(boldFontAttribute, range: (content as NSString).range(of: i))
        }
        self.earsDetails.attributedText = attributedString
        self.earsDetails.scrollsToTop = true
        self.earsDetails.setContentOffset(CGPoint.zero, animated: false)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.earsStudRecord != nil {
            return (self.earsStudRecord?.totalCount)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studEARS")!
        cell.textLabel?.text = self.earsStudRecord?.data[indexPath.row].EventName.replacingOccurrences(of: "\\", with: "").capitalized
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = self.earsStudRecord?.data[indexPath.row].EventDate
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.textColor = .gray
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.selectionStyle = .none
        cell.selectionStyle = .default
        recordSelected = indexPath.row
        
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
        self.earsDetails.setContentOffset(CGPoint.zero, animated: false)
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
