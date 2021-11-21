//
//  Enum+CurrentCellType.swift
//  Weather
//
//  Created by Gaurav Malik on 20/11/21.
//

import UIKit

enum CurrentCellType: Int {
    case TimesCell = 0
    case DetailCell
    case DaysCell
}

extension CurrentCellType {
    var cellType: UITableViewCell.Type {
        switch self {
        case .DaysCell:
            return DaysTableCell.self
        case .DetailCell:
            return DetailTableCell.self
        case .TimesCell:
            return CurrentLocationTimesCell.self
        }
    }
}
