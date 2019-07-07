//
//  LegendTableViewCell.swift
//  Graphics
//
//  Created by Sergey Kaliberda on 6/30/19.
//  Copyright © 2019 Sergey Kaliberda. All rights reserved.
//

import UIKit

class LegendTableViewCell: UITableViewCell {
    @IBOutlet weak var colorIndicator: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    struct Constants {
        static let colorIndicatorCornerRadius:CGFloat = 7.0
    }
    
    var graphLine: GraphLine! {
        didSet {
            self.colorIndicator.backgroundColor = self.graphLine.color
            self.lblName.text = self.graphLine.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colorIndicator.layer.cornerRadius = Constants.colorIndicatorCornerRadius
    }

}
