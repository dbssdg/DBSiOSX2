//
//  timetableNoticeViewController.swift
//  DBS
//
//  Created by Ben Lou on 28/2/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class timetableNoticeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.text = "Loading..."
        textView.isSelectable = false
        textView.textAlignment = .justified
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        URLSession.shared.dataTask(with: URL(string: "http://www.dbs.edu.hk/index.php?section=calendar&listall=1")!) { (data, response, error) in
//        if let url = URL(string: "http://www.dbs.edu.hk/index.php?section=calendar&listall=1") {
            do {
                var html : String?
                if let data = data {
                    html = String(data: data, encoding: .utf8)
                }
                DispatchQueue.main.async {
                    
                    self.textView.text = ""
                    self.textView.isSelectable = true
                    
                    for i in (html?.split(separator: ">"))! {
                        if i.components(separatedBy: " adopts ").count  == 2 {
                            if self.textView.text == "" {
                                self.textView.text = "\(i.split(separator: "<")[0].replacingOccurrences(of: "\n", with: ""))"
                            } else {
                                self.textView.text = "\(self.textView.text!)\n\n\(i.split(separator: "<")[0].replacingOccurrences(of: "\n", with: ""))"
                            }
                            print(self.textView.text)
                        }
                    }
                }
            }
        }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
