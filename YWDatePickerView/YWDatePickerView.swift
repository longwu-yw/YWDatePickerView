//
//  YWDatePickerView.swift
//  YWDatePickerView
//
//  Created by YeWang on 2021/1/2.
//

import UIKit

public enum YWDatePickerStyle {
    case DateStyle_YearMonth
    case DateStyle_YearMonthDay
    case DateStyle_YearMonthDayHourMinute
    case DateStyle_HourMinute
}

public struct YWDatePickerModel {
    var year = ""
    var month = ""
    var day = ""
    var hour = ""
    var minute = ""
    
    init(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy,MM,dd,HH,mm,ss"
        let dateStr = dateFormatter.string(from: date)
        let strArr = dateStr.split(separator: ",")
        year = String(strArr[0])
        month = String(strArr[1])
        day = String(strArr[2])
        hour = String(strArr[3])
        minute = String(strArr[4])
    }
}

public class YWDatePickerView: UIView {

    public var currentDate: Date = Date() {
        didSet {
            pickerModel = YWDatePickerModel.init(currentDate)
            scrollToTargetDate(currentDate)
        }
    }
    
    public var minDate: Date? {
        didSet {
            if let mDate = minDate {
                minPickerModel = YWDatePickerModel.init(mDate)
                pickerView.reloadAllComponents()
            }
        }
    }
    
    public var maxDate: Date? {
        didSet {
            if let mDate = maxDate {
                maxPickerModel = YWDatePickerModel.init(mDate)
                pickerView.reloadAllComponents()
            }
        }
    }
    
    private let minYear = 1970
    private let maxYear = 2099
    
