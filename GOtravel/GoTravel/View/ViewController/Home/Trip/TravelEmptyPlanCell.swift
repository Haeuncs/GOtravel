//
//  TravelEmptyPlanCell.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/24.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - 데이터가 없는 날짜의 테이블 뷰 셀
class TravelEmptyPlanCell: UITableViewCell {
    static let reuseIdentifier = "TravelEmptyPlanCell"

    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
        return view
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "🏷 일정이 없어요"
        label.textAlignment = .center
        label.font = .sb11
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("추가", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .sb17
        button.tintColor = .white
        button.backgroundColor = .greyishTeal
        button.layer.cornerRadius = 8
        button.layer.zeplinStyleShadows(color: .greyishTeal, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView() {
        contentView.addSubview(view)
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)

        view.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
        stackView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
}
