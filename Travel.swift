//
//  Travel.swift
//  TravelApp
//
//  Created by internet on 22/5/15.
//  Copyright (c) 2015 dmancilla. All rights reserved.
//

import Foundation
import CoreData

@objc(Travel)
class Travel: NSManagedObject {

    @NSManaged var descr: String
    @NSManaged var destiny: String
    @NSManaged var name: String
    //One to Many relationship in your Model
    @NSManaged var activities: NSMutableSet

}

extension Travel {
    
    func addActivitiesObject(value: Activity) {
        self.activities.addObject(value)
    }
    
    func removeActivitiesObject(value: Activity) {
        self.activities.removeObject(value)
    }
    
    func addActivities(values: [Activity]) {
        self.activities.addObjectsFromArray(values)
    }
    
    func removeActivity(values: [Activity]) {
        for activity in values as [Activity] {
            self.removeActivitiesObject(activity)
        }
    }
    
}