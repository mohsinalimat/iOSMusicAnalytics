//
//  AnalyticsGraphViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 2/6/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import Charts
import CoreData

class AnalyticsGraphViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var lastMonthButton: UIButton!
    var dateIndex: Int!
    var yData: [Int]! = []
    var xData: [String]! = []
    var mode: String!
    var datePosition: (Date, Date)!
    var container : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCharts(with: yData, and:  mode)
        configureButton(using: 7, borderColor: myOrange(), borderWidth: 0.75, with: nextMonthButton)
        configureButton(using: 7, borderColor: myOrange(), borderWidth: 0.75, with: lastMonthButton)
        enableOrDisableDateButtons()
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
        chartView.setVisibleXRangeMaximum(6)
        chartView.animate(xAxisDuration: 1.50, yAxisDuration: 1.50)
    }
    
    @IBAction func decrementDate(_ sender: UIButton) {
        datePosition.1 = datePosition.0
        datePosition.0 = Date.monthPriorFromDate(using: datePosition.0)
        let fetchedData = obtainAnalyticsGraphData(from: datePosition.0, to: datePosition.1, withIndex: dateIndex, in: container!.viewContext)
        xData = fetchedData.0
        yData = fetchedData.1
        chartView.data = generateBarChartData(with: yData, andTitle: mode)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xData)
        chartView.animate(xAxisDuration: 1.50, yAxisDuration: 1.50)
        enableOrDisableDateButtons()
    }
   
    @IBAction func incrementDate(_ sender: UIButton) {
        datePosition.0 = datePosition.1
        datePosition.1 = Date.monthAfterFromDate(using: datePosition.1)
        let fetchedData = obtainAnalyticsGraphData(from: datePosition.0, to: datePosition.1, withIndex: dateIndex, in: container!.viewContext)
        xData = fetchedData.0
        yData = fetchedData.1
        chartView.data = generateBarChartData(with: yData, andTitle: mode)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xData)
        chartView.animate(xAxisDuration: 1.50, yAxisDuration: 1.50)
        enableOrDisableDateButtons()
    }
    
    func enableOrDisableDateButtons(){
        if AnalyticsDate.doesRangeContainValue(from: Date.monthPriorFromDate(using: datePosition.0), to: Date.monthPriorFromDate(using: datePosition.1), in: container!.viewContext){
            lastMonthButton.isEnabled = true
            lastMonthButton.alpha = 1
        } else {
            lastMonthButton.isEnabled = false
            lastMonthButton.alpha = 0.3
        }
        if AnalyticsDate.doesRangeContainValue(from: Date.monthAfterFromDate(using: datePosition.0), to: Date.monthAfterFromDate(using: datePosition.1), in: container!.viewContext){
            nextMonthButton.isEnabled = true
            nextMonthButton.alpha = 1
        } else {
            nextMonthButton.isEnabled = false
            nextMonthButton.alpha = 0.3
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
