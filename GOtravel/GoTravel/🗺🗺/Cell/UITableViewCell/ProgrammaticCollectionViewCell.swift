
import UIKit

class ProgrammaticCollectionViewCell: UICollectionViewCell {
  
  let countryLabel = UILabel()
  let cityLabel = UILabel()
  let ddayLabel = UILabel()
  
  let mainStackView = UIStackView()
  let subStackView = UIStackView()
  
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
    
    contentView.layer.cornerRadius = 10
    contentView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    
    mainStackView.distribution = .fillEqually
    mainStackView.alignment = .fill
    mainStackView.axis = .vertical
    
    subStackView.distribution = .fillEqually
    subStackView.alignment = .fill
    subStackView.axis = .vertical
    
    countryLabel.textAlignment = .left
    countryLabel.text = "일본 여행"
    countryLabel.textColor = .white
    
    cityLabel.textAlignment = .left
    cityLabel.text = "오사카"
    cityLabel.textColor = .white
    
    ddayLabel.textAlignment = .right
    ddayLabel.text = "D-100"
    ddayLabel.textColor = .white
    
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
    
    
    
    contentView.addSubview(mainStackView)
    
    mainStackView.addArrangedSubview(subStackView)
    mainStackView.addArrangedSubview(ddayLabel)
    
    subStackView.addArrangedSubview(countryLabel)
    subStackView.addArrangedSubview(cityLabel)
    
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:10),
      mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      ])
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
}
