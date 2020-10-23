//
//  UnderlineTextButton.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 23.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit

class UnderlineTextButton: UIButton {

    override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(title, for: .normal)
    self.setAttributedTitle(self.attributedString(), for: .normal)
}

private func attributedString() -> NSAttributedString? {
    let attributes : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0),
        NSAttributedString.Key.foregroundColor : UIColor.black,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
    ]
    let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
    return attributedString
  }
}
