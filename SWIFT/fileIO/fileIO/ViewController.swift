//
//  ViewController.swift
//  fileIO
//
//  Created by KangHyunMoon on 2018. 4. 17..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit

let filemgr = FileManager.default

class ViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    @IBAction func search1(_ sender: UIButton) {
        if filemgr.fileExists(atPath: "/tmp/test1.bin") {
            label1.text = "file1 found! :)"
        }
        else {
            label1.text = "file1 cant found! :<"
            
        }
    }
    @IBAction func search2(_ sender: UIButton) {
        if filemgr.fileExists(atPath: "/tmp/test2.bin") {
            label2.text = "file2 found! :)"
        }
        else {
            label2.text = "file2 cant found! :<"
        }
    }
    
    let filepath1 = "/tmp/test1.bin"
    
    @IBAction func create1(_ sender: UIButton) {
        
        if filemgr.createFile(atPath: filepath1, contents: nil, attributes: nil) {
            label1.text = "File1 create complete"
        }
        else {
            label1.text = "File1 create do not complete"
        }
    }
    
    let filepath2 = "/tmp/test2.bin"
    
    @IBAction func create2(_ sender: UIButton) {
        
        
        if filemgr.createFile(atPath: filepath2, contents: nil, attributes: nil) {
            label2.text = "File2 create complete"
        }
        else {
            label2.text = "File2 create do not complete"
        }
    }
    
    @IBAction func read1(_ sender: UIButton) {
        if let stream:InputStream = InputStream(fileAtPath: filepath1){
            var buf:[UInt8] = [UInt8](repeating: 0, count: 100)
            stream.open()
            while true {
                let len = stream.read(&buf, maxLength: buf.count)
                print("\nlen \(len)")
                textView1.text = "len \(len)\n"
                
                for i in 0..<len {
                    if ((i % 10) == 0)
                    {
                        print("\n" + "*\(i):")
                        textView1.insertText("\n" + "*\(i):")
                    }
                    print(String(format:"%02x ", buf[i]), terminator: "")
                    textView1.insertText(String(format:"%02x ", buf[i]))
                }
                
                if len < buf.count {
                    break
                }
            }
            stream.close()
            
        }
        
        else{
            label1.text = "File open failed"
        }
    }
    
    @IBAction func read2(_ sender: UIButton) {
        if let stream:InputStream = InputStream(fileAtPath: filepath2){
            var buf:[UInt8] = [UInt8](repeating: 0, count: 100)
            stream.open()
            while true {
                let len = stream.read(&buf, maxLength: buf.count)
                print("\nlen \(len)")
                textView2.text = "len \(len)\n"
                
                for i in 0..<len {
                    if ((i % 10) == 0)
                    {
                        print("\n" + "*\(i):")
                        textView2.insertText("\n" + "*\(i):")
                    }
                    print(String(format:"%02x ", buf[i]), terminator: "")
                    textView2.insertText(String(format:"%02x ", buf[i]))
                }
                
                if len < buf.count {
                    break
                }
            }
            stream.close()
            
        }
            
        else{
            label2.text = "File open failed"
        }
    }
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    @IBAction func write1(_ sender: UIButton) {
        let s = textField1.text
        let d = s?.data(using: String.Encoding.ascii)!
        let path = (filepath1 as NSString).expandingTildeInPath
        if let fh = FileHandle(forWritingAtPath: path) {
            fh.seekToEndOfFile()
            fh.write(d!)
            fh.closeFile()
        }
        else{
            label1.text = "file open error!"
        }
        
    }
    @IBAction func write2(_ sender: UIButton) {
        let s = textField2.text
        let d = s?.data(using: String.Encoding.ascii)!
        let path = (filepath2 as NSString).expandingTildeInPath
        if let fh = FileHandle(forWritingAtPath: path) {
            fh.seekToEndOfFile()
            fh.write(d!)
            fh.closeFile()
        }
        else{
           label2.text = "file open error!"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if filemgr.fileExists(atPath: "/tmp/test1.bin") {
            label1.text = "file1 found! :)"
        }
        else {
            label1.text = "file1 cant found! :<"
            
        }
        
        if filemgr.fileExists(atPath: "/tmp/test2.bin") {
            label2.text = "file2 found! :)"
        }
        else {
            label2.text = "file2 cant found! :<"
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

