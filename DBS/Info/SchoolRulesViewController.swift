//
//  SchoolRulesViewController.swift
//  DBS
//
//  Created by SDG on 10/10/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import KCFloatingActionButton
class SchoolRulesViewController: UIViewController {

    let sliderView = UIView()
    let slider = UISlider()
    let dim = UIView()
    
    @IBOutlet weak var schoolRulesTextView: UITextView!
    @IBOutlet var schoolrulesstackview: [UIView]!{
        
        didSet {
            schoolrulesstackview.forEach {
                $0.isHidden = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        schoolRulesTextView.isEditable = false
        schoolRulesTextView.isUserInteractionEnabled = true
        schoolRulesTextView.frame = CGRect(x: 10, y: self.view.frame.width * 0.4, width: self.view.frame.width-20, height: self.view.frame.height * 0.8)
        schoolRulesTextView.textAlignment = .justified
        schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        
        self.title = nil
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.text = ""
        self.navigationItem.titleView = label
        
        // Slider Components
        
        let setFontSizeButton = UIBarButtonItem(title: "Aa", style: .plain, target: self, action: #selector(setFontSize))
        self.navigationItem.rightBarButtonItem = setFontSizeButton
        
        sliderView.backgroundColor = UIColor.lightGray
        sliderView.frame = CGRect(x: 8, y: self.view.frame.height, width: self.view.frame.width - 16, height: 50)
        sliderView.layer.cornerRadius = 20
        sliderView.layer.zPosition = 1000
        self.view.addSubview(sliderView)
        
        slider.frame = CGRect(x: self.view.frame.width*0.25, y: 20, width: self.view.frame.width/2, height: 20)
        slider.minimumValue = 9
        slider.maximumValue = 40
        
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            slider.value = Float(UserDefaults.standard.integer(forKey: "fontSize"))
        } else {
            slider.value = 14
        }
        sliderValueChanged(slider)
        
        slider.isContinuous = true
        slider.tintColor = UIColor.purple
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        sliderView.addSubview(slider)
        
//        let sliderTitle = UILabel()
//        sliderTitle.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: 65)
//        sliderTitle.text = "Adjust Font Size"
//        sliderTitle.textAlignment = .center
//        sliderTitle.font = UIFont(name: "Helvetica", size: 30)
//        sliderView.addSubview(sliderTitle)
        let smallA = UILabel(frame: CGRect(x: self.view.frame.width*0.15, y:0, width: self.view.frame.width/10, height: 50))
        smallA.text = "A"
        smallA.font = UIFont(name: "Helvetica", size: 9)
        sliderView.addSubview(smallA)
        let bigA = UILabel(frame: CGRect(x: self.view.frame.width*0.85, y:0, width: self.view.frame.width/10, height: 50))
        bigA.text = "A"
        bigA.font = UIFont(name: "Helvetica", size: 30)
        sliderView.addSubview(bigA)
        
        dim.frame = self.view.frame
        dim.backgroundColor = UIColor(red: 128, green: 128, blue: 128, alpha: 0.5)
        dim.layer.zPosition = 999
        dim.isHidden = true
        self.view.addSubview(dim)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFontSize(_ sender: UIBarButtonItem) {
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishedSetFontSize(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
//        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sliderView.frame.origin.y = self.view.frame.height - (self.tabBarController == nil ? 15: (self.tabBarController?.tabBar.frame.height)!) - 50
        }, completion: nil)
    }
    func finishedSetFontSize(_ sender: UIBarButtonItem) {
        let setFontSizeButton = UIBarButtonItem(title: "Aa", style: .plain, target: self, action: #selector(setFontSize))
        self.navigationItem.rightBarButtonItem = setFontSizeButton
//        self.view.backgroundColor = UIColor.white
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sliderView.frame.origin.y = self.view.frame.height
        }, completion: nil)
    }
    func sliderValueChanged(_ sender: UISlider) {
        UserDefaults.standard.set(Int(sender.value), forKey: "fontSize")
        
        schoolRulesTextView.font = UIFont(name: "Helvetica", size: CGFloat(Int(sender.value)))
        if (self.navigationItem.titleView as! UILabel).text == "Uniform" {
            uniformButton(sender)
        } else if (self.navigationItem.titleView as! UILabel).text == "Rules for Using Lockers" {
            lockerrulesButton(sender)
        } else {
            schoolRulesTextView.attributedText = attributedText("", [])
            schoolRulesTextView.text = """
            \"Love God, love your neighbour\" Diocesan Boys’ School expects students to show respect for all members of the school community at all times, and to value and respect the school buildings, grounds and property.
            """
        }
        
//        sliderTitle.text = "\(Int(sender.value))"
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            self.sliderTitle.text = "Adjust Font Size"
//        })
    }
    
    @IBAction func forbiddenButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "Forbidden"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.text = { """
        a. Fighting and/or Bullying.
        b. Willful damage to school property, e.g. trees, furniture, paint, newspaper, notices.
        (This is a serious offense. Accidental damage, if reported immediately, is not punished.)
        c. Shouting, playing games and rowdy behaviour in classrooms.
        d. Creating a disturbance when going from one room to another. (Boys should take a route passing the least number of classrooms.)
        e. Disrespectful behavior to janitors, watchmen and supporting staff.
        f. Taking into classroom or the Hall any radios, cameras, tape-recorders or electronic equipment without permission.
        g. Duplicating and / or possessing classroom or special room key.
        h. Running or loitering in the corridors, climbing trees, running up or down the banks.
        i. Drinking and eating in the Hall, in the Gymnasium, in the classrooms or in other study room.
        j. Playing ball games and keeping basketball, football or volleyball in the classroom. (Boys should leave them to the gymnasium keeper.)
        k. Staying in the tuck shop during school hours other than recess and lunch time.
        l. Using the chapel for any purpose other than private prayer or quiet meditation or without prior approval from the school.
        m. Scattering rubbish instead of putting it in the bins provided.
        n. Walking up and down the School Drive; boys must use the footpath provided.
        o. Throwing or slinging stones or other objects likely to cause injury.
        p. Putting up notices without proper authorization and/or writing on walls.
        q. Entering the Gymnasium and tennis courts when not wearing rubber shoes.
        r. Playing balls other than Ping-Pong balls in the Covered Playground.
        s. Playing card games without teacher supervision.
        t. Handling any tools or equipment belonging to the teaching or supporting staff without permission.
        u. The possession of a pager or a mobile phone without prior approval from the Headmaster.
        v. Using the lift in the SIP and Michiko Miyakawa Building.
        w. Breaking into the server of the School or to access files not opened to students.
        x. Using of foul language.
        y. Smoking, spitting, gambling, chewing gum.
        """ }()
        
    }
    @IBAction func outofboundsButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "Out of Bounds"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.text = { """
        a. The Teacher’s Common Room.
        b. The School Office and the Headmaster’s Office, except on business.
        c. All scaffolding / construction sites.
        d. The supporting staff quarters.
        e. The boarders’ quarters - to Day boys.
        f. All classrooms and corridors during Recess and Lunch time (unless with the Headmaster’s permission or on rainy days).
        g. The rock garden, except the path.
        h. The roundabout outside the main entrance, and the lawn outside the laboratories.
        i. The Visual Arts, Geography, Music rooms, except for regular lessons or with special permission.
        j. The Gymnasium, except for P.E. lessons. Special permission is required for the use of Gymnasium out of school business.
        k. The Hall, except for authorized activities.
        l. The passage on the north side of the Hall, except Prefects and boys on school business.
        m. The areas behind the outdoor swimming pool.
        n. All the slopes beyond the bamboo bush.
        o. The teachers’ quarters.
        p. The audio & visual room except the authorized persons listed on the board of the door.
        q. The BBQ pit.
        r. The roof of all buildings and structures.
        s. The Primary Section unless with the written permission from the school.
        t. The kitchen area and corridor outside kitchen area.
        """ }()
    }
    
    @IBAction func thehallButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "The Hall"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.text = { """
        An air of dignity should be maintained in the Hall at all times. No meetings / activities should be held without permission. There must also be no eating, drinking, or misbehaving inside the Hall.
        """ }()
    }
    
    
    @IBAction func physicaleducationButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "Physical Education"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.text = { """
        a. Boys can only be excused from P.E. if they bring a letter from parents, guardians or doctors requesting leave off. This letter must be initialed by the Headmaster and shown to the P.E. master.
        b. Boys thus excused must report to the P.E. master at the beginning of lessons, who will normally require them to stay in the open air and, if they are fit enough, to walk about.
        c. School PE shorts, House vest, rubber shoes and white ankle-length socks must be worn.
        """ }()
        
    }
    
    @IBAction func latenessButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "Lateness"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.text = {"""
        Form teacher / Subject teacher will take a.m. roll-call at 8:05 a.m. and p.m. roll-call at 1:55 p.m.
        a. The late-comer must report himself to the School Office to obtain a LATE SLIP, with the signature of one of the Dean / the Discipline Masters, before being admitted to class.
        b. The late-comer must show the signed slip to his Form Teacher to amend the register in the following roll-call.
        c. Notice of punishment for lateness will be issued by the Prefects on the following day.
        d. Any boy who is late must report to his Form Teacher. (A late-comer checklist will be provided by the General Office to the Form Teacher before the afternoon roll-call)
        """}()
    }
    
    @IBAction func absenceearlyleaveButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "Absence / Early leave from School"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.text = {"""
        a. Boys who want to obtain an early-leave from the School due to sickness must report to the Nursing Assistant. A sick-leave acknowledgement will be issued. With such acknowledgement, the boy can obtain the Early Leave slip from the General Office. Nursing Assistant may decline the request for early-leave of boys.
        b. Boys who want to obtain an early-leave from the School due to personal or family affairs are required to inform the Form Teacher / General Office with a letter from the parents. A leave-slip will be issued by the Dean. Those who do not have the letter from the parents are required to obtain written permission from the Headmaster.
        c. The watchman at the main entrance has the right to ask the early-leave boys to show the early Leave Slip issued by the General Office / jot down their names and student numbers in a log-book. Boys leaving the School without written permission from the School Authorities are considered to be playing truant.
        d. On returning to the School, after absence of any length of time, boys MUST bring a note from  parents or a doctor, giving the reason for the absence and the dates on which they have been away from School. This must be shown to the Form Teacher on the first day of returning to School so that the Form Teacher will amend the Register / report to the Headmaster.
        e. Any boy who is absent for more than two days should get his parents to notify the Headmaster.
        f. Swimming Gala, Sports’ Day and Speech Day are special function days. To support the School, boys are required to be present. Absentees that can produce letters from doctors may be exempted.
        """}()
    }
    
    
    @IBAction func prefectsButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "Prefects"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.text = {"""
        Prefects are leaders of students. They are acting under the Headmaster’s instructions and with his authority to keep the order in the School. Prefects have the authority to punish offenders by an initial imposition of not more than 100 lines. They are required to report more serious offences to the Headmaster. The Headmaster will not excuse any boy who disregards a proper order from a prefect or speaks insolently to him or in any way obstructs him in carrying out his duties. Appeals against punishment given by a prefect can be made through the discipline masters if valid reasons exist. However, no complaint will be entertained if the boy concerned has not treated the prefect with proper respect.
        """}()
    }
    
    @IBAction func usingmobilephoneButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "Rules of using Mobile Phone in School Campus"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.text = {"""
        \u{2022} Students should not display or use mobile phones during school hours (8:00a.m-3:45p.m).
        \u{2022} Students should TURN OFF their mobile phones during school hours to avoid disrupting lesson.
        \u{2022} Students should take proper care of their mobile phones. The school shall accept no responsibility for any loss or damage of a mobile phone.
        """}()
    }
    @IBAction func uniformButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "Uniform"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.attributedText = attributedText({"""
        Summer
        \u{2022} Grey trousers
        \u{2022} White shirt
        \u{2022} White, grey, black or dark blue socks (Ankles must be covered)
        \u{2022} Black or dark brown leather shoes
        \u{2022} Black or dark brown leather belt

        Winter
        \u{2022} Grey trousers
        \u{2022} White shirt
        \u{2022} School tie
        \u{2022} Dark blue blazer with school badge on the pocket
        \u{2022} White, grey, black or dark blue socks (Ankles must be covered)
        \u{2022} Black or dark brown leather shoes
        \u{2022} Black or dark brown leather belt

        Guidelines on Uniform
        Shirt: Plain white. Sports or coloured shirts are not allowed. Shirts are to be worn inside trousers.
        Pullover: Collarless; V-neck. Plain grey or dark blue. White pullovers are not allowed.
        Chinese Jacket or Gowns: Can be worn in cold weather. Dark blue colour. School metal badge on the left pocket.
        Shoes: Plain black or dark brown. Suede shows or shoes of two colors or very pointed shoes are not allowed.
        Gloves and Scarf: Dark color and not allowed indoor.
        Belt:    Plain, black or dark brown leather. Plain buckle.

        At all times a School metal badge, School tie or School blazer badge must be worn.
        Ornaments are not allowed except with the Headmaster’s approval.
        Boys must maintain a tidy and clean hair cut. Hairstyling materials that produce a wet look, colour, or odor are not permitted.
        Sportswear can only be worn for sports activities only. It shouldn't be worn in classroom or in any study room.

        Guidelines for School Uniform when there is cold Weather Warning
        1.  All students should strictly follow the school rules of "School Uniform" at all times.
        2.  When the Hong Kong Observatory issues the Cold Weather Warning, students are allowed to wear, in addition to school uniform, thick overcoats of plain dark blue, black or grey.
        3.  Sportswear can only be worn during P.E. lessons and sports activities. It should not be worn in the classroom or in any study room.
        """}(), ["Summer", "Winter", "Guidelines on Uniform", "Guidelines for School Uniform when there is cold Weather Warning"])
    }
    @IBAction func lockerrulesButton(_ sender: Any) {
        hideButtons()
        (self.navigationItem.titleView as! UILabel).text = "Rules for Using Lockers"
    schoolRulesTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        schoolRulesTextView.attributedText = attributedText({"""
        1. Eligible Users:
        Each student is eligible to apply for one individual locker.

        2. Use of Lockers:
        \u{2022} Lockers are not installed with any locks. Users should bring along their own padlocks to safeguard their belongings deposited in the lockers. (Number lock is not recommended).
        \u{2022} Students must take full responsibility for the items stored in the lockers.
        \u{2022} Students are advised not to store any money or valuables in their lockers.
        \u{2022} Storage of any items that are of illegal nature, or would cause or be likely to cause a health hazard, security risk, physical danger or a nuisance to the environment or other members of the school is prohibited.
        \u{2022} In case of any loss or damage, students must report to their Form Teacher or any one of the Discipline Teachers immediately. Students are responsible to pay for the repair if the damages are caused by themselves.

        3. Unauthorized Use of Lockers:
        Unauthorized use of unoccupied or other people’s lockers is strictly forbidden. School Discipline Committee shall have the authority to open such lockers and dispose of all property found therein.
        
        4. Transfer of Lockers:
        Lockers are not transferable. Students who wish to change the location of their lockers must apply with good reason in person to Coordinators of Discipline Committee.

        5. Withdrawal of Studies:
        Students who withdraw from studies or whose studies are terminated must clear their lockers within 3 days of withdrawal/termination. After 3 days, the Discipline Committee shall have the authority to open such lockers and dispose of all property found therein.

        6. Clearance and Return of Lockers:
        At the end of the academic year students must clear their lockers and remove their padlocks. The school will announce an exact deadline. After this date, the school shall have the authority to open such lockers and dispose of all property found therein.

        7. Violation of the locker regulations:
        Any violation of the locker regulations by the users may result in termination of the use of lockers and be reported to the Discipline Committee.

        8. The School shall not be liable in any circumstance for any loss or damage of property stored in any locker.
        The School shall in no circumstances be responsible for the safe keeping of any items found in the lockers and any loss or damage in connection therewith.
        
        Users of the locker system must accept and are bound by the above rules.
        """}(), ["1. Eligible Users:", "2. Use of Lockers:", "3. Unauthorized Use of Lockers:", "4. Transfer of Lockers:", "5. Withdrawal of Studies:", "6. Clearance and Return of Lockers:", "7. Violation of the locker regulations:", "8. The School shall not be liable in any circumstance for any loss or damage of property stored in any locker."])
    }
    
    func attributedText(_ str: String, _ titles: [String]) -> NSAttributedString {
        let string = str as NSString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(slider.value)), NSParagraphStyleAttributeName: paragraphStyle])
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(slider.value+4)), NSParagraphStyleAttributeName: paragraphStyle]
        for i in titles {
            attributedString.addAttributes(boldFontAttribute, range: string.range(of: i))
        }
        return attributedString
    }
    
    @IBAction func schoolrulessettingsbuttonpressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3){
            self.schoolrulesstackview.forEach {
                $0.isHidden = !$0.isHidden
            }
        }
    }
    func hideButtons() {
        UIView.animate(withDuration: 0.3) {
            self.schoolrulesstackview.forEach {
                if !$0.isHidden {
                    $0.isHidden = !$0.isHidden
                }
            }
        }
    }
    

}
