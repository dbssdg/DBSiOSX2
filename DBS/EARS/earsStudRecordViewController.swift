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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var startsWithDBS = "dbs15072545"
        startsWithDBS.removeFirst(3)
        let startsWith20 = "20\(startsWithDBS)"
        
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
                        
                        if let data = self.earsStudRecord?.data {
                            var oleHours = 0.0
                            for i in data {
                                oleHours += Double(i.OLE_Hours)!
                            }
                            print("OLE Hours:", oleHours)
                        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.earsStudRecord != nil {
            return (self.earsStudRecord?.totalCount)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studEARS")!
        cell.textLabel?.text = self.earsStudRecord?.data[indexPath.row].EventName.replacingOccurrences(of: "\\", with: "")
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = self.earsStudRecord?.data[indexPath.row].EventDate
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.selectionStyle = .none
        cell.selectionStyle = .default
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