    private var minPickerModel: YWDatePickerModel = YWDatePickerModel.init(Date.init(timeIntervalSince1970: 0))
    private lazy var maxPickerModel: YWDatePickerModel = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let date = dateFormatter.date(from: String(format: "%d1231235959", self.maxYear))
        return YWDatePickerModel.init(date!)
    }()
    
    private var pickerModel: YWDatePickerModel = YWDatePickerModel.init(Date())
    private var pickerStyle = YWDatePickerStyle.DateStyle_YearMonthDay
    private var pickerView = UIPickerView()
    private lazy var yearsArr: [String] = {
        var yearArr = [String]()
        for year in minYear...maxYear {
            yearArr.append("\(year)")
        }
        return yearArr
    }()
    private lazy var monthsArr: [String] = {
        var monthArr = [String]()
        for month in 1...12 {
            monthArr.append(String(format: "%02d", month))
        }
        return monthArr
    }()
    
    private lazy var allDaysArr: [String] = {
        var allDayArr = [String]()
        for day in 1...31 {
            allDayArr.append(String(format: "%02d", day))
        }
        return allDayArr
    }()
    private var daysArr = [String]()
    
    private lazy var hoursArr: [String] = {
        var hourArr = [String]()
        for hour in 0...23 {
            hourArr.append(String(format: "%02d", hour))
        }
        return hourArr
    }()
    private lazy var minutesArr: [String] = {
        var minuteArr = [String]()
        for minute in 0...59 {
            minuteArr.append(String(format: "%02d", minute))
        }
        return minuteArr
    }()

    private var yearIndex = 0
    private var monthIndex = 0 {
        willSet {
            if pickerStyle != .DateStyle_HourMinute, pickerStyle != .DateStyle_YearMonth {
                let month = newValue + 1
                let year = yearsArr[yearIndex]
                switch month {
                case 2:
                    if Int(year)! % 100 != 0, Int(year)! % 4 == 0 {
                        daysArr = Array(allDaysArr[0..<29])
                    } else {
                        if Int(year)! % 400 == 0 {
                            daysArr = Array(allDaysArr[0..<29])
                        } else {
                            daysArr = Array(allDaysArr[0..<28])
                        }
                    }
                case 1, 3, 5, 7, 8, 10, 12:
                    daysArr = allDaysArr
                default:
                    daysArr = Array(allDaysArr[0..<30])
                }
                
                if dayIndex >= daysArr.count {
                    dayIndex = daysArr.count - 1
                }
                pickerView.reloadComponent(2)
            }
        }
    }
    private var dayIndex = 0
    private var hourIndex = 0
    private var minuteIndex = 0
    
    private var isShowConfirmBtn = true
    private var pickerBlock: ((_ dateModel: YWDatePickerModel) -> Void)?
    
    @discardableResult
    public static func createDatePickerView(_ style: YWDatePickerStyle = .DateStyle_YearMonthDay, _ showConfirmBtn: Bool = true, _ complete: @escaping (_ dateModel: YWDatePickerModel) -> Void) -> YWDatePickerView {
        let dataPickerView = YWDatePickerView.init()
        dataPickerView.pickerStyle = style
        dataPickerView.isShowConfirmBtn = showConfirmBtn
        dataPickerView.pickerBlock = complete
        dataPickerView.createDataPickerSubViews()
        dataPickerView.currentDate = Date()
        return dataPickerView
    }
    
    private func scrollToTargetDate(_ date: Date) {
        
        let targetModel = YWDatePickerModel.init(date)
        
        yearIndex = Int(targetModel.year)! - minYear
        monthIndex = Int(targetModel.month)! - 1
        dayIndex = Int(targetModel.day)! - 1
        hourIndex = Int(targetModel.hour)!
        minuteIndex = Int(targetModel.minute)!
        switch pickerStyle {
        case .DateStyle_YearMonthDayHourMinute:
            pickerView.selectRow(yearIndex, inComponent: 0, animated: true)
            pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
            pickerView.selectRow(dayIndex, inComponent: 2, animated: true)
            pickerView.selectRow(hourIndex, inComponent: 3, animated: true)
            pickerView.selectRow(minuteIndex, inComponent: 4, animated: true)
        case .DateStyle_YearMonth:
            pickerView.selectRow(yearIndex, inComponent: 0, animated: true)
            pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
        case .DateStyle_HourMinute:
            pickerView.selectRow(hourIndex, inComponent: 0, animated: true)
            pickerView.selectRow(minuteIndex, inComponent: 1, animated: true)
        default:
            pickerView.selectRow(yearIndex, inComponent: 0, animated: true)
            pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
            pickerView.selectRow(dayIndex, inComponent: 2, animated: true)
        }
    }
    
    private func createDataPickerSubViews() {
        
        let kScreenWidth = UIScreen.main.bounds.width
        let kScreenHeight = UIScreen.main.bounds.height
        let kWindow = UIApplication.shared.windows.first
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if isShowConfirmBtn {
            let backView = UIView.init(frame: .init(x: 0, y: kScreenHeight, width: kScreenWidth, height: 216 + 48))
            backView.backgroundColor = .white
            addSubview(backView)
            
            backView.addSubview(pickerView)
            
            frame = .init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            backgroundColor = .clear
            kWindow?.addSubview(self)
            
            backView.frame = .init(x: 0, y: kScreenHeight, width: kScreenWidth, height: 216 + 48)
            
            let titleView = UIView.init(frame: .init(x: 0, y: 0, width: kScreenWidth, height: 48))
            titleView.backgroundColor = .init(red: 240 / 255.0, green: 240 / 255.0, blue: 240 / 255.0, alpha: 1)
            backView.addSubview(titleView)
            
            let cancelBtn = UIButton.create(frame: .init(x: 10, y: 4, width: 80, height: 40), title: "取消", fontSize: 15, imageName: nil)
            cancelBtn.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
            cancelBtn.setTitleColor(.gray, for: .normal)
            titleView.addSubview(cancelBtn)
            
            let confirmBtn = UIButton.create(frame: .init(x: kScreenWidth - 90, y: 4, width: 80, height: 40), title: "确认", fontSize: 15, imageName: nil)
            confirmBtn.addTarget(self, action: #selector(clickConfirmButton), for: .touchUpInside)
            confirmBtn.setTitleColor(.blue, for: .normal)
            titleView.addSubview(confirmBtn)
            
            let titleLab = UILabel.create(frame: .init(x: 100, y: 4, width: kScreenWidth - 200, height: 40), title: "请选择", fontSize: 17, alignment: .center)
            titleView.addSubview(titleLab)
            
            switch pickerStyle {
            case .DateStyle_YearMonth:
                titleLab.text = "请选择年月"
            case .DateStyle_HourMinute, .DateStyle_YearMonthDayHourMinute:
                titleLab.text = "请选择时间"
            default:
                titleLab.text = "请选择日期"
            }
            
            pickerView.frame = .init(x: 0, y: 48, width: kScreenWidth, height: 216)
            
            let safeBottom = kWindow?.safeAreaInsets.bottom ?? 0
            UIView.animate(withDuration: 0.5) {
                backView.frame = .init(x: 0, y: kScreenHeight - 216 - 48 - safeBottom, width: kScreenWidth, height: 216 + 48)
            }
            
        } else {
            frame = .init(x: 0, y: 0, width: kScreenWidth, height: 216)
            backgroundColor = .white
            pickerView.frame = self.bounds
            addSubview(pickerView)
        }
        
        switch pickerStyle {
        case .DateStyle_YearMonth:
            var xArr: [CGFloat] = [172, 265]
            if kScreenWidth > 400 {
                xArr = [190, 285]
            }
            let textArr = ["年", "月"]
            for index in 0..<xArr.count {
                createTagLab(xArr[index], textArr[index])
            }
        case .DateStyle_HourMinute:
            var xArr: [CGFloat] = [172, 265]
            if kScreenWidth > 400 {
                xArr = [190, 285]
            }
            let textArr = ["时", "分"]
            for index in 0..<xArr.count {
                createTagLab(xArr[index], textArr[index])
            }
        case .DateStyle_YearMonthDayHourMinute:
            var xArr: [CGFloat] = [105, 175, 230, 286, 341]
            if kScreenWidth > 400 {
                xArr = [120, 190, 245, 300, 355]
            }
            let textArr = ["年", "月", "日", "时", "分"]
            for index in 0..<xArr.count {
                createTagLab(xArr[index], textArr[index])
            }
        default:
            var xArr: [CGFloat] = [125, 215, 320]
            if kScreenWidth > 400 {
                xArr = [135, 230, 335]
            }
            let textArr = ["年", "月", "日"]
            for index in 0..<xArr.count {
                createTagLab(xArr[index], textArr[index])
            }
        }
        
    }
    
    private func createTagLab(_ x: CGFloat, _ title: String) {
        let label = UILabel.init(frame: .init(x: x, y: 98, width: 20, height: 20))
        label.text = title
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        pickerView.addSubview(label)
    }
    
    @objc private func clickCancelButton() {
        removeFromSuperview()
    }
    
    @objc private func clickConfirmButton() {
        pickerModel.year = yearsArr[yearIndex]
        pickerModel.month = monthsArr[monthIndex]
        pickerModel.day = daysArr[dayIndex]
        pickerModel.hour = hoursArr[hourIndex]
        pickerModel.minute = minutesArr[minuteIndex]
        pickerBlock!(pickerModel)
        if isShowConfirmBtn {
            removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromSuperview()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

public extension YWDatePickerView: UIPickerViewDataSource {
    private func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerStyle {
            case .DateStyle_YearMonth, .DateStyle_HourMinute:
                return 2
            case .DateStyle_YearMonthDay:
                return 3
            case .DateStyle_YearMonthDayHourMinute:
                return 5
        }
    }
    
    private func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerStyle {
            case .DateStyle_YearMonth:
                if component == 0 {
                    return yearsArr.count
                }
                if component == 1 {
                    return monthsArr.count
                }
            case .DateStyle_YearMonthDay:
                if component == 0 {
                    return yearsArr.count
                }
                if component == 1 {
                    return monthsArr.count
                }
                if component == 2 {
                    return daysArr.count
                }
            case .DateStyle_YearMonthDayHourMinute:
                if component == 0 {
                    return yearsArr.count
                }
                if component == 1 {
                    return monthsArr.count
                }
                if component == 2 {
                    return daysArr.count
                }
                if component == 3 {
                    return hoursArr.count
                }
                if component == 4 {
                    return minutesArr.count
                }
            case .DateStyle_HourMinute:
                if component == 0 {
                    return hoursArr.count
                }
                if component == 1 {
                    return minutesArr.count
                }
        }
        return 0
    }
}

public extension YWDatePickerView: UIPickerViewDelegate {
    private func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch pickerStyle {
        case .DateStyle_YearMonthDayHourMinute:
            if component == 0 { return 100 } else { return 50 }
        default:
            return 100
        }
    }
    
    private func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40
    }
    
    private func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var titleLab: UILabel
        if let label = view as? UILabel {
            titleLab = label
        } else {
            titleLab = UILabel()
            titleLab.textAlignment = .center
            titleLab.font = .systemFont(ofSize: 16)
        }
        
        titleLab.textColor = .black
        
        titleLab.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        
        
        
