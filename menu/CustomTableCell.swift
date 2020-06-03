//
//  CustomTableCell.swift
//  ARMA
//
//  Created by Svyatoslav Ivanov on 12.04.2020.
//  Copyright © 2020 ARMA. All rights reserved.
//

import UIKit
class CustomTableCell : UITableViewCell {
    
    var info : TableCellInfo? {
        didSet {
            infoNameLabel.attributedText = info?.text
        }
    }
    
    let infoNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let topSeparator: UIView = {
        let topSeparator = UIView()
        topSeparator.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return topSeparator
    }()
    
    let bottomSeparator: UIView = {
        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return bottomSeparator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(infoNameLabel)
        addSubview(topSeparator)
        addSubview(bottomSeparator)
        addSubview(descriptionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
