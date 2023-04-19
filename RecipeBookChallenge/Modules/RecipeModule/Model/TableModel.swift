//
//  TableModel.swift
//  RecipeBookChallenge
//
//  Created by user on 2.03.23.
//

import Foundation
import UIKit

struct TableModel {
    var ingtidientName: String
    var amountIngridient: String
}



extension TableModel {
    static func getRecept() -> [TableModel]{
        [
        TableModel(ingtidientName: "onion", amountIngridient: "2 pcs"),
        TableModel(ingtidientName: "BredBredBredBredBredBredBredBredBred", amountIngridient: "200 g"),
        TableModel(ingtidientName: "Bred", amountIngridient: "200 g"),
        TableModel(ingtidientName: "Bred", amountIngridient: "200 g"),
        TableModel(ingtidientName: "BrBredvBredBredBreded", amountIngridient: "200 g200 g200 g"),
        TableModel(ingtidientName: "Bred", amountIngridient: "200 g"),
        TableModel(ingtidientName: "BreBredBredBredBredBredBredBredBredBredBredBredd", amountIngridient: "200 g"),
        TableModel(ingtidientName: "Bred", amountIngridient: "200 g"),
        TableModel(ingtidientName: "Bred", amountIngridient: "200 g"),
        TableModel(ingtidientName: "Bred", amountIngridient: "200 g"),
        TableModel(ingtidientName: "Milk", amountIngridient: "200 ml")
        ]
    }
}



