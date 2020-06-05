//
//  RecordsViewController.swift
//  menu
//
//  Created by Serge Vysotsky on 05.06.2020.
//  Copyright © 2020 Svyatoslav Ivanov. All rights reserved.
//

import UIKit

final class RecordImageCell: UITableViewCell, ReusableView {
    @IBOutlet weak var recordImageView: UIImageView!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
}

final class RecordTitlesCell: UITableViewCell, ReusableView {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet var topLines: [UIView]!
    @IBOutlet var bottomLines: [UIView]!
}

final class RecordsViewController: UIViewController {
    @IBOutlet weak var recordsImagesTableView: UITableView!
    @IBOutlet weak var recordsTitlesTableView: UITableView!
    var menuItems = [MenuButtonType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems = Static.parseButtons() + Static.parseButtons() + Static.parseButtons() + Static.parseButtons()
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === recordsImagesTableView {
            return menuItems.count
        } else if tableView === recordsTitlesTableView {
            return max(menuItems.count - 1, 0)
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === recordsImagesTableView {
            let imageCell = RecordImageCell.dequeue(from: tableView, for: indexPath)
            
            if let safeAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top, safeAreaTop > 20 {
                imageCell.centerConstraint.constant = -60 * UIDevice.current.scale
            } else {
                imageCell.centerConstraint.constant = -65 * UIDevice.current.scale
            }
            
            imageCell.recordImageView.image = UIImage(named: menuItems[indexPath.row].name)
            return imageCell
        } else if tableView === recordsTitlesTableView {
            let titlesCell = RecordTitlesCell.dequeue(from: tableView, for: indexPath)
            
            switch indexPath.row {
            case 0:
                titlesCell.topLines.forEach { $0.isHidden = true }
                titlesCell.topLabel.isHidden = true
            case menuItems.count - 1:
                titlesCell.topLines.forEach { $0.isHidden = true }
                titlesCell.topLabel.isHidden = true
            default:
                titlesCell.topLines.forEach { $0.isHidden = false }
                titlesCell.topLabel.isHidden = false
                titlesCell.topLabel.text = menuItems[indexPath.row - 1].title
                titlesCell.bottomLabel.text = menuItems[indexPath.row + 1].title
            }
            
            return titlesCell
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === recordsTitlesTableView else { return }
        recordsImagesTableView.contentOffset = scrollView.contentOffset
    }
}
