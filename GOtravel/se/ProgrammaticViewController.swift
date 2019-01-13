//
//  ViewController.swift
//  Example
//
//  Created by Benjamin Emdon on 2016-12-28.
//  Copyright © 2016 Benjamin Emdon.
//

import UIKit
import CenteredCollectionView

class ProgrammaticViewController: UIViewController {
    @IBOutlet weak var subView: UIView!
    
	let centeredCollectionViewFlowLayout = CenteredCollectionViewFlowLayout()
    var collectionView: UICollectionView!

	let controlCenter = ControlCenterView()
	let cellPercentWidth: CGFloat = 0.8
	var scrollToEdgeEnabled = false

//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        collectionView = UICollectionView(centeredCollectionViewFlowLayout: centeredCollectionViewFlowLayout)
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false

    }
	override func viewDidLoad() {
		super.viewDidLoad()
         self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
        print(self.tabBarController?.tabBar.isHidden)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationItem.title = "일정"
        title = self.navigationItem.title
        
        collectionView = UICollectionView(centeredCollectionViewFlowLayout: centeredCollectionViewFlowLayout)
		// Just to make the example pretty ✨
		collectionView.backgroundColor = UIColor.clear
		subView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
		// delegate & data source
		controlCenter.delegate = self
		collectionView.delegate = self
		collectionView.dataSource = self

		// layout subviews
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.addArrangedSubview(collectionView)
//        stackView.addArrangedSubview(controlCenter)
		subView.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            stackView.topAnchor.constraint(equalTo: view.topAnchor),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            stackView.widthAnchor.constraint(equalToConstant: self.subView.frame.width),
            stackView.heightAnchor.constraint(equalToConstant: self.subView.frame.height/2),
            stackView.centerXAnchor.constraint(equalTo: self.subView.centerXAnchor),
//            stackView.topAnchor.constraint(equalTo: self.subView.topAnchor, constant: 10)
            stackView.centerYAnchor.constraint(equalTo: self.subView.centerYAnchor),

			])
//        stackView.heightAnchor.constraint(equalToConstant: 88).isActive = true

		// register collection cells
		collectionView.register(
			ProgrammaticCollectionViewCell.self,
			forCellWithReuseIdentifier: String(describing: ProgrammaticCollectionViewCell.self)
		)

		// configure layout
		centeredCollectionViewFlowLayout.itemSize = CGSize(
			width: subView.bounds.width * cellPercentWidth,
			height:self.subView.frame.height/2
		)
		centeredCollectionViewFlowLayout.minimumLineSpacing = 20
		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false
        print(self.tabBarController?.tabBar.isHidden)

	}
}

extension ProgrammaticViewController: ControlCenterViewDelegate {
    func stateChanged(scrollDirection: UICollectionView.ScrollDirection) {
		centeredCollectionViewFlowLayout.scrollDirection = scrollDirection
	}

	func stateChanged(scrollToEdgeEnabled: Bool) {
		self.scrollToEdgeEnabled = scrollToEdgeEnabled
	}
}

extension ProgrammaticViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Selected Cell #\(indexPath.row)")
		if scrollToEdgeEnabled,
			let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage,
			currentCenteredPage != indexPath.row {
			centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.row, animated: true)
		}
	}
}

extension ProgrammaticViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 6
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgrammaticCollectionViewCell.self), for: indexPath) as! ProgrammaticCollectionViewCell
		cell.titleLabel.text = "Cell #\(indexPath.row)"
		return cell
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
	}

	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
	}
}
