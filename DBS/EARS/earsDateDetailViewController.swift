//
//  earsDateDetailViewController.swift
//  DBS
//
//  Created by Ben Lou on 21/3/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class earsDateDetailViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    let sliderView = UIView()
    let slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Event"
        
        var content = "\((earsByDate?.events[earsByDateSelected].title)!.replacingOccurrences(of: "\\", with: ""))\n"
        
        let array = earsByDate?.events[earsByDateSelected].period.components(separatedBy: " to ")
        if array![0] == "101" {
            content += "Morning Roll-call\n\n"
        } else if array![0] == "102" {
            content += "Afternoon Roll-call\n\n"
        } else if array![0] == "0" {
            content += "\n"
        } else if array![0] != array![1] {
            content += "Period \((earsByDate?.events[earsByDateSelected].period)!)\n\n"
        } else {
            content += "Period \((earsByDate?.events[earsByDateSelected].period.components(separatedBy: " to ")[0])!)\n\n"
        }
        
        content += """
        Location
        \((earsByDate?.events[earsByDateSelected].location)!)
        
        Application Date
        \((earsByDate?.events[earsByDateSelected].applyDate)!)
        
        Participants
        
        """
        for participant in (earsByDate?.events[earsByDateSelected].participant)! {
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
        
        attributedString.addAttributes(titleFontAttribute, range: (content as NSString).range(of: (earsByDate?.events[earsByDateSelected].title)!))
        print((earsByDate?.date)!)
        let wordsToBold = ["Location", "Application Date", "Participants"]
        for i in wordsToBold {
            attributedString.addAttributes(boldFontAttribute, range: (content as NSString).range(of: i))
        }
        textField.attributedText = attributedString
        textField.scrollsToTop = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.setContentOffset(CGPoint.zero, animated: true)
        
        // Slider Components
        
        let setFontSizeButton = UIBarButtonItem(title: "Aa", style: .plain, target: self, action: #selector(setFontSize))
        self.navigationItem.rightBarButtonItem = setFontSizeButton
        
        sliderView.backgroundColor = UIColor.lightGray
        sliderView.frame = CGRect(x: 8, y: self.view.frame.height, width: self.view.frame.width - 16, height: 50)
        sliderView.layer.cornerRadius = 20
        sliderView.layer.zPosition = 1000
        self.view.addSubview(sliderView)
        
        slider.frame = CGRect(x: self.view.frame.width*0.25, y: 20, width: self.view.frame.width/2, height: 20)
        slider.minimumValue = 8
        slider.maximumValue = 24
        
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            slider.value = Float(UserDefaults.standard.integer(forKey: "fontSize"))
        } else {
            slider.value = 16
        }
        sliderValueChanged(slider)
        
        slider.isContinuous = true
        slider.tintColor = UIColor.black
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        sliderView.addSubview(slider)
        
        //        let sliderTitle = UILabel()
        //        sliderTitle.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: 65)
        //        sliderTitle.text = "Adjust Font Size"
        //        sliderTitle.textAlignment = .center
        //        sliderTitle.font = UIFont(name: "Helvetica Bold", size: 30)
        //        sliderView.addSubview(sliderTitle)
        let smallA = UILabel(frame: CGRect(x: self.view.frame.width*0.15, y:0, width: self.view.frame.width/10, height: 50))
        smallA.text = "A"
        smallA.font = UIFont(name: "Helvetica Bold", size: 9)
        sliderView.addSubview(smallA)
        let bigA = UILabel(frame: CGRect(x: self.view.frame.width*0.85, y:0, width: self.view.frame.width/10, height: 50))
        bigA.text = "A"
        bigA.font = UIFont(name: "Helvetica Bold", size: 30)
        sliderView.addSubview(bigA)
    }
    
    func setFontSize(_ sender: UIBarButtonItem) {
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishedSetFontSize(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
        //        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sliderView.frame.origin.y = self.view.frame.height - (self.tabBarController == nil ? 15: (self.tabBarController?.tabBar.frame.height)!) - 50
        }, completion: nil)
    }
    func finishedSetFontSize(_ sender: UIBarButtonItem?) {
        let setFontSizeButton = UIBarButtonItem(title: "Aa", style: .plain, target: self, action: #selector(setFontSize))
        self.navigationItem.rightBarButtonItem = setFontSizeButton
        //        self.view.backgroundColor = UIColor.white
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sliderView.frame.origin.y = self.view.frame.height
        }, completion: nil)
    }
    func sliderValueChanged(_ sender: UISlider) {
        UserDefaults.standard.set(Int(sender.value), forKey: "fontSize")
        
        viewDidLoad()
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
