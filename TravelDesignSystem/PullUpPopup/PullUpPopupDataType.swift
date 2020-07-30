//
//  PullUpPopupDataType.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/25.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit

public struct PullUpPopupDataType {
    private(set) var handler: (() -> Void)
    private(set) var image: UIImage
    private(set) var title: String
    init(
        image: UIImage,
        title: String,
        handler: @escaping (() -> Void)
    ) {
        self.image = image
        self.title = title
        self.handler = handler
    }
}
