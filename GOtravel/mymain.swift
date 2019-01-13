//
//  main.swift
//  GOtravel
//
//  Created by OOPSLA on 13/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit

class mymain: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dday: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit(){
        Bundle.main.loadNibNamed("mymain", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
}
