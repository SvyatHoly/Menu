//
//  ReusableView.swift
//  menu
//
//  Created by Serge Vysotsky on 05.06.2020.
//  Copyright © 2020 Svyatoslav Ivanov. All rights reserved.
//

import UIKit

protocol ReusableView where Self: UIView {
    static var viewReuseIdentifier: String { get }
    var viewReuseIdentifier: String { get }
}

extension ReusableView {
    static var viewReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: .punctuationCharacters).last!
    }
    
    var viewReuseIdentifier: String {
        Self.viewReuseIdentifier
    }
}

extension ReusableView where Self: UITableViewCell {
    static func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: viewReuseIdentifier, for: indexPath) as! Self
    }
}
