//
//  ProfileViewController.swift
//  DBS
//
//  Created by SDG on 16/10/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import SystemConfiguration
import CryptoSwift
import MessageUI
import CoreNFC

var loginID = ""
var loginTextFieldSave = ["", ""]

//@available(iOS 11.0, *)
class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate {
    
    // Reference the NFC session
    //    private var nfcSession: NFCNDEFReaderSession!
    
    // Reference the found NFC messages
    //    private var nfcMessages: [[NFCNDEFMessage]] = []
    
    
    
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var userInfo: UITableView!
    let spinner = UIActivityIndicatorView()
    
    let houses = ["Arthur", "Featherstone", "Goodban", "Piercy", "Sargent", "Sykes", "Lowcock", "George She"]
    let houseColours = [[55, 125, 34], [0, 6, 133], [152, 52, 48], [255, 254, 84], [235, 51, 35], [150, 205, 232], [243, 168, 59], [117, 25, 124]]
    
    var userInformation = [String: String?]()
    var profileData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createScrollOptions()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        if let x = UserDefaults.standard.string(forKey: "loginID") {
            loginID = x
        }
        userInfo.separatorStyle = .none
        if UIScreen.main.bounds.height < 667 && UIScreen.main.bounds.width < 375 {
            print(UIScreen.main.bounds.height)
            studentImage.heightAnchor.constraint(equalToConstant: 160).isActive = false
            studentImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        }
        
        if loginID != "" {
            let startsWithdbs = loginID
            loginID.removeFirst(3)
            let startsWith20 = "20\(loginID)"
//            studentImage.layer.cornerRadius = studentImage.frame.height/2
            studentImage.sizeToFit()
            
            userInfo.dataSource = self
            userInfo.delegate = self
            profileData.removeAll()
            
            
            var TOS = "s"
            if ("\(loginID.first!)" >= "0" && "\(loginID.first!)" <= "9") || UserInformation.count == 5 {
                TOS = "s"
            }else{
                TOS = ""
            }
            
            let jsonURL = "http://eclass.dbs.edu.hk/help/dbsfai/eauth-json\(TOS).php?uid=\(startsWithdbs)"
            print(jsonURL)
            let url = URL(string: jsonURL)
            
            
            if isInternetAvailable() {
                
                if self.teacherOrStudent() == "s" {
                    self.studentImage.image = UIImage(named: "StudentBig")
                } else if self.teacherOrStudent() == "t" {
                    self.studentImage.image = UIImage(named: "TeacherBig")
                }
                
                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    do {
                        
                        self.userInformation = try JSONDecoder().decode([String: String?].self, from: data!)
                        
                        var classNumber = (self.userInformation["NameEng"]!)!
                        classNumber.removeFirst()
                        while classNumber.count > 7 {
                            classNumber.removeLast()
                        }
                        if "\(classNumber.last!)" == ")" { classNumber.removeLast() }
                        
                        if self.teacherOrStudent() == "t" {
                            self.profileData += [loginID.uppercased()]
                            self.userInformation["NameEng"]!!.removeLast(5)
                        } else if self.teacherOrStudent() == "s" {
                            self.profileData += [startsWith20]
                            self.userInformation["NameEng"]!!.removeFirst(9)
                        }
                        
                        self.profileData += [(self.userInformation["NameEng"]!)!, (self.userInformation["NameChi"]!)!]
                        
                        if self.teacherOrStudent() == "s" {
                            self.profileData += [classNumber]
                            self.profileData += [self.houses[Int("\(loginID.last!)")!-1].uppercased()]
                        }
                        
                        DispatchQueue.main.async {
                            self.getImage("http://ears.dbs.edu.hk/studpics.php?sid=\(startsWith20)", self.studentImage)
                            self.userInfo.reloadData()
//                            self.createScrollOptions()
                            UserDefaults.standard.set(self.profileData, forKey: "profileData")
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            if self.teacherOrStudent() == "t" && self.profileData.count <= 3 {
                                self.studentImage.image = UIImage(named: "TeacherBig")
                            } else {
                                self.studentImage.image = UIImage(named: "StudentBig")
                            }
                        }
                        
                        if let x = UserDefaults.standard.array(forKey: "profileData") {
                            self.profileData = x as! [String]
                            self.userInfo.reloadData()
                        }
                    }
                    }.resume()
                
            } else {
                if let x = UserDefaults.standard.array(forKey: "profileData") {
                    profileData = x as! [String]
                    userInfo.reloadData()
                }
                if self.teacherOrStudent() == "t" && self.profileData.count <= 3 {
                    self.studentImage.image = UIImage(named: "TeacherBig")
                } else {
                    self.studentImage.image = UIImage(named: "StudentBig")
                }
            }
            
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        //        self.initializeNFCSession()
        
