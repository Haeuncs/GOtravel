
import UIKit
import CenteredCollectionView

import EasyTipView

//FIXIT : 클릭하면 이동하는거 index row 기준 아니고 데이터 자체를 이동하기
class HomeViewController: UIViewController {
  weak var tipView: EasyTipView?

  @IBOutlet weak var testView: UINavigationItem!
  @IBOutlet weak var navView: UIBarButtonItem!
  //    @IBOutlet weak var subView: UIView!
  let selection = UISelectionFeedbackGenerator()
  let notification = UINotificationFeedbackGenerator()
  
  let centeredCollectionViewFlowLayout = CenteredCollectionViewFlowLayout()
  var collectionView: UICollectionView!
  
  let controlCenter = ControlCenterView()
  let cellPercentWidth: CGFloat = 0.8
  var scrollToEdgeEnabled = false
  
  var myBackgroundColor: UIColor?
  let realm = try? Realm()
  // 기본 저장 데이터
  var countryRealmDB: List<countryRealm>?
  
  @IBAction func settingBtn(_ sender: Any) {
    let setting = SettingViewController()
    self.navigationController?.pushViewController(setting, animated: true)
    
  }
  @IBAction func addBtn(_ sender: Any) {
    let placeVC = AddTripViewController()
    placeVC.categoryIndex = 1
    self.navigationController?.pushViewController(placeVC, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    initView()
    attribute()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let customTabBarController = self.tabBarController as? TabbarViewController {
      customTabBarController.hideTabBarAnimated(hide: false, completion: nil)
      customTabBarController.setSelectLine(index: 0)
    }

    DispatchQueue.main.async {
      self.collectionView.reloadData()
      self.collectionView!.collectionViewLayout.invalidateLayout()
      self.collectionView!.layoutSubviews()
    }
    // realm 데이터 정렬 ascending 오름차순 정렬 (dday가 적게 남은 순으로 정렬한다.)
    
    countryRealmDB = processingDateData()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if realm?.objects(countryRealm.self).count == 0 ||
      realm?.objects(countryRealm.self).count == nil{
      var preferences = EasyTipView.Preferences()
      preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
      preferences.drawing.foregroundColor = UIColor.white
      preferences.drawing.backgroundColor = UIColor.black
      EasyTipView.globalPreferences = preferences
      self.view.backgroundColor = UIColor(hue: 0.75, saturation: 0.01, brightness: 0.96, alpha: 1.00)
      let text = "이 버튼을 눌러서 여행할 도시를\n입력하세요! 😆"
      //    tipView.show(animated: true, forItem: self.navView, withinSuperView: nil)
      let tip = EasyTipView(text: text, preferences: preferences, delegate: self)
      tip.show(animated: true, forItem: self.navView, withinSuperView: self.navigationController?.view)
      tipView = tip
    }
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let tip = tipView {
      tip.dismiss()
    }
  }
  func attribute(){
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Defaull_style.mainTitleColor]
    self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
    self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
//    navigationController?.navigationBar.barStyle = Defaull_style.mainTitleColor.cgColor
    navigationController?.navigationBar.tintColor = Defaull_style.mainTitleColor

    self.navigationItem.title = "여행일정"
    title = self.navigationItem.title
  }
  func processingDateData() -> List<countryRealm>{
    let processedData = List<countryRealm>()
    
    // 1. load
    var countryRealmDB = realm?.objects(countryRealm.self)
    countryRealmDB = countryRealmDB?.sorted(byKeyPath: "date", ascending: true)
    // 2. processing
    if let countryRealmDB = countryRealmDB {
      for i in countryRealmDB {
        let startDay = i.date ?? Date()
        let endDate = Calendar.current.date(byAdding: .day, value: i.period, to: startDay)
        if endDate ?? Date() > Date() {
          processedData.append(i)
        }
      }
    }
    print(processedData.count)
    return processedData
  }
  lazy var guideView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}
extension HomeViewController: EasyTipViewDelegate{
  func easyTipViewDidDismiss(_ tipView: EasyTipView) {
    print("\(tipView) did dismiss!")
  }
}
extension HomeViewController: ControlCenterViewDelegate {
  func stateChanged(scrollDirection: UICollectionView.ScrollDirection) {
    centeredCollectionViewFlowLayout.scrollDirection = scrollDirection
  }
  
  func stateChanged(scrollToEdgeEnabled: Bool) {
    self.scrollToEdgeEnabled = scrollToEdgeEnabled
    
  }
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    notification.notificationOccurred(.success)
    UIView.animate(withDuration: 0.3) {
      if let cell = collectionView.cellForItem(at: indexPath) as? TripCell {
        cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
      }
    }
    
    let nav1 = UINavigationController()
    let detailView = TripDetailViewController()
    nav1.viewControllers = [detailView]
    
    if let countryRealmDB = countryRealmDB {
      detailView.countryRealmDB = countryRealmDB[indexPath.row]
    }
    
    self.present(nav1, animated: true, completion: nil)
  }
  
}

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return countryRealmDB?.count ?? 0
  }
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    UIView.animate(withDuration: 0.3) {
      if let cell = collectionView.cellForItem(at: indexPath) as? TripCell {
        cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    UIView.animate(withDuration: 0.3) {
      if let cell = collectionView.cellForItem(at: indexPath) as? TripCell {
        cell.contentView.transform = .identity
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TripCell.self), for: indexPath) as! TripCell
    cell.configure(withDelegate: mainVC_CVC_ViewModel(countryRealmDB![indexPath.row]))
    print(countryRealmDB![indexPath.row])
    cell.contentView.transform = .identity
    // random color 를 cell의 background
    cell.contentView.backgroundColor = HSBrandomColor()
    
    return cell
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    print("Current centered index1: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    print("Current centered index2: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
  }
}
// hsb random color
func HSBrandomColor() -> UIColor{
  let saturation: CGFloat = 0.45
  let brigtness: CGFloat = 0.85
  let randomHue = CGFloat.random(in: 0.0..<1.0)
  //        print(UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1))
  return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
}

extension HomeViewController {
  func initView(){
    collectionView = UICollectionView(centeredCollectionViewFlowLayout: centeredCollectionViewFlowLayout)
    collectionView.backgroundColor = .clear
    // delegate & data source
    controlCenter.delegate = self
    collectionView.delegate = self
    collectionView.dataSource = self
    
    // layout subviews
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.addArrangedSubview(collectionView)
//    view.addSubview(stackView)
    view.addSubview(guideView)
    guideView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      guideView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      guideView.leftAnchor.constraint(equalTo: view.leftAnchor),
      guideView.rightAnchor.constraint(equalTo: view.rightAnchor),
      guideView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      stackView.widthAnchor.constraint(equalToConstant: view.frame.width),
      stackView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
      stackView.centerXAnchor.constraint(equalTo: guideView.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: guideView.centerYAnchor),
      
      ])
    // register collection cells
    collectionView.register(
      TripCell.self,
      forCellWithReuseIdentifier: String(describing: TripCell.self)
    )
    
    // configure layout
    centeredCollectionViewFlowLayout.itemSize = CGSize(
      width: self.view.bounds.width * cellPercentWidth,
      height: self.view.bounds.height / 2
    )
    centeredCollectionViewFlowLayout.minimumLineSpacing = 20
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    
    self.navigationController?.navigationBar.isHidden = false
    self.tabBarController?.tabBar.isHidden = false
    
    //        countryRealmDB = realm?.objects(countryRealm.self)
    //        countryRealmDB = countryRealmDB?.sorted(byKeyPath: "date", ascending: true)
  }
}
