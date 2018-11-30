//
//  ViewController.swift
//  graph_test3
//
//  Created by KangHyunMoon on 2018. 4. 14..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit
import CoreGraphics
import Foundation
import SwiftChart

class ViewController: UIViewController, ChartDelegate{
    
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var NavigationBar: UINavigationBar!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var viewCell1: UITableViewCell!
    @IBOutlet weak var viewCell2: UITableViewCell!
    @IBOutlet weak var viewCell3: UITableViewCell!
    @IBOutlet weak var viewCell4: UITableViewCell!
    
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
                
                if (seriesIndex == 0)
                {
                    viewCell1.textLabel?.text = "x:\(x)"
                    
                    viewCell2.textLabel?.text = "y:\(value)"
                }
                else
                {
                    viewCell3.textLabel?.text = "x:\(x)"
                    
                    viewCell4.textLabel?.text = "y:\(value)"
                }
                
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
    }
    
    func didEndTouchingChart(_ chart: Chart) {
    }
    //delegate func...
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.delegate = self
        NavigationBar.topItem?.title = "Line Graph"
        // title 설정
        
        // Chart with y-min, y-max and y-labels formatter
        let data: [Double] = [0, -2, -2, 3, -3, 4, 1, 0, -1]
        let data2: [Double] = [0, 1, 2, 3, 4, 5, 6, -1, 5]
        
        
        let series = ChartSeries(data)
        series.colors = (
            above: ChartColors.greenColor(),
            below: ChartColors.yellowColor(),
            zeroLevel: 0
        )
        let series2 = ChartSeries(data2)
        series.colors = (
            above: ChartColors.greenColor(),
            below: ChartColors.yellowColor(),
            zeroLevel: 0
        )
        series.area = true
        series2.area = true
        
        chart.add(series)
        chart.add(series2)
        
        
        // Set minimum and maximum values for y-axis
        chart.minY = -7
        chart.maxY = 7
        
        chart.minX = -10
        chart.maxX = 10
        
        
        
        // Format y-axis, e.g. with units
        chart.yLabelsFormatter = { String(Int($1))}
        chart.xLabelsFormatter = { String(Int($1))+"K"}
    }
}

