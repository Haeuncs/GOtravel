//
//  exchangeViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 17/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

//import Foundation
//import UIKit
//
//class exchangeViewController : UIViewController {
//    override func viewDidLoad() {
//
//    }
//    override func viewWillAppear(_ animated: Bool) {
//
//    }
//}
import UIKit


class noNibCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    var collectionview: UICollectionView!
    var cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of UICollectionViewFlowLayout since you cant
        // Initialize UICollectionView without a layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 700)
        
        collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(FreelancerCell.self, forCellWithReuseIdentifier: cellId)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        self.view.addSubview(collectionview)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FreelancerCell
        return cell
    }
    
    
}








class FreelancerCell: UICollectionViewCell {
    
    
    let profileImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.setImage(UIImage(named: "Profile"), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.text = "Bob Lee"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "30000 miles"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pricePerHourLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "$40/hour"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "4.9+"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let showCaseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage(named: "Profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "424 likes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Like", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let hireButton: UIButton = {
        let button = UIButton()
        button.setTitle("Hire", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let messageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Message", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    
    
    
    func addViews(){
        backgroundColor = UIColor.black
        
        addSubview(profileImageButton)
        addSubview(nameLabel)
        addSubview(distanceLabel)
        addSubview(pricePerHourLabel)
        addSubview(ratingLabel)
        addSubview(showCaseImageView)
        addSubview(likesLabel)
        
        addSubview(topSeparatorView)
        addSubview(bottomSeparatorView)
        
        // Stack View
        addSubview(likeButton)
        addSubview(messageButton)
        addSubview(hireButton)
        addSubview(stackView)
        
        
        profileImageButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        profileImageButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageButton.rightAnchor, constant: 5).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor, constant: -8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: pricePerHourLabel.leftAnchor).isActive = true
        
        distanceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor, constant: 8).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: 300)
        
        pricePerHourLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        pricePerHourLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        
        // Distance depeneded on the priceLabel and distance Label
        ratingLabel.rightAnchor.constraint(equalTo: pricePerHourLabel.rightAnchor).isActive = true
        ratingLabel.centerYAnchor.constraint(equalTo: distanceLabel.centerYAnchor).isActive = true
        
        showCaseImageView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 10).isActive = true
        showCaseImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        showCaseImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        
        likesLabel.topAnchor.constraint(equalTo: showCaseImageView.bottomAnchor, constant: 10).isActive = true
        likesLabel.leftAnchor.constraint(equalTo: profileImageButton.leftAnchor).isActive = true
        
        topSeparatorView.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 10).isActive = true
        topSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(hireButton)
        stackView.addArrangedSubview(messageButton)
        
        stackView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 4).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bottomSeparatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4).isActive = true
        bottomSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
