//
//  AccentButton.swift
//  TravelDesignSystem
//
//  Created by LEE HAEUN on 2020/07/27.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

public class AccentButton: UIButton {
    public init(
        title: String,
        font: UIFont = .b26,
        backgroundColor: UIColor = .turquoiseBlue
    ) {
        super.init(frame: .zero)
        titleLabel?.textColor = .white
        setTitle(title, for: .normal)
        titleLabel?.font = font
        self.backgroundColor = backgroundColor
        layer.zeplinStyleShadows(
            color: backgroundColor,
            alpha: 0.16,
            x: 0,
            y: 6,
            blur: 6,
            spread: 0
        )

        configureLayout()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        layer.cornerRadius = 8
        titleLabel?.snp.makeConstraints({ (make) in
            make.centerX.centerX.equalTo(self)
            make.top.equalTo(13)
            make.bottom.equalTo(-13)
        })
    }
}
