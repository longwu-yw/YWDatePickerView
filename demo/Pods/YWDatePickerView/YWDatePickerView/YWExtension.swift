//
//  YWDatePickerView.swift
//  YWDatePickerView
//
//  Created by YeWang on 2021/1/2.
//

import Foundation
import UIKit

struct YW<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol YWAvailable {}
extension YWAvailable {
    var yw: YW<Self> { set{} get{ YW(self) }}
    static var yw: YW<Self>.Type {
        set{}
        get{  YW<Self>.self }
    }
}

//MARK: String
extension String: YWAvailable {}

extension YW where Base: ExpressibleByStringLiteral {
    var inputStr: String {
        return base as! String
    }
    
    var isEmptyStr: Bool {
        if let myValue  = base as? String {
            return myValue == "" || myValue == "(null)" || myValue == "<null>" || 0 == myValue.count
        } else {
            return true
        }
    }
    
    func changeToDate(_ formatter: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.date(from: inputStr)
    }
    
}

//MARK: Date
extension Date: YWAvailable {}
extension YW where Base == Date {
    func changeToString(_ formatter: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: base)
    }
}


//MARK: UIButton
extension UIButton {
    
    static func create(frame: CGRect = .zero, title: String?, fontSize: CGFloat = 15, imageName: String?) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.frame = frame
        if title != .none {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: fontSize)
        }
        button.setTitleColor(.black, for: .normal)
        if imageName != nil {
            button.setImage(UIImage.init(named: imageName!), for: .normal)
        }
        return button
    }
}

//MARK: - UILabel
extension UILabel {
    static func create(frame: CGRect = .zero, title: String, fontSize: CGFloat, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel.init(frame: frame)
        label.text = title
        label.textColor = .black
        label.font = .systemFont(ofSize: fontSize)
        label.textAlignment = alignment
        return label
    }
}
