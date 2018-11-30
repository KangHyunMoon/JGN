//
//  SplashVC.swift
//  LinkSquare Collector for iPad V0.9 1(SWIFT ver)
//
//  Created by KangHyunMoon on 2018. 5. 28..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit

// 스플래쉬 뷰. 커넥션 이후의 상황을 표시해주기 위한 뷰.
// 커넥션 ok/error를 표시한다.

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        var connected = ls?.checkConnected()
        print(connected!)
        
        let alert = UIAlertController(title : "connect error!", message: "", preferredStyle : UIAlertControllerStyle.alert)
        // 에러가 발생할경우
        // 얼럿을 띄운다.
        
        let OK_Button : UIAlertAction = UIAlertAction(title : "OK", style: UIAlertActionStyle.default){
            action -> Void in
            // 얼럿에서 오케이를 누른 경우
            //do something
            
            self.performSegue(withIdentifier: "AP Mode", sender: self)
            // ap모드 뷰로 돌아간다.
        }
        
        alert.addAction(OK_Button)
        
        
        if (connected! == true)
        {
            self.performSegue(withIdentifier: "Scanning", sender: self)
            //커넥션 실패 -> 스캐닝으로 돌아간다
        }
        
        else
        {
            self.present(alert, animated: true, completion : nil)
            // 성공시 애니메이션 출력
        }
        
        
    }
    
    func loadStuff()->(){
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            ls?.setIpAddress(ip2, andPort: Int32(port))
            
            ls?.setupConnection(callback: conblk)
            
            
            
            
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
