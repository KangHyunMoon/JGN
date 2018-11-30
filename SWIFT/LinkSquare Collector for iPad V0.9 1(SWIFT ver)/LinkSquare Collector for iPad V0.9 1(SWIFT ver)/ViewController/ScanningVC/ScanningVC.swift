//
//  ScanningVC.swift
//  LinkSquare Collector for iPad V0.9 1(SWIFT ver)
//
//  Created by KangHyunMoon on 2018. 5. 28..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit
import SwiftChart

// 스캐닝 뷰컨트롤러
// 차트를 보여주고, 스캔 API를 사용한다.
// 스캔한 데이터는 파일매니저를 통해 저장한다.

class ScanningVC: UIViewController, ChartDelegate {

    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
    
    }
    
    func didFinishTouchingChart(_ chart: Chart) {

    }
    
    func didEndTouchingChart(_ chart: Chart) {
    
    }
    

    var i = 1
    
    @IBOutlet weak var contactImg: UIImageView!
    
    @IBOutlet weak var chart: Chart!
    
    @IBOutlet weak var O_scanBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.delegate = self
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let imgListArray : NSMutableArray = []
        
        for i in 1...12{
            let image = UIImage(named: "contact"+String(i))
            imgListArray.addObjects(from: [image as Any])
        }
        
        self.contactImg.animationImages = imgListArray as? [UIImage]
        self.contactImg.animationDuration = 1.0
        self.contactImg.startAnimating()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var ledFrameNum : Int32 = 3
    var bulbFrameNum : Int32 = 3
    var isSNV : Bool = true
    var raw_data : NSArray!
    var data : NSArray!
    var raw : NSArray!
    var isSucc : Bool!
    
    var flag = 0
    
    @IBAction func scanBtn(_ sender: Any) {
        
        O_scanBtn.isEnabled = false
        O_scanBtn.setTitle("re-try", for: .normal)
        
        
        if (flag == 0) {
            self.contactImg.stopAnimating()
            flag = 1
        }
        
        let imgListArray : NSMutableArray = []
        
        for i in 1...24{
            let image = UIImage(named: "scanning"+String(i))
            imgListArray.addObjects(from: [image as Any])
        }
        
        self.contactImg.animationImages = imgListArray as? [UIImage]
        self.contactImg.animationDuration = 1.0
        self.contactImg.startAnimating()
        
        DispatchQueue.main.async {
            
            ls?.scanLED(self.ledFrameNum, andBULB: self.bulbFrameNum, doSNV: self.isSNV, withCallback: {isSucc,raw_data, data,raw in
                
                self.setupGraph(array : raw_data as! Array<Double>)
                
                
                if filemgr.fileExists(atPath: filepath){
                    print("example find!")
                    
                    
                    self.writeFile(array: raw_data as! Array<Int>)
                    
                }
                else {
                    print("cant find!")
                    
                    if filemgr.createFile(atPath: filepath, contents: nil, attributes: nil) {
                        print("File create complete")
                    }
                    else {
                        print("File create do not complete")
                    }
                }
            })
        }
        
    }
    
    func setupGraph(array : Array<Double>)->(){
        
        chart.removeAllSeries()
        
        self.chart.isHidden = false
        
        let data = array[0...599]
        
        let series = ChartSeries(Array(data))
        
        series.area = false
        
        chart.add(series)
        
        chart.minX = 0
        chart.maxX = 600
        
        chart.minY = 0
        chart.maxY = 36
        
        //chart.yLabels = [6, 12, 18, 24, 30, 36]
        chart.xLabels = [0, 600]
        
        chart.yLabelsFormatter = { String(Int($1))}
        
        chart.xLabelsFormatter = { String(Int($1)+400)}
        
        
        O_scanBtn.isEnabled = true
        
        print("stop")
        self.contactImg.stopAnimating()
        
    }
    
    func writeFile(array : Array<Int>)->() {
        
        let path = (filepath as NSString).expandingTildeInPath
        
        for i in 0...599 {
            let s = String(array[i])
            let d = s.data(using: String.Encoding.ascii)!
            
            if let fh = FileHandle(forWritingAtPath: path) {
                fh.seekToEndOfFile()
                fh.write(d)
                fh.closeFile()
            }
            else{
                print("file open error!")
            }
        }
        
        readFile()
    }
    
    func readFile()->(){
        if let stream:InputStream = InputStream(fileAtPath: filepath){
            var buf:[UInt8] = [UInt8](repeating: 0, count: 600)
            stream.open()
            while true {
                let len = stream.read(&buf, maxLength: buf.count)
                print("\nlen \(len)")
                
                for i in 0..<len {
                print(String(format:"%c ", buf[i]), terminator: "")
                }
                
                if len < buf.count {
                    break
                }
            }
            stream.close()
            
        }
            
        else{
            print("File open failed")
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
