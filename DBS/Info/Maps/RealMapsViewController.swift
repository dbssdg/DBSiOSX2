//
//  RealMapsViewController.swift
//  DBS
//
//  Created by SDG on 21/3/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class RealMapsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("realmaps")
        
        self.title = "Maps"
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        UISetup()
    }
    
    func GoToCampus(){
        performSegue(withIdentifier: "MapsToCampus", sender: self)
    }
    
    func UISetup(){
        let ToImage = UIBarButtonItem(title: "Campus Map", style: .plain, target: self, action: #selector(GoToCampus))
        
        self.navigationItem.rightBarButtonItems = [ToImage]
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
