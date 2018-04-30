//
//  dropDownView.swift
//  DBS
//
//  Created by Kevin Lau on 25/4/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        updateSchoolRules(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.backgroundColor = UIColor.clear
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.contentView.backgroundColor = UIColor.lightText
        cell.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.layer.shadowOpacity = 0.2
        cell.contentView.sendSubview(toBack: cell)
        return cell
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //
        //        cell.contentView.backgroundColor = UIColor.clear
        //
        //        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.frame.size.width - 20, height: 120))
        //
        //        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        //        whiteRoundedView.layer.masksToBounds = false
        //        whiteRoundedView.layer.cornerRadius = 2.0
        //        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        //        whiteRoundedView.layer.shadowOpacity = 0.2
        //
        //        cell.contentView.addSubview(whiteRoundedView)
        //        cell.contentView.sendSubview(toBack: whiteRoundedView)
        //
        //        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        updateSchoolRules(indexPath.row)
        
        
    }
    
    func updateSchoolRules(_ n: Int) {
        switch n {
            
        case 0:
            textView.attributedText = NSAttributedString(string: """
        \"Love God, love your neighbour\" Diocesan Boys’ School expects students to show respect for all members of the school community at all times, and to value and respect the school buildings, grounds and property.

""")
            
        case 1:
            textView.attributedText = NSAttributedString(string: """
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
""")
            
        case 2:
            textView.attributedText = NSAttributedString(string: """
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
""")
            
        case 3:
            textView.attributedText = NSAttributedString(string: """
        a. Boys can only be excused from P.E. if they bring a letter from parents, guardians or doctors requesting leave off. This letter must be initialed by the Headmaster and shown to the P.E. master.
        b. Boys thus excused must report to the P.E. master at the beginning of lessons, who will normally require them to stay in the open air and, if they are fit enough, to walk about.
        c. School PE shorts, House vest, rubber shoes and white ankle-length socks must be worn.

""")
            
        case 4:
            textView.attributedText = NSAttributedString(string: """
            Form teacher / Subject teacher will take a.m. roll-call at 8:05 a.m. and p.m. roll-call at 1:55 p.m.
            a. The late-comer must report himself to the School Office to obtain a LATE SLIP, with the signature of one of the Dean / the Discipline Masters, before being admitted to class.
            b. The late-comer must show the signed slip to his Form Teacher to amend the register in the following roll-call.
            c. Notice of punishment for lateness will be issued by the Prefects on the following day.
            d. Any boy who is late must report to his Form Teacher. (A late-comer checklist will be provided by the General Office to the Form Teacher before the afternoon roll-call)
""")
            
        case 5:
            textView.attributedText = NSAttributedString(string: """
            a. Boys who want to obtain an early-leave from the School due to sickness must report to the Nursing Assistant. A sick-leave acknowledgement will be issued. With such acknowledgement, the boy can obtain the Early Leave slip from the General Office. Nursing Assistant may decline the request for early-leave of boys.
            b. Boys who want to obtain an early-leave from the School due to personal or family affairs are required to inform the Form Teacher / General Office with a letter from the parents. A leave-slip will be issued by the Dean. Those who do not have the letter from the parents are required to obtain written permission from the Headmaster.
            c. The watchman at the main entrance has the right to ask the early-leave boys to show the early Leave Slip issued by the General Office / jot down their names and student numbers in a log-book. Boys leaving the School without written permission from the School Authorities are considered to be playing truant.
            d. On returning to the School, after absence of any length of time, boys MUST bring a note from  parents or a doctor, giving the reason for the absence and the dates on which they have been away from School. This must be shown to the Form Teacher on the first day of returning to School so that the Form Teacher will amend the Register / report to the Headmaster.
            e. Any boy who is absent for more than two days should get his parents to notify the Headmaster.
            f. Swimming Gala, Sports’ Day and Speech Day are special function days. To support the School, boys are required to be present. Absentees that can produce letters from doctors may be exempted.
""")
            
            
        case 6:
            textView.attributedText = NSAttributedString(string: """
            Prefects are leaders of students. They are acting under the Headmaster’s instructions and with his authority to keep the order in the School. Prefects have the authority to punish offenders by an initial imposition of not more than 100 lines. They are required to report more serious offences to the Headmaster. The Headmaster will not excuse any boy who disregards a proper order from a prefect or speaks insolently to him or in any way obstructs him in carrying out his duties. Appeals against punishment given by a prefect can be made through the discipline masters if valid reasons exist. However, no complaint will be entertained if the boy concerned has not treated the prefect with proper respect.
""")
            
        case 7:
            textView.attributedText = NSAttributedString(string: """
        \u{2022} Students should not display or use mobile phones during school hours (8:00a.m-3:45p.m).
        \u{2022} Students should TURN OFF their mobile phones during school hours to avoid disrupting lesson.
        \u{2022} Students should take proper care of their mobile phones. The school shall accept no responsibility for any loss or damage of a mobile phone.
""")
            
        case 8:
            textView.attributedText = NSAttributedString(string: """
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

""")
            
        case 9:
            textView.attributedText = NSAttributedString(string: """
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
""")
            
        default: break
        }
    }
    
    
    
    
}

