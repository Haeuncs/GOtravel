//
//  PullUpPopupCell.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/25.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

class PullUpPopupCell: UITableViewCell {
    static let reuseIdentifier = String(describing: PullUpPopupCell.self)
    
    enum Style {
        enum ImageView {
            static let width: CGFloat = 28
        }
        enum TitleLabel {
            static let left: CGFloat = 18
            static let font = UIFont.m18
            static let color = UIColor.black
        }
    }
    lazy var imageView_: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .m18
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, title: String) {
        imageView_.image = image
        titleLabel.text = title
    }
    
    func configureLayout() {
        contentView.addSubview(imageView_)
        contentView.addSubview(titleLabel)
        
        imageView_.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView_.snp.trailing).offset(Style.TitleLabel.left)
            make.centerY.equalTo(contentView)
            make.trailing.lessThanOrEqualTo(contentView)
        }
    }
}
