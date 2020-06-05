//
//  ViewController.swift
//  menu
//
//  Created by Svyatoslav Ivanov on 07.04.2020.
//  Copyright © 2020 Svyatoslav Ivanov. All rights reserved.
//

import UIKit
import pop

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var menuItems = [MenuButtonType]()
    private let background = UIImageView()
    private let circle = UIImageView()
    private let nextCircle = UIImageView()
    private let tableView = UITableView()
    private let containerView = UIView()
    private var titlesArr = [UITextView]()
    private var iphoneModel: IphoneModel = .iphone11
    private var direction: CGFloat = 0
    private var x: CGFloat = 0
    private var y: CGFloat = 0
    private var rowHeight: CGFloat = 250
    private var cellInfos = [TableCellInfo]()
    private var recordsViews = [UIImageView]()
    private var node = 0
    private var prevNode = 0
    
    private var anchors: [CGPoint] {
        return (0..<cellInfos.count).map {
            let inset = tableView.adjustedContentInset.top
            let cellsHeight = cellInfos.prefix($0).reduce(0, { $0 + $1.height })
            return CGPoint(x: 0, y: cellsHeight - inset)
        }
    }
    
    private var maxAnchor: CGPoint {
        let inset = tableView.adjustedContentInset.bottom
        return CGPoint(x: 0, y: tableView.contentSize.height - view.bounds.height + inset)
    }
    
    private func nearestAnchor(forContentOffset offset: CGPoint) -> CGPoint {
        if node == cellInfos.count - 1 {
            return anchors[node - 1]
        } else {
            return anchors[node]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iphoneModel = Static.recognizeModel()
        setSize()
        setBackground()
        loadButtonTypes()
        setTableView()
        view.backgroundColor = .black
        
    }
    
    private func loadButtonTypes() {
        var titleSize = 20
        var descriptionSize = 12
        switch iphoneModel {
        case .iphone6, .iphone7, .iphone8:
            titleSize = 16
            descriptionSize = 12
            break
        default:
            titleSize = 20
            descriptionSize = 12
        }

        menuItems = Static.parseButtons()
        cellInfos.append(TableCellInfo(text: NSMutableAttributedString(), description: NSMutableAttributedString(), height: rowHeight, bgColor: UIColor.clear))
        for (index, item) in menuItems.enumerated() {
            
            let attrs1 = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
            
            let attrs2 = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
            
            let attributedString1 = NSMutableAttributedString(string:"\"\(item.name)\"\n", attributes:attrs1 as [NSAttributedString.Key : Any])
            
            let attributedString2 = NSMutableAttributedString(string:"\(item.description)", attributes:attrs2 as [NSAttributedString.Key : Any])
            
            setRecordViews(name: item.name, position: index)
            cellInfos.append(TableCellInfo(text: attributedString1, description: attributedString2, height: rowHeight, bgColor: UIColor.clear))
        }
    }
    
    private func setRecordViews(name: String, position: Int) {
        let imageView = UIImageView()
        if position == 0 {
            imageView.frame = CGRect(x: self.x * 0.018, y: self.y * 0.213, width: self.x * 0.97, height: self.x * 0.97)
        } else {
            imageView.frame = CGRect(x: self.x * 0.018, y: self.y * 1.213, width: self.x * 0.97, height: self.x * 0.97)
        }
        let imagePath = Bundle.main.path(forResource: name, ofType: "png")
        let defaultImage = Bundle.main.path(forResource: "defaultRecord", ofType: "png")
        imageView.image = UIImage.init(contentsOfFile: imagePath ?? defaultImage!)
        recordsViews.append(imageView)
        view.addSubview(imageView)
    }
    
    private func setSize() {
        x = view.frame.width
        switch iphoneModel {
        case .iphone6, .iphone7, .iphone8:
            print(view.frame.height)
            y = view.frame.height * 0.67
            rowHeight = view.frame.height / 2.7
            break
        default:
            print(view.frame.height)
            y = view.frame.height * 1.05
            rowHeight = view.frame.height / 3.3
        }

    }
    
    private func mask(view: UIView) {
        let maskLayer = CAShapeLayer()
        var radius: CGFloat

        switch iphoneModel {
        case .iphone6, .iphone7, .iphone8:
            radius = 175
            break
        default:
            radius = y / 4.55
        }
        let path = CGMutablePath()
        let circlePath = UIBezierPath(roundedRect: CGRect(x: view.frame.midX - radius, y: y * 0.22, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius)
        path.addRect(background.bounds)
        path.addPath(circlePath.cgPath)
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        view.layer.mask = maskLayer
    }
    
    private func setTableView() {
         tableView.separatorStyle = .none
         tableView.allowsSelection = false
         tableView.register(CustomTableCell.self, forCellReuseIdentifier: Static.cellReuseIdentifier)
         tableView.delegate = self
         tableView.dataSource = self
         tableView.showsVerticalScrollIndicator = false
         tableView.frame = CGRect(x: 0, y: view.bounds.height * -0.05, width: view.bounds.width, height: view.bounds.height * 0.9)
         switch iphoneModel {
         case .iphone6, .iphone7, .iphone8:
             tableView.frame = CGRect(x: 0, y: view.bounds.height * -0.12, width: view.bounds.width, height: view.bounds.height * 1.1)
             break
         default: break
         }

         tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         tableView.backgroundColor = UIColor.clear.withAlphaComponent(0)
         
         containerView.frame = view.bounds
         let maskLayer = CALayer()
         maskLayer.frame = CGRect(x: 0, y: y * 0.3, width: x, height: y * 0.3)
         mask(view: containerView)
         containerView.layer.zPosition = 2
         containerView.addSubview(tableView)
         view.addSubview(containerView)
     }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.location(in: view).y > view.bounds.height * 0.85 {
            return false
        }
       return true
    }
    
    private func changeRecord() {
        if node == recordsViews.count || prevNode == recordsViews.count { return }
        if node > prevNode {
            UIView.animate(withDuration: 0.2, animations: {
                self.recordsViews[self.node].frame = CGRect(x: self.x * 0.023, y: self.y * 0.205, width: self.x * 0.96, height: self.x * 0.96)
            })
        } else if node < prevNode {
            UIView.animate(withDuration: 0.2, animations: {
                self.recordsViews[self.prevNode].frame = CGRect(x: self.x * 0.023, y: self.y * 1.205, width: self.x * 0.96, height: self.x * 0.96)
            })
        }
    }
    
    private func recognizeModel() {
        let modelName = UIDevice.current.modelName
        if (modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 7" || modelName == "iPhone 8" || modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus" || modelName == "iPhone 8 Plus")  {
            iphoneModel = .iphone8
        } else if modelName == "iPhone X" {
            iphoneModel = .iphoneX
        } else {
            iphoneModel = .iphone11
        }
    }
    
    private func setBackground() {
        let imagePath: String

        switch iphoneModel {
        case .iphone6, .iphone7, .iphone8:
            imagePath = Bundle.main.path(forResource: "back8empty", ofType: "png")!
            break
        default:
            imagePath = Bundle.main.path(forResource: "back11empty", ofType: "png")!
        }
        background.frame = view.bounds
        background.image = UIImage.init(contentsOfFile: imagePath)
        background.layer.zPosition = 1
        background.contentMode = .scaleAspectFit
        view.addSubview(background)
    }
}

