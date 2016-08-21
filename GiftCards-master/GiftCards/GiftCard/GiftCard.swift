//
//  GiftCards.swift
//  GiftCard
//
//  Created by Nisarg Vora on 8/18/16.
//  Copyright © 2016 Nisarg Vora. All rights reserved.
//

import Foundation

class GiftCard {
    var id : Int?
    var name : String?
    var description : String?
    var redemption_instructions : String?
    var terms_and_conditions : String?
    var image_url : String?
    var tax : String?
    var currencyisocode : String?
    
    required init?(dict: NSDictionary) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        description = dict["description"] as? String
        redemption_instructions = dict["redemption_instructions"] as? String
        terms_and_conditions = dict["terms_and_conditions"] as? String
        image_url = dict["image_url"] as? String
        tax = dict["tax"] as? String
        currencyisocode = dict["currencyisocode"] as? String
    }
}

