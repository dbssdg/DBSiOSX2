//
//  badgeViewController.swift
//  DBS
//
//  Created by SDG on 20/11/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

class badgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var badgeTable: UITableView!
    
    let elementImages = ["bible", "crown", "crozier", "key", "mitre", "shell", "shield"]
    let elementTitles = ["Bible", "Crown", "Crozier", "Key", "Mitre", "Shell", "Shield"]
    let elementDescriptions = ["The book placed in the middle of the shield is the Bible, which is a record of the self-disclosure of God in history - the history of the people of Israel in the Old Testament period and the life of Jesus Christ. The doctrine, discipline and worship of the Anglican Church is based on the Bible and must be in accordance with its teaching.", "Placed above the Bible, the crown is the symbol of the kingship of Christ. It indicates that the Church works in the world in obedience to Christ and to the glory of God.", "The symbol of the pastoral responsibility which the Church bears for the world. It is also known as the pastoral staff. It reminds the Church of its humble identity as servant.", "The symbol of authority which the Church receives from Christ.\n\n\n", "The mitre is the traditional headgear worn by bishops. As a symbol, its meaning is twofold. It shows that the Anglican Church is an episcopal church, a church guided by bishops. It also underlines the fact that the Anglican Church has inherited the faith of the Apostles.", "Placed beneath the Bible, the shell is used to symbolise Baptism. It underlines the evangelistic mission of the Church which is to preach the Gospel, to draw people to Christ and to baptise them.", "The shape of a shield signifies the defending of Christian faith in the temporal world.\n\n\n"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            
            badgeTable.separatorStyle = .none
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementTitles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "badgeCell", for: indexPath) as! badgeTableViewCell
        cell.elementImage.image = UIImage(named: elementImages[indexPath.row])
        cell.elementTitle.text = elementTitles[indexPath.row]
        cell.elementDescription.text = elementDescriptions[indexPath.row]
        cell.selectionStyle = .none
        return cell
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
