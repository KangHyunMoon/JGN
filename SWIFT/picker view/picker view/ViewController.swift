//
//  ViewController.swift
//  picker view
//
//  Created by KangHyunMoon on 2018. 4. 8..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    let animals = ["Dog", "Monkey", "Cat", "Lion"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var selectionBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.isHidden = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectPressed(_ sender: UIButton) {
        
        if (pickerView.isHidden){
            pickerView.isHidden = false
        }
        else{
            pickerView.isHidden = true
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        return 2
    }
    // returns the # of rows in each component..
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return animals.count
    } // 컴포넌트의 행의 갯수
 
 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if (component == 0)
        {
            label1.text = animals[row]
        }
        
        else
        {
            label2.text = animals[row]
        }
    
        selectionBtn.setTitle(animals[row], for: .normal)
        pickerView.isHidden = true
    } // 컴포넌트가 셀렉트 되었을때
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return animals[row]
    } // 컴포넌트의 이름

}

