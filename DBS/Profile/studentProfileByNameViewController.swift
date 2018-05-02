//
//  studentProfileByNameViewController.swift
//  DBS
//
//  Created by Ben Lou on 2/5/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

struct StudentByNameResults : Decodable {
    let totalResultsCount: Int
    let studnames : [[String: String]]
}

class studentProfileByNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var result : StudentByNameResults?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = result {
            if result.totalResultsCount == 0 {
                return 1
            }
            return result.totalResultsCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsByNameCell") as! UITableViewCell
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = "Loading..."
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        if result?.totalResultsCount == 0 {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = "No results"
        } else if let studentInfo = result?.studnames[indexPath.row] {
            cell.textLabel?.text = studentInfo["classtag"]!
            cell.detailTextLabel?.text = studentInfo["nameeng"]!.capitalized
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.selectionStyle = .none
        cell.selectionStyle = .default
        searchController.isActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchTextRefined = searchText.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "http://ears.dbs.edu.hk/json/stud_search.php?name_startsWith=\(searchTextRefined)&maxRows=1000") else {return}
        if searchTextRefined == "" {
            result = nil
            tableView.reloadData()
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if var data = data {
                var dataString = String(data: data, encoding: .utf8)
                if dataString != "" {
                    dataString?.removeFirst()
                    dataString?.removeLast(2)
                }
                data = dataString!.data(using: .utf8)!
                do {
                    self.result = try JSONDecoder().decode(StudentByNameResults.self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: [0,0], at: .top, animated: true)
                    }
                } catch {
                    print(error)
                }
            } else {
                
            }
        }.resume()
        
        
        
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
