//
//  UIView+extensions.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/27/21.
//

import UIKit

extension UIView {
    
    /// Animates a cell returned from a UITableViewDelegate method
    /// - Parameters:
    ///   - cell: Any UITableViewCell
    ///   - tableView: The table to draw the cell on
    ///   - indexPath: The path, or section:row, the cell will be draw on
    /// - Returns: The animating cell
    static func animateCellWithMoveAndFade(cell: UITableViewCell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height / 2)
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            })
        return cell
    }
    
}
