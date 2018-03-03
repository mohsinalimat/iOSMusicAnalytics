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
    var yData: [Int]! = []
    var xData: [String]! = []
    var mode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCharts(with: yData, and:  mode)
    }
    
    func setUpCharts(with data:[Int], and label: String){
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false
        chartView.gridBackgroundColor = .black
        chartView.maxVisibleCount = 7
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.gridColor = .black
        xAxis.axisLineColor = .lightGray
        xAxis.labelTextColor = .lightGray
        
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
        leftAxis.axisLineColor = .white
        leftAxis.labelTextColor = .lightGray
        
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
        l.textColor = .lightGray
        
        chartView.data = generateBarChartData(with: data, andTitle: label)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xData)
        chartView.animate(xAxisDuration: 1.50, yAxisDuration: 1.50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
