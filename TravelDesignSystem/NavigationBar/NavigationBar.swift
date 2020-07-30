//
//  NavigationBar.swift
//  TravelDesignSystem
//
//  Created by LEE HAEUN on 2020/07/27.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

public enum NavigationBarType {
    case dismiss
    case pop
}

public class NavigationBar: UIView {

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named: "close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public lazy var popButton: PopButton = {
        let button = PopButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public lazy var actionButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public init(
        type: NavigationBarType,
        popLabel: String? = nil,
        actionLabel: String? = nil
    ) {
        super.init(frame: .zero)

        switch type {
        case .dismiss:
            dismissButton.isHidden = false
        case .pop:
            popButton.isHidden = false
            if let label = popLabel {
                popButton.popLabel.text = label
            }
        }
        if let label = actionLabel {
            actionButton.isHidden = false
            actionButton.setTitle(label, for: .normal)
        }
        configureLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        self.addSubview(contentView)
        contentView.addSubview(dismissButton)
        contentView.addSubview(popButton)
        contentView.addSubview(actionButton)

        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(48)
        }

        dismissButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.leading.equalTo(contentView).offset(4)
            make.centerY.equalTo(contentView)
        }

        popButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }

        actionButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.trailing.equalTo(contentView.snp.trailing)
            make.leading.greaterThanOrEqualTo(contentView.snp.leading)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}

public class PopButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = false
        self.addSubview(contentView)
        contentView.addSubview(imageView_)
        contentView.addSubview(popLabel)

        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
        imageView_.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        popLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(imageView_.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)

        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        popLabel.text = title
    }

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var imageView_: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "back3X")
        return view
    }()

    lazy var popLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .b18
        return label
    }()

}
