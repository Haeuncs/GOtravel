//
//  PullUpPopupViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/25.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

class PullUpPopupViewController: UIViewController {
    private enum Style {
        enum Table {
            static let rowHeight: CGFloat = 40
            static let spacing: CGFloat = 5
        }
    }

    private let impact = UIImpactFeedbackGenerator()
    private var tableViewHeightConstrants: NSLayoutConstraint?
    private let pullUpDatas: [PullUpPopupDataType]

    var originPopup: CGFloat = 0

    lazy var lineImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "22")
        return view
    }()

    lazy var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .dim
        return view
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .b27
        return label
    }()

    lazy var dataTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(PullUpPopupCell.self, forCellReuseIdentifier: PullUpPopupCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    init(title: String, pullUpDatas: [PullUpPopupDataType]) {
        self.pullUpDatas = pullUpDatas
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimGesture))
        dimView.addGestureRecognizer(tapGesture)

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(gestureEvent))
        contentView.addGestureRecognizer(gesture)

        let allSpacing: CGFloat = Style.Table.spacing * CGFloat((pullUpDatas.count - 1))
        let allCellHeight: CGFloat = Style.Table.rowHeight * CGFloat((pullUpDatas.count))
        tableViewHeightConstrants = dataTableView.heightAnchor.constraint(equalToConstant: allSpacing + allCellHeight)
        tableViewHeightConstrants?.isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: 0, height: 0)
        UIView.animate(withDuration: 0.33, animations: {
            self.contentView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      originPopup = contentView.frame.minY
    }

    func configureLayout() {
        view.addSubview(dimView)
        view.addSubview(contentView)
        contentView.addSubview(lineImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dataTableView)

        dimView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view)
        }
        contentView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        lineImageView.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(4)
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(12)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineImageView.snp.bottom).offset(12)
            make.trailing.equalTo(contentView)
            make.leading.equalTo(contentView.snp.leading).offset(18)
        }
        dataTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(18)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-12)
        }
    }

    @objc func dimGesture() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func gestureEvent(gesture: UIPanGestureRecognizer) {
      let touchPoint = gesture.location(in: contentView)

      var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
      if gesture.state == .began {
        initialTouchPoint = touchPoint
        print(initialTouchPoint)
      }
      if gesture.state == .changed {
        let y = (touchPoint.y - initialTouchPoint.y)
        if (touchPoint.y - initialTouchPoint.y > 0 ){
          UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame = CGRect(x: 16, y: self.contentView.frame.minY + y,
                                            width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
          })
        }else{
          UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame = CGRect(x: 16, y: self.contentView.frame.minY + y,
                                            width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
          })
        }
      }
      if gesture.state == .ended {
        let velocity = gesture.velocity(in: contentView)
        if velocity.y > 300{
          self.dismiss(animated: true, completion: {
          })
        }else{
          UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame = CGRect(x: 16, y: self.originPopup,
                                            width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
          })
        }
      }
    }
}

extension PullUpPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return pullUpDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PullUpPopupCell.reuseIdentifier, for: indexPath) as? PullUpPopupCell else {
            return UITableViewCell()
        }
        let data = pullUpDatas[indexPath.section]
        cell.configure(image: data.image, title: data.title)
        return cell
    }
}

extension PullUpPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Style.Table.spacing
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentData = pullUpDatas[indexPath.section]

        dismiss(animated: true, completion: {
            currentData.handler()
        })
    }
}
