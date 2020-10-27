//
//  SecondViewController.swift
//  testApp
//
//  Created by 1 on 06.10.2020.
//  
//

import UIKit
import Charts
import CalendarDateRangePickerViewController
import RealmSwift

class SecondViewController: UIViewController, GetDataFromHomeVC, SecondView {
    
    var receivedLogin = ""
    var receivedRepo = ""
    var datesForChart: [String] = []
    var startDateDate = Date()
    var endDateDate = Date()
    var presenter: SecondPresenter!
    var starDatesService: StarDatesService!
    var datesAndStars: [DatesAndStars] = []
    private var myRepoStars: [RepoStarsByDates] = []
    var barChartDataEntry: [BarChartDataEntry] = []
    lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = .systemBackground
        chartView.scaleXEnabled = true
        return chartView
    }()
    
    @IBOutlet weak var selectDatesBtn: UIButton!
    @IBOutlet weak var selectedDatesLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var secondLabel: UILabel!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.addSubview(barChartView)
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        getDatesForChart()
        barChartView.xAxis.enabled = true
        barChartView.xAxis.wordWrapEnabled = true
        barChartView.xAxis.drawLabelsEnabled = true
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.granularity = 1
        print("ДАТЫ ДЛЯ ГРАФИКА: \(datesForChart)")
    }
    
    func getDatesForChart() {
        let dateFormatter = DateFormatter()
        for i in 0..<datesAndStars.count {
            let date = datesAndStars[i].dates
            dateFormatter.dateFormat = "dd.MM.yyyy"
            dateFormatter.locale = Locale(identifier: "ru_Ru")
            let newDate = dateFormatter.string(from: date)
            datesForChart.append(newDate)
        }
    }
    
    @IBAction func selectDateRangeBtn(_ sender: UIButton) {
        let firstDate = datesAndStars.first?.dates
        let lastDate = Date()
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        dateRangePickerViewController.minimumDate = firstDate ?? Date()
        dateRangePickerViewController.maximumDate = lastDate
        dateRangePickerViewController.selectedStartDate = firstDate ?? Date()
        dateRangePickerViewController.selectedEndDate = lastDate
//        dateRangePickerViewController.selectedColor = UIColor.red
//        dateRangePickerViewController.titleText = "Select Date Range"
        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Setup
    
    private func prepareUI() {
        
        selectDatesBtn.layer.cornerRadius = 10
        selectedDatesLabel.layer.cornerRadius = 10
        selectedDatesLabel.layer.masksToBounds = true
        barChartView.centerXAnchor.constraint(equalTo: chartView.centerXAnchor).isActive = true
        barChartView.centerYAnchor.constraint(equalTo: chartView.centerYAnchor).isActive = true
        barChartView.widthAnchor.constraint(equalTo: chartView.widthAnchor).isActive = true
        barChartView.heightAnchor.constraint(equalTo: chartView.heightAnchor).isActive = true
        selectedDatesLabel.text = "Выберите даты для графика"
        // Customize UI structure appearance
    }
    
    // MARK: - Actions
    
    func showReceivedData(repo receivedGitRepo: String, login receivedGitLogin: String) {
        secondLabel.text = "Stars statistics for:\nhttps://github.com/\(receivedGitLogin)/\(receivedGitRepo)"
    }
    
    func reloadRepoStars(_ myRepoStars: [RepoStarsByDates]) {
        self.myRepoStars = myRepoStars
        selectedDatesLabel.text = "Выберите даты для графика"
    }
    
    func prepareData() {
        var cutDatesAndStars: [DatesAndStars] = []
        barChartDataEntry.removeAll()
        cutDatesAndStars = datesAndStars.filter { $0.dates >= startDateDate && $0.dates <= endDateDate }
        for i in 0..<cutDatesAndStars.count {
            barChartDataEntry.append(BarChartDataEntry(x: Double(i), y: Double(cutDatesAndStars[i].stars)))
        }
    }
    
    func setData() {
        guard !barChartDataEntry.isEmpty else { return }
        let set1 = BarChartDataSet(entries: barChartDataEntry, label: "Git Stars")
        let data = BarChartData(dataSet: set1)
        data.barWidth = 0.8
        barChartView.data = data
        let scaleX = CGFloat(50 * (set1.count == 0 ? 1 : set1.count)) / barChartView.bounds.width
        barChartView.zoom(scaleX: scaleX, scaleY: 1, x: 0, y: 0)
    }
}

// MARK: - Range Dates Calendar

extension SecondViewController : CalendarDateRangePickerViewControllerDelegate {
    func didTapCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        startDateDate = startDate
        endDateDate = endDate
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        selectedDatesLabel.text = "Statistics from \(startDateString) \nto \(endDateString) is ready"
        self.navigationController?.dismiss(animated: true, completion: nil)
        prepareData()
        setData()
        getDatesForChart()
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: datesForChart)
    }

// MARK: - GetDataFromHomeVC
    
    func getLoginRepoDatesStars(datesStars: [DatesAndStars], login: String, repository: String) {
        receivedLogin = login
        receivedRepo = repository
        datesAndStars = datesStars
    }

}

