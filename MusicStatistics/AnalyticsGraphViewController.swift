//
//  AnalyticsGraphViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 2/6/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import Charts

class AnalyticsGraphViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var chartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testDict: Dictionary<Int,Int> = [1:10, 2:20, 3:30, 4:40, 5:50, 6: 30]
        setUpCharts(with: testDict, and:  "Hello")
    }
    
    func setUpCharts(with data:Dictionary<Int,Int>, and label: String){
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false
        
        chartView.maxVisibleCount = 60
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = ""
        leftAxisFormatter.positiveSuffix = ""
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        chartView.data = generateBarChartData(with: data, andTitle: "Hello")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
