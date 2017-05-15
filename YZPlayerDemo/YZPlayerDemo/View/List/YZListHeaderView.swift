//
//  YZListHeaderView.swift
//  YZPlayerDemo
//
//  Created by heyuze on 2017/5/12.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

class YZListHeaderView: UITableViewHeaderFooterView {

    
    // MARK: - init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        setupData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Set up
    
    private func setupUI() {
//        backgroundColor = WHITE
        contentView.backgroundColor = WHITE
        
        let containerView = UIView()
        containerView.backgroundColor = WHITE
        contentView.addSubview(containerView)
        
        containerView.addSubview(timeLabel)
        containerView.addSubview(midLine)
        containerView.addSubview(titleLabel)
        
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView)
            make.centerY.equalTo(containerView)
        }
        midLine.snp.makeConstraints { (make) in
            make.leading.equalTo(timeLabel.snp.trailing).offset(7)
            make.centerY.equalTo(containerView)
            make.height.equalTo(12)
            make.width.equalTo(2)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(midLine.snp.trailing).offset(7)
            make.centerY.equalTo(containerView)
            make.trailing.equalTo(containerView)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(timeLabel)
            make.trailing.equalTo(titleLabel)
            make.height.equalTo(15)
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
    }
    
    private func setupData() {
        timeLabel.text = getTimeStr()
    }
    
    
    
    // MARK: - Func
    
    private func getTimeStr() -> String {
        let calendar = Calendar.current
        let com = (calendar as NSCalendar).components([.month, .day], from: Date())
        let month = com.month
        let day = com.day
        let monthStr = getMonthStr(month: month!)
        let timeStr = String.init(format: "%@%02d", arguments: [monthStr, day!])
        return timeStr
    }
    
    private func getMonthStr(month: Int) -> String {
        switch month {
        case 1:
            return "Jan."
        case 2:
            return "Feb."
        case 3:
            return "Mar."
        case 4:
            return "Apr."
        case 5:
            return "May."
        case 6:
            return "Jun."
        case 7:
            return "Jul."
        case 8:
            return "Aug."
        case 9:
            return "Sep."
        case 10:
            return "Oct."
        case 11:
            return "Nov."
        case 12:
            return "Dec."
        default:
            return ""
        }
    }
    
    
    
    // MARK: - Lazy Load
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel(text: "Nov.07", textColor: BLACK, fontSize: 15)
        timeLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
        return timeLabel
    }()
    
    private lazy var midLine: UIView = {
        let midLine = UIView()
        midLine.backgroundColor = BLACK
        return midLine
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(text: "24小时精选", textColor: BLACK, fontSize: 15)
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
        return titleLabel
    }()
    
}
