//
//  Protocol+ReusableCell.swift
//  Weather
//
//  Created by Gaurav Malik on 20/11/21.
//

import UIKit

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

