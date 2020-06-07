//
//  DrumRecordsViewController.swift
//  menu
//
//  Created by Serge Vysotsky on 05.06.2020.
//  Copyright © 2020 Svyatoslav Ivanov. All rights reserved.
//

import UIKit

final class DrumRecordsViewController: UIViewController {
    private var circleView: DesignableView!
    private var recordsViews = [UIImageView]()
    private var menuItems = [MenuButtonType]()
    private var currentIndex = 0
    
    private lazy var constants = Constants(in: view)
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems = Static.parseButtons()
        
        circleView = DesignableView(frame: constants.circleRect)
        circleView.borderWidth = 1
        circleView.borderColor = .white
        circleView.cornerRadius = constants.circleSide / 2
        view.addSubview(circleView)
        
        for record in RecordsPosition.allCases {
            let recordImageView = UIImageView()
            recordImageView.isUserInteractionEnabled = true
            recordImageView.clipsToBounds = true
            recordsViews.append(recordImageView)
            
            switch record {
            case .east:
                recordImageView.frame = constants.recordRect
                recordImageView.image = getImage(for: 0)
            case .north:
                recordImageView.frame = constants.recordRect.offsetBy(dx: -constants.radius, dy: -constants.radius)
                recordImageView.image = getImage(for: -1)
            case .west:
                recordImageView.frame = constants.recordRect.offsetBy(dx: -constants.radius * 2, dy: 0)
                recordImageView.image = getImage(for: 2)
            case .south:
                recordImageView.frame = constants.recordRect.offsetBy(dx: -constants.radius, dy: constants.radius)
                recordImageView.image = getImage(for: 1)
            }
            
            circleView.addSubview(recordImageView)
        }
        
        let up = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        let down = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        up.direction = .up
        down.direction = .down
        view.addGestureRecognizer(up)
        view.addGestureRecognizer(down)
    }
    
    @objc func swipeUp() {
        movingToRecord = lastVisibleRecord.next
        lastVisibleRecord = movingToRecord!
        
        let nextAngle = lastAngle - .pi / 2
        defer { lastAngle = nextAngle }
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.applyTransform(for: nextAngle)
        }, completion: nil)
    }
    
    @objc func swipeDown() {
        movingToRecord = lastVisibleRecord.previous
        lastVisibleRecord = movingToRecord!
        
        let nextAngle = lastAngle + .pi / 2
        defer { lastAngle = nextAngle }
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.applyTransform(for: nextAngle)
        }, completion: nil)
    }
    
    private var lastAngle: CGFloat = 0
    private var lastVisibleRecord: RecordsPosition = .east
    private var lastOffset = 0
    private var currentHiddenIndex = 2
    private var movingToRecord: RecordsPosition? {
        didSet {
            if movingToRecord != oldValue, let movingToRecord = movingToRecord {
                let offset = movingToRecord.previous == lastVisibleRecord ? 1 : -1
                defer {
                    lastOffset = offset
                }
                
                let nextIndex = currentHiddenIndex + offset
                let secretValue = 2
                switch (lastOffset, offset) {
                case (-1, 1):
                    currentHiddenIndex -= secretValue
                case (1, -1):
                    currentHiddenIndex += secretValue
                case (0, 1):
                    currentHiddenIndex = secretValue
                case (0, -1):
                    currentHiddenIndex = -secretValue
                default:
                    currentHiddenIndex = nextIndex
                }
                
                recordsViews[lastVisibleRecord.opposite.rawValue].image = getImage(for: currentHiddenIndex)
            }
        }
    }
    
    func getImage(for index: Int) -> UIImage {
        let count = menuItems.count
        var remainder = index % count
        
        if remainder == 0, index < 0 {
            remainder = -count
        }
        
        let getIndex = index >= 0 ? remainder : count + remainder
        return UIImage(named: menuItems[getIndex].name)!
    }
    
    func applyTransform(for angle: CGFloat) {
        circleView.transform = CGAffineTransform(rotationAngle: angle)
        recordsViews.forEach { $0.transform = CGAffineTransform(rotationAngle: -angle) }
    }
}

enum RecordsPosition: Int, CaseIterable {
    case east
    case south
    case west
    case north
    
    var opposite: RecordsPosition {
        switch self {
        case .east:
            return .west
        case .south:
            return .north
        case .west:
            return .east
        case .north:
            return .south
        }
    }
    
    var next: RecordsPosition {
        switch self {
        case .east:
            return .south
        case .south:
            return .west
        case .west:
            return .north
        case .north:
            return .east
        }
    }
    
    var previous: RecordsPosition {
        switch self {
        case .east:
            return .north
        case .south:
            return .east
        case .west:
            return .south
        case .north:
            return .west
        }
    }
}

func recordPosition(for angle: CGFloat) -> RecordsPosition {
    let clippedAngle = angle.truncatingRemainder(dividingBy: .pi * 2)
    
    let step = CGFloat.pi / 2
    let anglesDict: [CGFloat : RecordsPosition] = [
        -3 * step : .north,
        -2 * step : .west,
        -1 * step : .south,
         0 * step : .east,
         1 * step : .north,
         2 * step : .west,
         3 * step : .south,
    ]
    
    let key = anglesDict.keys.sorted { abs($0 - clippedAngle) < abs($1 - clippedAngle) }.first!
    return anglesDict[key]!
}

func calculateNearestAngle(to angle: CGFloat, by period: CGFloat) -> CGFloat {
    (angle / period).rounded() * period
}

private struct Constants {
    let recordSide: CGFloat
    let recordRect: CGRect
    let circleSide: CGFloat
    let circleRect: CGRect
    let radius: CGFloat
    
    init(in view: UIView) {
        let screenRect = view.bounds
        let scale = UIDevice.current.scale
        let circleTrailingOffset = 10 * scale//30 * scale
        let circleMultiplier: CGFloat = 1.9
        
        let safeAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        let circleCenterOffset: CGFloat = safeAreaTop > 20 ? 14 * scale : 6 * scale
        
        recordSide = screenRect.width * 0.54
        circleSide = screenRect.width * circleMultiplier
        
        
        let recordTrailingOffset: CGFloat = screenRect.width / 2 - recordSide / 2 - circleTrailingOffset
        circleRect = CGRect(x: screenRect.width - circleSide - circleTrailingOffset,
                            y: screenRect.height / 2 - circleSide / 2 - circleCenterOffset,
                            width: circleSide,
                            height: circleSide)
        
        recordRect = CGRect(x: circleRect.size.width - recordSide - recordTrailingOffset,
                            y: (circleRect.size.height - recordSide) / 2,
                            width: recordSide,
                            height: recordSide)
        
        radius = (circleRect.width - recordSide) / 2 - recordTrailingOffset
    }
}
