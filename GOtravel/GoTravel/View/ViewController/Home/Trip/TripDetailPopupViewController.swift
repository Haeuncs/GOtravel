//
//  TripDetailPopupViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/24.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TripDetailPopupViewController: UIViewController {
  var disposeBag = DisposeBag()
  var originPopup : CGFloat = 0
  var originHeight : CGFloat = 0
  var originMinY: CGFloat = 0
  // 진동 feedbvar
  let impact = UIImpactFeedbackGenerator()

  var day: Int = 0
  
  weak var delegate: TripDetailDataPopupDelegate?

  func setup(_ realmDate: countryRealm, day: Int, delegate: TripDetailDataPopupDelegate) {
    print(realmDate)
    self.delegate = delegate
    self.day = day
    if let startDate = realmDate.date {
      let currentDate = Calendar.current.date(byAdding: .day, value: day, to: startDate)
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "ko-KR")
      dateFormatter.dateFormat = "M월 dd일 E요일"
      titleLabel.text = dateFormatter.string(from: currentDate!) + " \(day + 1)일차"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    setupGesture()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.contentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: view.frame.width, height: 600)
    UIView.animate(withDuration: 0.33, animations: {
      self.contentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 600, width: self.view.frame.width, height: 600)
    })
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    originHeight = contentView.frame.height
    originPopup = contentView.frame.minY
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    disposeBag = DisposeBag()
  }
  func initView(){
    
    view.addSubview(backGroundView)
    view.addSubview(contentView)
    contentView.addSubview(lineImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(stackView)
    
    backGroundView.snp.makeConstraints { (make) in
      make.top.equalTo(view.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.bottom.equalTo(view.snp.bottom)
    }
    
    contentView.snp.makeConstraints { (make) in
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
      make.trailing.equalTo(contentView)
      make.leading.equalTo(contentView.snp.leading).offset(18)
      make.bottom.equalTo(contentView).offset(-12)
    }
  }
  func setupGesture(){
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(gestureEvent))
    contentView.addGestureRecognizer(gesture)
    let directGesture = UITapGestureRecognizer(target: self, action: #selector(moneyDidTap))
    addMoney.addGestureRecognizer(directGesture)
    let photoGesture = UITapGestureRecognizer(target: self, action: #selector(scheduleDidTap))
    addSchedule.addGestureRecognizer(photoGesture)
    let backgoundGesture = UITapGestureRecognizer(target: self, action: #selector(pathDidTap))
    addPath.addGestureRecognizer(backgoundGesture)
  }
  lazy var stackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [addMoney, addSchedule, addPath])
    stack.isUserInteractionEnabled = true
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .equalSpacing
    stack.spacing = 5
    return stack
  }()
  lazy var lineImageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "22")
    return view
  }()

  lazy var addMoney: TripDetailPopupView = {
    let view = TripDetailPopupView()
    view.setup(image: UIImage(named: "atm")!, text: "경비 추가하기")
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var addSchedule: TripDetailPopupView = {
    let view = TripDetailPopupView()
    view.setup(image: UIImage(named: "pin")!, text: "일정 추가하기")
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var addPath: TripDetailPopupView = {
    let view = TripDetailPopupView()
    view.setup(image: UIImage(named: "route")!, text: "경로 보기")
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var backGroundView : UIView = {
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
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "일요일"
    label.font = .b27
    return label
  }()
}

extension TripDetailPopupViewController {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch : UITouch? = touches.first
    if touch?.view == backGroundView {
      self.dismiss(animated: true, completion: nil)
    }
  }
  @objc func moneyDidTap(){
    impact.impactOccurred()
    self.dismiss(animated: true) {
      self.delegate?.TripDetailDataPopupMoney(day: self.day)
    }
  }
  @objc func scheduleDidTap(){
    impact.impactOccurred()
    self.dismiss(animated: true) {
      self.delegate?.TripDetailDataPopupSchedule(day: self.day)
    }
  }
  @objc func pathDidTap(){
    impact.impactOccurred()
    self.dismiss(animated: true) {
      self.delegate?.TripDetailDataPopupPath(day: self.day)
    }
  }
  @objc func gestureEvent(gesture : UIPanGestureRecognizer) {
    let touchPoint = gesture.location(in: contentView)
    
    var initialTouchPoint :CGPoint = CGPoint(x: 0, y: 0)
    if gesture.state == .began {
      initialTouchPoint = touchPoint
      print(initialTouchPoint)
    }
    if gesture.state == .changed {
      let y = (touchPoint.y - initialTouchPoint.y)
      if (touchPoint.y - initialTouchPoint.y > 0 ){
        UIView.animate(withDuration: 0.3, animations: {
          self.contentView.frame = CGRect(x: 16, y:  self.contentView.frame.minY + y,
                                          width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        })
      }else{
        UIView.animate(withDuration: 0.3, animations: {
          self.contentView.frame = CGRect(x: 16, y:  self.contentView.frame.minY + y,
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
          self.contentView.frame = CGRect(x: 16, y:  self.originPopup,
                                          width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        })
      }
    }
  }
}

class TripDetailPopupView: UIView {
 override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(contentView)
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    
    contentView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(self)
      make.height.equalTo(40)
    }
    imageView.snp.makeConstraints { (make) in
      make.leading.centerY.equalTo(self)
      make.width.height.equalTo(28)
    }
    titleLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(imageView.snp.trailing).offset(18)
      make.centerY.equalTo(self)
      make.trailing.equalTo(self)
    }
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setup(image: UIImage,text: String) {
    imageView.image = image
    titleLabel.text = text
  }
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "atm")
    view.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    return view
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = .m18
    return label
  }()

}

