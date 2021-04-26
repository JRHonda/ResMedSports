//
//  SportResultCellViewModel.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import UIKit

class SportResultCellVM: UITableViewCell {
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var time: UILabel!
    
    public var height: CGFloat {
        return super.frame.size.height
    }
}