//        switch pickerStyle {
//        case .DateStyle_YearMonth:
//            if component == 0 {
//                if (Int(minPickerModel.year)! > row + 1970) || (Int(maxPickerModel.year)! < row + 1970) {
//                    titleLab.textColor = .red
//                } else {
//                    titleLab.textColor = .black
//                }
//            }
//
//        case
//        }
        
//        if component == 0, row == provinceIndex {
//            titleLab.textColor = kDominantColor
//        }
//        if component == 1, row == cityIndex {
//            titleLab.textColor = kDominantColor
//        }
//        if component == 2, row == districtIndex {
//            titleLab.textColor = kDominantColor
//        }
        
        return titleLab
    }
    
    private func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerStyle {
            case .DateStyle_YearMonth:
                if component == 0 {
                    return yearsArr[row]
                }
                if component == 1 {
                    return monthsArr[row]
                }
            case .DateStyle_YearMonthDay:
                if component == 0 {
                    return yearsArr[row]
                }
                if component == 1 {
                    return monthsArr[row]
                }
                if component == 2 {
                    return daysArr[row]
                }
            case .DateStyle_YearMonthDayHourMinute:
                if component == 0 {
                    return yearsArr[row]
                }
                if component == 1 {
                    return monthsArr[row]
                }
                if component == 2 {
                    return daysArr[row]
                }
                if component == 3 {
                    return hoursArr[row]
                }
                if component == 4 {
                    return minutesArr[row]
                }
            case .DateStyle_HourMinute:
                if component == 0 {
                    return hoursArr[row]
                }
                if component == 1 {
                    return minutesArr[row]
                }
        }
        return ""
    }
    
    private func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerStyle {
            case .DateStyle_YearMonth:
                if component == 0 {
                    yearIndex = row
                }
                if component == 1 {
                    monthIndex = row
                }
            case .DateStyle_YearMonthDay:
                if component == 0 {
                    yearIndex = row
                }
                if component == 1 {
                    monthIndex = row
                }
                if component == 2 {
                    dayIndex = row
                }
            case .DateStyle_YearMonthDayHourMinute:
                if component == 0 {
                    yearIndex = row
                }
                if component == 1 {
                    monthIndex = row
                }
                if component == 2 {
                    dayIndex = row
                }
                if component == 3 {
                    hourIndex = row
                }
                if component == 4 {
                    minuteIndex = row
                }
            case .DateStyle_HourMinute:
                if component == 0 {
                    hourIndex = row
                }
                if component == 1 {
                    minuteIndex = row
                }
        }
        
        if let date = minDate {
            let selectDate = String(format: "%@%@%@ %@%@", yearsArr[yearIndex], monthsArr[monthIndex], daysArr[dayIndex], hoursArr[hourIndex], minutesArr[minuteIndex]).yw.changeToDate("yyyyMMdd HHmm")
            if selectDate?.compare(date) == ComparisonResult.orderedAscending {
                scrollToTargetDate(date)
            }
        }
        if let date = maxDate {
            let selectDate = String(format: "%@%@%@ %@%@", yearsArr[yearIndex], monthsArr[monthIndex], daysArr[dayIndex], hoursArr[hourIndex], minutesArr[minuteIndex]).yw.changeToDate("yyyyMMdd HHmm")
            if selectDate?.compare(date) == ComparisonResult.orderedDescending {
                scrollToTargetDate(date)
            }
        }
        
        if !isShowConfirmBtn {
            clickConfirmButton()
        }
    }
}
