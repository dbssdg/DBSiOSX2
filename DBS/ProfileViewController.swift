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

var loginID = ""

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var userInfo: UITableView!
    
    let houses = ["Arthur", "Featherstone", "Goodban", "Piercy", "Sargent", "Sykes", "Lowcock", "George She"]
    let houseColours = [[55, 125, 34], [0, 6, 133], [152, 52, 48], [255, 254, 84], [235, 51, 35], [150, 205, 232], [243, 168, 59], [117, 25, 124]]
    
    var userInformation = [String: String?]()
    var profileData = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        if let x = UserDefaults.standard.string(forKey: "loginID") {
            loginID = x
        }
        userInfo.separatorStyle = .none
        
        func reload(action: UIAlertAction) { viewDidAppear(animated) }
        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: reload))
        let wrongPassword = UIAlertController(title: "ERROR", message: "Incorrect username or password. Please try again.", preferredStyle: .alert)
        wrongPassword.addAction(UIAlertAction(title: "OK", style: .default, handler: reload))
        let noPassword = UIAlertController(title: "ERROR", message: "Please fill in your username and password. Thank you.", preferredStyle: .alert)
        noPassword.addAction(UIAlertAction(title: "OK", style: .default, handler: reload))
        
        if loginID != "" {
            let startsWithdbs = loginID
            loginID.removeFirst(3)
            let startsWith20 = "20\(loginID)"
            studentImage.layer.cornerRadius = 30
            
            userInfo.dataSource = self
            userInfo.delegate = self
            
            let jsonURL = "http://eclass.dbs.edu.hk/help/dbsfai/eauth-json\(teacherOrStudent()).php?uid=\(startsWithdbs)"
            print(jsonURL)
            let url = URL(string: jsonURL)
            
            if isInternetAvailable() {
                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    do {
                        
                        self.userInformation = try JSONDecoder().decode([String: String?].self, from: data!)
                        
                        var classNumber = (self.userInformation["NameEng"]!)!
                        classNumber.removeFirst()
                        while classNumber.count > 7 {
                            classNumber.removeLast()
                        }
                        if "\(classNumber.last!)" == ")" { classNumber.removeLast() }
                        
                        if self.teacherOrStudent() == "" {
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
                            if self.teacherOrStudent() == "s" {
                                self.studentImage.image = UIImage(named: "Student")
                            } else {
                                self.studentImage.image = UIImage(named: "TeacherBig")
                            }
                            self.getImage("http://ears.dbs.edu.hk/studpics.php?sid=\(startsWith20)", self.studentImage)
                            self.userInfo.reloadData()
                            UserDefaults.standard.set(self.profileData, forKey: "profileData")
                        }
                        
                    } catch {
                        print("ERROR")
                    }
                }.resume()
                
            } else {
                if let x = UserDefaults.standard.array(forKey: "profileData") {
                    profileData = x as! [String]
                    userInfo.reloadData()
                }
            }
            
            
        } else {
            let loginAlert = UIAlertController(title: "Login", message: "Your eClass Account", preferredStyle: .alert)
            loginAlert.addTextField { (textField) in
                textField.placeholder = "e-Class Login (starts with dbs)"
                textField.autocapitalizationType = .none
            }
            loginAlert.addTextField { (textField) in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            }
            
            func changeTabBar(action: UIAlertAction) {
                self.tabBarController?.selectedIndex = 0
            }
            loginAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: changeTabBar))
            
            func checkPassword(action: UIAlertAction) {
                if (loginAlert.textFields![0].text!) == "" || (loginAlert.textFields![1].text!) == "" {
                    print("Please fill in your username or password.")
                    present(noPassword, animated: true)
                } else if !isInternetAvailable() {
                    present(networkAlert, animated: true)
                } else if loginAlert.textFields![0].text!.count <= 4 {
                    print("Username Failure")
                    present(wrongPassword, animated: true)
                } else {
                    
                    loginID = (loginAlert.textFields![0].text!)
                    let startsWithdbs = loginID
                    loginID.removeFirst(3)
                    let startsWith20 = "20\(loginID)"
                    
                    networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    let jsonURL = "http://eclass.dbs.edu.hk/help/dbsfai/eauth-json\(teacherOrStudent()).php?uid=\(startsWithdbs)"
                    let url = URL(string: jsonURL)
                    
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        do {
                            let userInfo = try JSONDecoder().decode([String: String?].self, from: data!)
                            print(userInfo["cash"]!!)
                            print(userInfo["hash"]!!)
                            
                            DispatchQueue.main.async {
                                let first = "\(loginAlert.textFields![0].text!)"
                                let second = "\(loginAlert.textFields![1].text!)"
                                if "\(first+second)1ekfx1".md5() == userInfo["hash"]!! || "\(first)|dbsfai2012|\(second.md5())".md5() == userInfo["cash"]!! {
                                    loginID = first
                                    UserDefaults.standard.set(loginID, forKey: "loginID")
                                    self.viewDidAppear(animated)
                                    print("SUCCESS")
                                } else {
                                    loginID = ""
                                    self.present(wrongPassword, animated: true)
                                    print("Password Failure")
                                }
                            }
                            
                        } catch {
                            self.present(networkAlert, animated: true)
                            print("ERROR")
                        }
                    }.resume()
                    
                }
            }
            loginAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: checkPassword))
            present(loginAlert, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    @IBAction func options(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        func reportBug(action: UIAlertAction) {
            
            
            
            
            
        }
        func downloadStudentImage(action: UIAlertAction) {
            let imageData = UIImagePNGRepresentation(studentImage.image!)
            print("NO SIGABRT")
            let compressedImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            
            let savedAlert = UIAlertController(title: "Saved", message: "Your student image has been saved to Photos.", preferredStyle: .alert)
            savedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(savedAlert, animated: true)
        }
        func signOut(action: UIAlertAction) {
            loginID = ""
            UserDefaults.standard.set("", forKey: "loginID")
            UserDefaults.standard.set(nil, forKey: "profileData")
            profileData.removeAll()
            userInfo.reloadData()
            studentImage.image = nil
            viewDidAppear(true)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Report A Bug", style: .default, handler: reportBug))
        if teacherOrStudent() == "s" {
            actionSheet.addAction(UIAlertAction(title: "Download Student Image", style: .default, handler: downloadStudentImage))
        }
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: signOut))
        present(actionSheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loginID != "" {
            if teacherOrStudent() == "" {
                return 3
            } else if UIScreen.main.bounds.height < 667 &&  UIScreen.main.bounds.width < 375 {
                return 4
            } else if teacherOrStudent() == "s" {
                return 5
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! descriptionsTableViewCell
        if UIScreen.main.bounds.height < 667 &&  UIScreen.main.bounds.width < 375 && teacherOrStudent() == "s" {
            var arr = profileData
            arr.remove(at: 2)
            cell.descriptionText.text = "\(arr[indexPath.row])"
        } else {
            cell.descriptionText.text = "\(profileData[indexPath.row])"
        }
        cell.descriptionText.textAlignment = .center
        cell.selectionStyle = .none
        return cell
    }
    
    func teacherOrStudent() -> String {
        if "\(loginID.first!)" >= "0" && "\(loginID.first!)" <= "9" {
            return "s"
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
    
    
}
