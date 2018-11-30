//
//  ViewController.swift
//  datepicker
//
//  Created by KangHyunMoon on 2018. 4. 5..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblPickerTime: UILabel!
    
    let timeSelector: Selector = #selector(ViewController.updateTime)
    
    let interval = 1.0
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        //타이머 간격, 동작될 view, 타이머 구동될 때 실행할 함수, 사용자 정보, 반복 여부
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        
        let datePickerView = sender
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEE"
        lblPickerTime.text = "선택 시간: " + formatter.string(from: datePickerView.date)
    }
    
    @objc func updateTime(){
        //lblCurrentTime.text = String(count)
        //count = count + 1
        
        let date = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEE"
        lblCurrentTime.text = "현재 시간:" + formatter.string(from: date as Date)
    }
    //selector의 인자로 사용될 메서드를 선언할 때는
    //obj-c와의 호완성을 위해 앞에 @objc을 붙여준다.
}

