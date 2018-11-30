//
//  IoTModeVC.swift
//  LinkSquare Collector for iPad V0.9 1(SWIFT ver)
//
//  Created by KangHyunMoon on 2018. 5. 8..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

// NCL 와이파이를 통한 기기 접속을 위함.
// ap모드와 똑같이 접속하나, 좀더 과정이 복잡함.
// 클래스 선언을 통해 인스턴스를 받음.
// 실제 구현하진 않았음..

let smartConfigQueue = DispatchQueue.init(label: "find")
var devices = [LinkSquareDevice_s]()

class IoTModeVC: UIViewController {
    var isUpdate : Int = 0;
    
    @IBOutlet weak var ssidField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var btnFind: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCurrentNetworkInfo()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnFindPressed(_ sender: Any) {
        
        if(isUpdate==0){
            startDeviceUpdate()
        }
        else{
            stopDeviceUpdate()
        }
    }
    
    @IBAction func btnConnectPressed(_ sender: Any) {
        
        
    }
    
    // 커넥션 시도할 경우
    
    func startDeviceUpdate()->(){
        isUpdate = 1;
        
        btnFind.setTitle("CANCEL", for: .normal)
        
        findDevices()
        
    }
    
    func stopDeviceUpdate()->(){
        isUpdate = 0;
        
        btnFind.setTitle("FIND DEVICE", for: .normal)
    }
    
    func findDevices()->(){
        //devices.clear();
        
        var apId = self.ssidField.text
        var apPw = self.passwordField.text
        var deviceName = "";
        var gatwayip = GATEWAY_IP
        
        smartConfigQueue.async {
            self.updateNetworkInfo(name : apId! as NSString, password : apPw! as NSString)
            
            var ssid = apId?.utf8CString
            var key = apPw?.utf8CString
            var deviceName = "";
        }

    }
    
    func updateNetworkInfo(name : NSString, password : NSString)->(){
        
        UserDefaults.standard.set(name, forKey:"name")
        UserDefaults.standard.set(password, forKey:"password")
    }
    
    func updateCurrentNetworkInfo()->(Bool){
        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            print("this must be a simulator, no interfaces found")
            return false
        }
        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            print("System error: did not come back as array of Strings")
            return false
        }
        for interface in swiftInterfaces {
            print("Looking up SSID info for \(interface)") // en0
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
                print("System error: \(interface) has no information")
                return false
            }
            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                print("System error: interface information is not a string-keyed dictionary")
                return false
            }
            for d in SSIDDict.keys {
                print("\(d): \(SSIDDict[d]!)")
                
                if(d == "SSID")
                {
                    self.ssidField.text = SSIDDict[d] as? String
                }
            }
        }
        
        return true
        
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
