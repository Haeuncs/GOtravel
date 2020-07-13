
import UIKit

class TripCell: UICollectionViewCell {
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()

  }
//  let countryLabel = UILabel()
//  let cityLabel = UILabel()
//  let ddayLabel = UILabel()
  lazy var countryLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var cityLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var ddayLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var ddayView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var planeImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "plane")
    image.alpha = 0
    image.contentMode = .scaleAspectFit
    return image
  }()
  let mainStackView = UIStackView()
  let subStackView = UIStackView()
  
  lazy var mainBackgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 10
    return view
  }()
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  func configure(withDelegate delegate: mainVC_protocol){
    countryLabel.text = delegate.countryTitle
    cityLabel.text = delegate.cityTitle
    ddayLabel.text = delegate.ddayTitle
  }
  
  func initView(){
    mainStackView.distribution = .fillEqually
    mainStackView.alignment = .fill
    mainStackView.axis = .vertical
    
    subStackView.distribution = .fillEqually
    subStackView.alignment = .fill
    subStackView.axis = .vertical
    
    countryLabel.textAlignment = .left
//    countryLabel.text = "일본 여행"
//    countryLabel.textColor = .white
//
    cityLabel.textAlignment = .left
//    cityLabel.text = "오사카"
//    cityLabel.textColor = .white
//
    ddayLabel.textAlignment = .right
//    ddayLabel.text = "D-100"
//    ddayLabel.textColor = .white
//
    ddayLabel.adjustsFontSizeToFitWidth = true
    ddayLabel.numberOfLines = 1
    ddayLabel.minimumScaleFactor = 0.1
    ddayLabel.font = UIFont.systemFont(ofSize: 160, weight: .bold)
    ddayLabel.translatesAutoresizingMaskIntoConstraints = false

    ddayLabel.font = ddayLabel.font.withSize (50)

    cityLabel.adjustsFontSizeToFitWidth = true
    cityLabel.numberOfLines = 1
    cityLabel.minimumScaleFactor = 0.1
    cityLabel.font = UIFont.systemFont(ofSize: 160, weight: .bold)
    cityLabel.translatesAutoresizingMaskIntoConstraints = false

    cityLabel.font = ddayLabel.font.withSize (25)

    countryLabel.adjustsFontSizeToFitWidth = true
    countryLabel.numberOfLines = 1
    countryLabel.minimumScaleFactor = 0.1
    countryLabel.font = UIFont.systemFont(ofSize: 160, weight: .bold)
    countryLabel.translatesAutoresizingMaskIntoConstraints = false

    countryLabel.font = ddayLabel.font.withSize (30)
    
    contentView.addSubview(mainBackgroundView)
    
    mainBackgroundView.addSubview(mainStackView)
    
    mainStackView.addArrangedSubview(subStackView)
    mainStackView.addArrangedSubview(ddayView)
    
    ddayView.addSubview(ddayLabel)
    ddayView.addSubview(planeImageView)

    subStackView.addArrangedSubview(countryLabel)
    subStackView.addArrangedSubview(cityLabel)
    
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    mainBackgroundView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top).offset(50)
      make.left.equalTo(contentView.snp.left).offset(20)
      make.right.equalTo(contentView.snp.right).offset(-20)
      make.centerY.equalTo(contentView.snp.centerY)
      make.bottom.equalTo(contentView.snp.bottom).offset(-50)
    }
    mainStackView.snp.makeConstraints { (make) in
      make.top.equalTo(mainBackgroundView.snp.top).offset(20)
      make.left.equalTo(mainBackgroundView.snp.left).offset(20)
      make.right.equalTo(mainBackgroundView.snp.right).offset(-20)
      make.bottom.equalTo(mainBackgroundView.snp.bottom).offset(-20)
    }
    ddayLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(ddayView.snp.centerY)
      make.left.greaterThanOrEqualTo(ddayView.snp.left)
      make.right.equalTo(ddayView.snp.right)
    }
    planeImageView.snp.makeConstraints { (make) in
//      make.top.equalTo(ddayView.snp.top).offset(20)
//      make.bottom.equalTo(ddayView.snp.bottom).offset(-20)
      make.width.equalTo(60)
      make.height.equalTo(60)
      make.centerY.equalTo(ddayView.snp.centerY)
      make.left.equalTo(ddayView.snp.left)
      
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
}
