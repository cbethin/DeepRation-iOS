//
//  Extensions.swift
//  DeepRation
//
//  Created by Charles Bethin on 1/8/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import UIKit

extension Date {
    var isDateInToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    var isDateInYesterday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInYesterday(self)
    }
    
    var daysSince: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfDate = calendar.startOfDay(for: self)
        return calendar.dateComponents([.day], from: startOfDate, to: startOfToday).day!
    }
    
    func getAsCommonString() -> String {
        let daysSince = self.daysSince
        if daysSince == 0 {
            return "Today"
        } else if daysSince == 1 {
            return "Yesterday"
        } else if daysSince >= 2 && daysSince <= 4 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YYYY"
        return dateFormatter.string(from: self)
    }
    
    func isInSameDayAs(date: Date) -> Bool {
        let calendar = Calendar.current
        let startOfThisDate = calendar.startOfDay(for: self)
        let startOfDate = calendar.startOfDay(for: date)
        
        return calendar.dateComponents([.day], from: startOfThisDate, to: startOfDate).day! == 0
    }
}

extension UIApplication {
    
    static var loginAnimation: UIView.AnimationOptions = .transitionFlipFromRight
    static var logoutAnimation: UIView.AnimationOptions = .transitionCrossDissolve
    
    public static func setRootView(_ viewController: UIViewController,
                                   options: UIView.AnimationOptions = .transitionFlipFromRight,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.5,
                                   completion: (() -> Void)? = nil) {
        guard animated else {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            return
        }
        
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.keyWindow?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}