        UserInformation.removeAll()
        spinner.stopAnimating()
        
        if loginID == "" {
            let loginAlert = UIAlertController(title: "Login", message: "Your eClass Account", preferredStyle: .alert)
            loginAlert.addTextField { (textField) in
                textField.placeholder = "eClass Login (starts with dbs)"
                textField.text = loginTextFieldSave[0]
                textField.autocapitalizationType = .none
                textField.returnKeyType = .next
            }
            loginAlert.addTextField { (textField) in
                textField.placeholder = "Password"
                textField.text = loginTextFieldSave[1]
                textField.isSecureTextEntry = true
                textField.returnKeyType = .default
            }
            
            func TAndC(action: UIAlertAction) {
                loginTextFieldSave = [loginAlert.textFields![0].text!, loginAlert.textFields![1].text!]
                performSegue(withIdentifier: "TAndC", sender: self)
            }
            loginAlert.addAction(UIAlertAction(title: "Terms and Conditions", style: .default, handler: TAndC))
            
            
            func reload(action: UIAlertAction) { loginID = ""; viewDidAppear(true) }
            let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
            networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: reload))
            let wrongPassword = UIAlertController(title: "ERROR", message: "Incorrect username or password. Please try again.", preferredStyle: .alert)
            wrongPassword.addAction(UIAlertAction(title: "OK", style: .default, handler: reload))
            let noPassword = UIAlertController(title: "ERROR", message: "Please fill in your username and password. Thank you.", preferredStyle: .alert)
            noPassword.addAction(UIAlertAction(title: "OK", style: .default, handler: reload))
            
            func checkPassword(action: UIAlertAction) {
                if (loginAlert.textFields![0].text!) == "" || (loginAlert.textFields![1].text!) == "" {
                    print("Please fill in your username or password.")
                    present(noPassword, animated: true)
                } else if !isInternetAvailable() {
                    present(networkAlert, animated: true)
                } else if loginAlert.textFields![0].text!.count <= 4 || !(loginAlert.textFields![0].text?.hasPrefix("dbs"))! {
                    print("Username Failure")
                    present(wrongPassword, animated: true)
                } else {
                    
                    loginID = (loginAlert.textFields![0].text!)
                    let startsWithdbs = loginID
                    loginID.removeFirst(3)
                    
                    networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    var TOS = "s"
                    if ("\(loginID.first!)" >= "0" && "\(loginID.first!)" <= "9") || UserInformation.count == 5 {
                        TOS = "s"
                    }else{
                        TOS = ""
                    }
                    
                    let jsonURL = "http://eclass.dbs.edu.hk/help/dbsfai/eauth-json\(TOS).php?uid=\(startsWithdbs)"
                    
                    
                    let url = URL(string: jsonURL)
                    
                    spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                    spinner.activityIndicatorViewStyle = .white
                    spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
                    spinner.backgroundColor = UIColor.gray
                    spinner.layer.cornerRadius = 10
                    spinner.startAnimating()
                    spinner.hidesWhenStopped = true
                    spinner.layer.zPosition = 100000
                    self.view.addSubview(spinner)
                    
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        do {
                            let userInfo = try JSONDecoder().decode([String: String?].self, from: data!)
                            print(userInfo["cash"]!!)
                            print(userInfo["hash"]!!)
                            
                            DispatchQueue.main.async {
                                print(userInfo["hash"]!!)
                                self.spinner.stopAnimating()
                                UserInformation.removeAll()
                                let first = "\(loginAlert.textFields![0].text!)"
                                let second = "\(loginAlert.textFields![1].text!)"
                                if "\(first+second)1ekfx1".md5() == userInfo["hash"]!! || "\(first)|dbsfai2012|\(second.md5())".md5() == userInfo["cash"]!! /*|| second == "iLoveSDG!" || second == " "*/ {
                                    loginID = first
                                    UserDefaults.standard.set(loginID, forKey: "loginID")
                                    self.viewDidLoad()
                                    print("SUCCESS")
                                } else {
                                    loginID = ""
                                    self.present(wrongPassword, animated: true)
                                    print("Password Failure")
                                }
                            }
                            
                        } catch {
                            self.present(wrongPassword, animated: true)
                            print("ERROR")
                        }
                        }.resume()
                }
            }
            loginAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: checkPassword))
            
            func changeTabBar(action: UIAlertAction) {
                loginTextFieldSave = [loginAlert.textFields![0].text!, loginAlert.textFields![1].text!]
                self.tabBarController?.selectedIndex = tabBarPage
            }
            loginAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: changeTabBar))
            
            present(loginAlert, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func options(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        func reportBug(action: UIAlertAction) {
            let mailAlert = UIAlertController(title: "ERROR", message: nil, preferredStyle : .alert)
            mailAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            
            
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                
                mailAlert.message = "Mail services are not available."
                present(mailAlert, animated: true)
                
            }else{
                let toRecipients = ["dbssdg@gmail.com"]
                //                let toRecipients2 = ["kevinlauofficial01@gmail.com"]
                let subject = "Report A Bug"
                let mc = MFMailComposeViewController()
                var reportMessage = ""
                if let user = UserDefaults.standard.array(forKey: "profileData") {
                    reportMessage += "By \(user[1])"
                    if user.count > 3 {
                        reportMessage += " \(user[3])"
                    }
                }
                
                mc.mailComposeDelegate = self
                mc.setToRecipients(toRecipients)
                //                mc.setCcRecipients(toRecipients2)
                mc.setMessageBody(reportMessage, isHTML: false)
                mc.setSubject(subject)
                
                self.present(mc, animated: true, completion: nil)
            }
            
        }
        
        
        
        func downloadStudentImage(action: UIAlertAction) {
            let imageData = UIImagePNGRepresentation(studentImage.image!)
            let compressedImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            
            //            let savedAlert = UIAlertController(title: "Saved", message: "Your student image has been saved to Photos.", preferredStyle: .alert)
            //            savedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //            self.present(savedAlert, animated: true)
        }
        
        func disciplineLink(action: UIAlertAction) {
            if let url = NSURL(string: "http://cl.dbs.edu.hk/private/disciplineClass") {
                UIApplication.shared.open(url as URL)
            }
        }
        
        func signOut(action: UIAlertAction) {
            loginID = ""
            loginTextFieldSave = ["", ""]
            UserDefaults.standard.set("", forKey: "loginID")
            UserDefaults.standard.set(nil, forKey: "profileData")
            profileData.removeAll()
            userInfo.reloadData()
            studentImage.image = nil
            viewDidAppear(true)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Report A Bug", style: .default, handler: reportBug))
        if isInternetAvailable() && studentImage?.image != UIImage(named: "StudentBig") && teacherOrStudent() == "s" {
            actionSheet.addAction(UIAlertAction(title: "Download Student Image", style: .default, handler: downloadStudentImage))
        } else if isInternetAvailable() && teacherOrStudent() == "t" {
            actionSheet.addAction(UIAlertAction(title: "Discipline", style: .default, handler: disciplineLink))
        }
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: signOut))
        if let popoverController = actionSheet.popoverPresentationController {
            if #available(iOS 12.0, *) {
                popoverController.sourceRect = (sender as AnyObject).frame
            } else {
                // Fallback on earlier versions
            }
        }
        present(actionSheet, animated: true)
    }
    
    func createScrollOptions() {
        for subview in self.view.subviews {
            if subview.tag == 700 || subview.tag == 701 {
                subview.removeFromSuperview()
                
            } else {
                
                let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
                blurView.frame = self.view.frame
                blurView.alpha = 0
                blurView.tag = 700
                blurView.layer.zPosition = 10000
                self.view.addSubview(blurView)
                
                let scrollForOptions = UIScrollView(frame: self.view.frame)
                scrollForOptions.isUserInteractionEnabled = true
                scrollForOptions.contentSize = CGSize(width: self.view.frame.width*2, height: self.view.frame.height)
                scrollForOptions.delegate = self
                scrollForOptions.isPagingEnabled = true
                scrollForOptions.showsHorizontalScrollIndicator = false
                scrollForOptions.tag = 701
                scrollForOptions.layer.zPosition = 10001
                self.view.addSubview(scrollForOptions)
                
                struct ButtonInfo {
                    let title : String
                    let image : UIImage
                    let row : Int
                    let column : Int
                    //                    let target : Selector
                }
                print(profileData)
                var buttonInfos = [ButtonInfo]()
                if self.tableView(userInfo, numberOfRowsInSection: 0) == 5 {
                    buttonInfos = [
                        ButtonInfo(title: "Report a Bug", image: #imageLiteral(resourceName: "bug"), row: 0, column: 0),
                        ButtonInfo(title: "Download Student Image", image: #imageLiteral(resourceName: "downloadStudentImage"), row: 0, column: 1),
                        ButtonInfo(title: "OLE Record", image: #imageLiteral(resourceName: "oleRecord"), row: 1, column: 0),
                        ButtonInfo(title: "Teachers' Comments", image: #imageLiteral(resourceName: "teachersComments"), row: 1, column: 1),
                        ButtonInfo(title: "Competition Record", image: #imageLiteral(resourceName: "competitionRecord"), row: 2, column: 0),
                        ButtonInfo(title: "Scholarship Record", image: #imageLiteral(resourceName: "scholarshipRecord"), row: 2, column: 1),
                        ButtonInfo(title: "Adjust Font Size", image: #imageLiteral(resourceName: "fontSize"), row: 3, column: 0),
                        ButtonInfo(title: "Sign out", image: #imageLiteral(resourceName: "signOut"), row: 3, column: 1)
                    ]
                } else if self.tableView(userInfo, numberOfRowsInSection: 0) == 3 {
                    buttonInfos = [
                        ButtonInfo(title: "Report a Bug", image: #imageLiteral(resourceName: "bug"), row: 0, column: 0),
                        ButtonInfo(title: "EARS by Date", image: #imageLiteral(resourceName: "earsByDate"), row: 1, column: 0),
                        ButtonInfo(title: "EARS by Class", image: #imageLiteral(resourceName: "earsByClass"), row: 1, column: 1),
                        ButtonInfo(title: "Student Profile by Name", image: #imageLiteral(resourceName: "profileByName"), row: 2, column: 0),
                        ButtonInfo(title: "Student Profile by Student ID", image: #imageLiteral(resourceName: "profileByID"), row: 2, column: 1),
                        ButtonInfo(title: "Adjust Font Size", image: #imageLiteral(resourceName: "fontSize"), row: 3, column: 0),
                        ButtonInfo(title: "Sign out", image: #imageLiteral(resourceName: "signOut"), row: 3, column: 1)
                    ]
                }
                
                for buttonInfo in buttonInfos {
                    let button = UIButton()
                    button.frame.size.height = (self.view.frame.height - 96 - tabBarController!.tabBar.frame.height) / 4 - 16
                    button.frame.size.width = button.frame.height
                    button.frame.origin.x = self.view.frame.width * (CGFloat(buttonInfo.column) / 2 + 1.25) - button.frame.width/2
                    button.frame.origin.y = 96 + (button.frame.height+8) * CGFloat(buttonInfo.row)
                    button.backgroundColor = .white
                    button.layer.borderWidth = 1
                    button.layer.borderColor = UIColor.lightGray.cgColor
                    button.layer.cornerRadius = 15
                    
                    let imageView = UIImageView()
                    imageView.frame.origin.x = 0
                    imageView.frame.origin.y = 0
                    imageView.frame.size.height = button.bounds.height*0.7
                    imageView.frame.size.width = button.bounds.width
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = buttonInfo.image
                    button.addSubview(imageView)
                    
                    let title = UILabel()
                    title.frame.origin.x = 0
                    title.frame.origin.y = button.bounds.height*0.7
                    title.frame.size.height = button.bounds.height*0.3
                    title.frame.size.width = button.frame.width
                    title.numberOfLines = 2
                    title.adjustsFontSizeToFitWidth = true
                    title.textColor = .black
                    title.text = buttonInfo.title
                    title.textAlignment = .center
                    button.addSubview(title)
                    
                    scrollForOptions.addSubview(button)
                }
                
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 701 {
            self.view.viewWithTag(700)?.alpha = scrollView.contentOffset.x / self.view.frame.width
            scrollView.alpha = scrollView.contentOffset.x / self.view.frame.width
            print("SCROLLING")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loginID != "" {
            if teacherOrStudent() == "t"{
                return 3
            } else {
                return 5
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! descriptionsTableViewCell
        if false {
            var arr = profileData
            arr.remove(at: 2)
            cell.descriptionText.text = "\(arr[indexPath.row].capitalized)"
        } else {
            cell.descriptionText.text = ""
            if !profileData.isEmpty {
                print(profileData)
                if indexPath.row != 2 {
                    cell.descriptionText.text = "\(self.profileData[indexPath.row].capitalized)"
                } else {
                    cell.descriptionText.text = "\(self.profileData[indexPath.row])"
                }
            }
        }
        if indexPath.row == 0 {
            cell.descriptionText.text = cell.descriptionText.text.uppercased()
        }
        cell.descriptionText.textAlignment = .center
        cell.selectionStyle = .none
        return cell
    }
    
    func teacherOrStudent() -> String {
        if isInternetAvailable(){
            if "\(loginID.first!)" >= "0" && "\(loginID.first!)" <= "9" {
                return "s"
            }else{
                return "t"
            }
        }
        return ""
    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        let url : URL = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if image != nil {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                    })
                }
            }
        })
        task.resume()
    }
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    //    func initializeNFCSession() {
    //        // Create the NFC Reader Session when the app starts
    //        self.nfcSession = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
    //        self.nfcSession.alertMessage = "Scan your student ID by placing it near your phone."
    //    }
}

@available(iOS 11.0, *)
extension ProfileViewController : NFCNDEFReaderSessionDelegate {
    
    // Called when the reader-session expired, you invalidated the dialog or accessed an invalidated session
    @available(iOS 11.0, *)
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error reading NFC: \(error.localizedDescription)")
    }
    
    // Called when a new set of NDEF messages is found
    @available(iOS 11.0, *)
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("New NFC Tag detected:")
        
        for message in messages {
            for record in message.records {
                print("Type name format: \(record.typeNameFormat)")
                print("Payload: \(record.payload)")
                print("Type: \(record.type)")
                print("Identifier: \(record.identifier)")
            }
        }
        
        
    }
}
