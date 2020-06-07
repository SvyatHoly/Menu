//
//  DesignableView.swift
//  menu
//
//  Created by Serge Vysotsky on 05.06.2020.
//  Copyright © 2020 Svyatoslav Ivanov. All rights reserved.
//

import UIKit

@IBDesignable
final class DesignableView: UIView {
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { layer.borderWidth }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor }
        get { layer.borderColor.map(UIColor.init) }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { layer.cornerRadius }
    }
    
    @IBInspectable var isRound: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRound {
            cornerRadius = min(frame.width, frame.height) / 2
        }
    }
}
