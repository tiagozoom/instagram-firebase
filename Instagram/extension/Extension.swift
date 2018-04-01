//
//  Extension.swift
//  Instagram
//
//  Created by tiago turibio on 30/10/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView{
    func anchors( top: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,paddingTop: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, width: CGFloat?, height: CGFloat?){
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let right = right{
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let left = left{
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let width = width, width > 0{
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height, height > 0{
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func insertDivider(with color: UIColor, top: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,paddingTop: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, width: CGFloat?, height: CGFloat?){
        let divider = UIView()
        divider.backgroundColor = color
        divider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(divider)
        divider.anchors(top: top, right: right, bottom: bottom, left: left, paddingTop: paddingTop, paddingRight: paddingRight, paddingBottom: paddingBottom, paddingLeft: paddingLeft, width: width, height: height)
    }
}

extension UITextField{
    func shake(){
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 5
        shakeAnimation.autoreverses = true
        let fromValueAnimationCoordenates = CGPoint(x: self.center.x - 12, y: self.center.y)
        let toValueAnimationCoordenates = CGPoint(x: self.center.x, y: self.center.y)
        shakeAnimation.fromValue = NSValue(cgPoint: fromValueAnimationCoordenates)
        shakeAnimation.toValue = NSValue(cgPoint: toValueAnimationCoordenates)
        self.layer.add(shakeAnimation, forKey: "position")
    }
}

extension String{
    func isValidEmail() -> Bool{
        let emailValidationRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        return emailPredicate.evaluate(with:self)
    }
}

extension UIButton{
    func setAsEnabled(_ enabled: Bool){
        self.isEnabled = enabled
        if enabled{
            self.alpha = 1
        }else{
            self.alpha = 0.5
        }
    }
    
    func setRoundImage(_ image: UIImage?, for state: UIControlState ){
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.setImage(image, for: state)
    }
}

extension UIImageView{
    func loadImageWith(url imageUrl: URL, completion: ((_ data:Data)->Void)?){
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let error = error{
                print(error)
                return
            }
            if let data = data{
                if let completion = completion{
                    completion(data)
                }
            }
            }.resume()
    }
}

extension Date{
    func timeAgoSinceDate() -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(self as Date)
        let latest = (earliest == now as Date) ? self : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            return "1 year ago"
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            return "1 month ago"
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            return "1 week ago"
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            return "1 day ago"
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            return "1 hour ago"
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            return "1 minute ago"
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
