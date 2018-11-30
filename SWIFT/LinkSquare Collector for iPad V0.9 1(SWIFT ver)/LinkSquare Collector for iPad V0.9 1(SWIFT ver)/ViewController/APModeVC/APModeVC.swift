//
//  APModeVC.swift
//  LinkSquare Collector for iPad V0.9 1(SWIFT ver)
//
//  Created by KangHyunMoon on 2018. 5. 14..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit

// ap모드 뷰컨트롤러
// 기기간 통신모드



var conblk : ConnectionBlock!
var selectedDevice : NSMutableDictionary?

class APModeVC: UIViewController {
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func connectionBtn(_ sender: Any) {
        loadStuff()
    }
    
    func loadStuff()->(){
        
        // 다중 쓰레드를 통해 병렬성을 늘린다.
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            ls?.setIpAddress(ip2, andPort: Int32(port))
            // 아이피 어드레스 세팅
            
            ls?.setupConnection(callback: conblk)
            // 커넥션 시도
            
            // '?'는 옵셔널. 실패시 nil값을 반환하여 쓰레드가 종료되는 것을 방지함.
            // 스위프트의 에러처리 방법
            
            
            
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                if ((conblk) != nil){
                    print("conblk != nil")
                }
                else{
                    print("conblk == nil")
                }
            }
        }
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
