//
//  CellActionDelegate.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/20/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

/**
 This protocol helps perform action outside of the cell class.
 Steps:
    1) In the tableview controller class, conform to this protocol
    2) Assign the tableview instance as the cell's delegate of type CellActionDelegate
    3) Call the appropriate func when needed inside the cell class
*/
protocol DetailsViewCellActionDelegate {
    func addPriceButtonTapped()
}

protocol EntryCellWithLabelDelegate{
    func inputFieldTapped()
}