struct Static {
     
     static let cellReuseIdentifier = "\(UITableViewCell.self)"
    
     static func recognizeModel() -> IphoneModel {
         let modelName = UIDevice.current.modelName
        var iphoneModel: IphoneModel
         if (modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 7" || modelName == "iPhone 8" || modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus" || modelName == "iPhone 8 Plus")  {
             iphoneModel = .iphone8
         } else if modelName == "iPhone X" {
             iphoneModel = .iphoneX
         } else {
             iphoneModel = .iphone11
         }
        return iphoneModel
     }
    
    static func parseButtons() -> [MenuButtonType] {
        let path = Bundle.main.url(forResource: "menuButtons", withExtension: "json")!
        do {
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode([MenuButtonType].self, from: data)
        } catch {
            fatalError(error.localizedDescription)
        }
     }
 }

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: Static.cellReuseIdentifier, for: indexPath) as! CustomTableCell
            cell.update(with: cellInfos[indexPath.row], rowHeight: rowHeight, rowWidth: x, indexPath: indexPath.row)
            return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func nodeChanger(_ sign: String) {
        switch sign {
        case "+": if node != cellInfos.count - 2 {
            prevNode = node
            node += 1
        }
            break
        case "-": if node != 0 {
            prevNode = node
            node -= 1
        }
            break
        default:
            print("nodeChanger default")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellInfos[indexPath.row].height
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let decelerationRate = (UIScrollView.DecelerationRate.normal.rawValue + UIScrollView.DecelerationRate.fast.rawValue) / 2
        let offsetProjection = scrollView.contentOffset.project(initialVelocity: velocity, decelerationRate: decelerationRate)
        
        let offsetDif = Int(offsetProjection.y) - node * 250
        if (offsetDif > 200) {
            nodeChanger("+")
        } else if offsetDif < -200 {
            nodeChanger("-")
        }
        let targetAnchor = nearestAnchor(forContentOffset: offsetProjection)
        changeRecord()
        // Stop system animation
        targetContentOffset.pointee = scrollView.contentOffset
        
        scrollView.snapAnimated(toContentOffset: targetAnchor, velocity: velocity)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.stopSnappingAnimation()
    }
}

private extension UIScrollView {
    
    private static let snappingAnimationKey = "CustomPaging.TableViewController.scrollView.snappingAnimation"
    
    func snapAnimated(toContentOffset newOffset: CGPoint, velocity: CGPoint) {
        let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPScrollViewContentOffset)
        animation.velocity = velocity
        animation.toValue = newOffset
        animation.fromValue = contentOffset
        
        pop_add(animation, forKey: UIScrollView.snappingAnimationKey)
    }
    
    func stopSnappingAnimation() {
        pop_removeAnimation(forKey: UIScrollView.snappingAnimationKey)
    }
}

