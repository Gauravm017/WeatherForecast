//
//  Protocol+NibLoadable.swift
//  Weather
//
//  Created by Gaurav Malik on 20/11/21.
//

import UIKit

protocol NibLoadable: AnyObject {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
