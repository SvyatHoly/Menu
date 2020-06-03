//
//  MenuExtesions.swift
//  ARMA
//
//  Created by Svyatoslav Ivanov on 12.04.2020.
//  Copyright © 2020 ARMA. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension FloatingPoint {

    func project(initialVelocity: Self, decelerationRate: Self) -> Self {
        if decelerationRate >= 1 {
            assert(false)
            return self
        }
        
        return self + initialVelocity * decelerationRate / (1 - decelerationRate)
    }
}

extension CGPoint {
    
    func project(initialVelocity: CGPoint, decelerationRate: CGPoint) -> CGPoint {
        let xProjection = x.project(initialVelocity: initialVelocity.x, decelerationRate: decelerationRate.x)
        let yProjection = y.project(initialVelocity: initialVelocity.y, decelerationRate: decelerationRate.y)
        return CGPoint(x: xProjection, y: yProjection)
    }
    
    func project(initialVelocity: CGPoint, decelerationRate: CGFloat) -> CGPoint {
        return project(initialVelocity: initialVelocity, decelerationRate: CGPoint(x: decelerationRate, y: decelerationRate))
    }
}

struct TableCellInfo {
    var text: NSMutableAttributedString
    var description: NSMutableAttributedString
    var height: CGFloat
    var bgColor: UIColor
}

extension CustomTableCell {
    func update(with info: TableCellInfo, rowHeight: CGFloat, rowWidth: CGFloat, indexPath: Int) {
        infoNameLabel.attributedText = info.text
        infoNameLabel.frame = CGRect(x: rowWidth * 0.2, y: rowHeight * 0.33, width: rowWidth * 0.6, height: rowHeight * 0.15)
        descriptionLabel.attributedText = info.description
        descriptionLabel.frame = CGRect(x: rowWidth * 0.2, y: rowHeight * 0.45, width: rowWidth * 0.6, height: rowHeight * 0.15)
        topSeparator.frame = CGRect(x: rowWidth * 0.3, y: rowHeight * 0.3, width: rowWidth * 0.4, height: 1)
        bottomSeparator.frame = CGRect(x: rowWidth * 0.3, y: rowHeight * 0.65, width: rowWidth * 0.4, height: 1)
        switch Static.recognizeModel() {
        case .iphone6, .iphone7, .iphone8:
            topSeparator.frame = CGRect(x: rowWidth * 0.3, y: rowHeight * 0.33, width: rowWidth * 0.4, height: 1)
            bottomSeparator.frame = CGRect(x: rowWidth * 0.3, y: rowHeight * 0.6, width: rowWidth * 0.4, height: 1)
            break
        default: break
        }
        if indexPath == 0 && info.text.string == "" {
            topSeparator.removeFromSuperview()
            bottomSeparator.removeFromSuperview()
        }
        backgroundColor = UIColor.clear.withAlphaComponent(0)

    }
}

class UIButtonWithParams: UIButton {
    var name: String = ""
    var id: String = ""
    var descriptionText: String = ""

}

extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
