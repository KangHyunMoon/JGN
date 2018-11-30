//
//  ViewController.swift
//  gesture
//
//  Created by KangHyunMoon on 2018. 4. 15..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var View1: UIView!
    
    var titles = ["1","2","3","4"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    var arr_cell : NSMutableArray = []
    var index = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        
        arr_cell[index] = cell
        
        index = index+1
        
        
        //셀의 텍스트라벨 설정
        
        return cell
    }
    
    @IBOutlet weak var viewTable: UITableView!
    
    @objc func func1()->(){
        print(1)
        
        for num in 0..<index {
            (arr_cell[num] as! TableViewCell).btn.isHidden = false
        }
        
    }
    
    @IBAction func func2(_ sender: Any) {
        print(2)
        
        for num in 0..<index {
            (arr_cell[num] as! TableViewCell).btn.isHidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewTable.delegate = self
        viewTable.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(func1))
        View1.addGestureRecognizer(tapGesture)
        View1.isUserInteractionEnabled = true
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
