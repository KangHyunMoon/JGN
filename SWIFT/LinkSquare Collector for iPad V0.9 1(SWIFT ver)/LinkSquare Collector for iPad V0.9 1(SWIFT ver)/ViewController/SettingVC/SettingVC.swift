//
//  SettingVC.swift
//  LinkSquare Collector for iPad V0.9 1(SWIFT ver)
//
//  Created by KangHyunMoon on 2018. 5. 1..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit

// 기기에서 LED 프레임이나, 여러가지 어플리케이션 세팅을 위한 뷰컨트롤

class SettingVC: UIViewController,UIPickerViewDataSource,
UIPickerViewDelegate{ //protocol accept.
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var addressButton: UIButton!
    
    var textField1 : UITextField?
    
    let frame = ["1 Frame", "2 Frame", "3 Frame", "4 Frame", "5 Frame", "6 Frame"]
    // 6가지 프레임 제공
    // Declare variable of picerView.
    
    //---- UIPickerViewDataSource Protocol method ----
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //returns the # of rows in each component!
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frame.count
    }
    //---- end ----
    
    
    //---- UIPickerViewDelegate Protocol method ----
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if (component == 0) // case of component 0
        {
        UserDefaults.standard.set(row, forKey:"pickData1")
        }
            
        else
        { // case of component 1
        UserDefaults.standard.set(row, forKey:"pickData2")
        }
        
    } // Event that pickerView was selected..
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return frame[row]
    } // Setting rows' name of each component :)
    
    //---- end ----
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
         pickerView.selectRow(UserDefaults.standard.integer(forKey: "pickData1"), inComponent: 0, animated: true)
         pickerView.selectRow(UserDefaults.standard.integer(forKey: "pickData2"), inComponent: 1, animated: true)
        
        switch1.setOn(UserDefaults.standard.bool(forKey: "switch1"), animated: true)
        switch2.setOn(UserDefaults.standard.bool(forKey: "switch2"), animated: true)
        
        
        //addressButton.setTitle(UserDefaults.standard.string(forKey: "textField")!, for: .normal)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switch1_act(_ sender: Any) {
        UserDefaults.standard.set(switch1.isOn, forKey:"switch1")
        
        print(UserDefaults.standard.bool(forKey: "switch1"))
        
    }
    @IBAction func switch2_act(_ sender: Any) {
        UserDefaults.standard.set(switch2.isOn, forKey:"switch2")
        
        print(UserDefaults.standard.bool(forKey: "switch2"))
    }
    
    @IBAction func mailButton(_ sender: Any) {
        
        let alert = UIAlertController(title : "e-mail address", message: "", preferredStyle : UIAlertControllerStyle.alert)
        
        let OK_Button : UIAlertAction = UIAlertAction(title : "OK", style: UIAlertActionStyle.default){
            action -> Void in
            //do something
        UserDefaults.standard.set(self.textField1!.text!, forKey:"textField")
            self.addressButton.setTitle(self.textField1!.text!, for:.normal)
        }
        
        let CANCEL_Button : UIAlertAction = UIAlertAction(title : "CANCEL", style: UIAlertActionStyle.cancel){
            action -> Void in
            //do something
           
        }
        
        alert.addAction(CANCEL_Button)
        alert.addAction(OK_Button)
        alert.addTextField {
            textField in
            
            self.textField1 = textField
            textField.placeholder = "address"
        }
        
        self.present(alert, animated: true, completion : nil)
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
