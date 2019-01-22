//
//  addDetailTableViewCellInsideTableViewCell.swift
//  GOtravel
//
//  Created by OOPSLA on 17/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
class addDetailTableViewCellInsideTableViewCell : UITableViewCell{
    var timeLabelIsHidden : Bool = true
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        print("sub test style")
        contentView.backgroundColor = .white
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView(){
        
        
        if timeLabelIsHidden == false{
            stackView.addArrangedSubview(timeLabel)
            stackView.addArrangedSubview(titleLabel)
            }else{
            //  hidden 이 true이면
            stackView.addArrangedSubview(titleLabel)
        }
//        mainView.addSubview(timeLabel)
//        mainView.addSubview(titleLabel)
//        contentView.addSubview(mainView)
        contentView.addSubview(stackView)
        contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor,constant:5),
            colorView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:10),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant:-5),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:25),
//            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            mainView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
//            mainView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            mainView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
//            timeLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
////            timeLabel.topAnchor.constraint(equalTo: mainView.topAnchor),
//            timeLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
//            timeLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
//
//            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
//            titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            ])
    }
    let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    lazy var colorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var mainView : UIView = {
        let view = UIView()
//        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
//        label.backgroundColor = .blue
//        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.numberOfLines = 0
//        label.backgroundColor = .red

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}
