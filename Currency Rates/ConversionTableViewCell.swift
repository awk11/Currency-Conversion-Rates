//
//  ConversionTableViewCell.swift
//  Currency Rates
//
//  Created by Adam Kaufman on 9/6/16.
//  Copyright © 2016 Adam Kaufman. All rights reserved.
//

import UIKit

class ConversionTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var currencyType: UILabel!
    @IBOutlet weak var conversionRate: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
