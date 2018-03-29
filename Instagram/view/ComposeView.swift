//
//  ComposeView.swift
//  Instagram
//
//  Created by tiago henrique on 26/03/2018.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import UIKit

class ComposeView: UIView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = window {
                bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
}
