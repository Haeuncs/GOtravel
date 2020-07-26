//
//  DirectAddTripCostCategoryCell.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/26.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

class DirectAddTripCostCategoryCell: UICollectionViewCell {

    override var isSelected: Bool {
        didSet {
            if isSelected {
                containerView.layer.borderWidth = 2
                containerView.layer.borderColor = containerView.backgroundColor?.darker().cgColor
            } else {
                containerView.layer.borderWidth = 0
            }
        }
    }

    static let reuseIdentifier = String(describing: DirectAddTripCostCategoryCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        let randomColor = UIColor().HSBrandomColor()
        containerView.backgroundColor = randomColor
        containerView.layer.zeplinStyleShadows(
            color: randomColor,
            alpha: 1,
            x: 0,
            y: 3,
            blur: 6,
            spread: 0
        )
        containerView.layer.cornerRadius = 16
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)

        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(contentView)
            make.top.equalTo(contentView).offset(7)
            make.bottom.equalTo(contentView).offset(-7)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerView).offset(10)
            make.bottom.equalTo(containerView).offset(-10)
            make.leading.equalTo(containerView).offset(28)
            make.trailing.equalTo(containerView).offset(-28)
        }
    }

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .sb14
        return label
    }()
}
