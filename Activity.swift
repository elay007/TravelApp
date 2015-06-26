//
//  Activity.swift
//  TravelApp
//
//  Created by internet on 22/5/15.
//  Copyright (c) 2015 dmancilla. All rights reserved.
//

import Foundation
import CoreData

@objc(Activity)
class Activity: NSManagedObject {

    @NSManaged var dateFinish: NSDate
    @NSManaged var dateInit: NSDate
    @NSManaged var latitude: String
    @NSManaged var longitude: String
    @NSManaged var name: String
    @NSManaged var numTicket: NSNumber
    @NSManaged var qtyTicket: NSNumber
    @NSManaged var picture: NSData
    //One to One relationship in your Model
    @NSManaged var travel: Travel

}

