//
//  HealthKitManager.swift
//  GroupProject
//
//  Created by abhinav bahl on 5/13/19.
//  Copyright © 2019 Jonathan Kevin Rosales. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        print("Tried")
        let writableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!]
         let readableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!]
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
        }
    
        
        healthKitStore.requestAuthorization(toShare: writableTypes, read: readableTypes) { (success, error) -> Void in
            if( error != nil ) {
                print("hello Error here")
            }
        }
    }
    
    func saveDistance(distanceRecorded: Double, date: NSDate ) {
        
        let distanceType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        print(distanceType)
        let distanceQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: distanceRecorded)
        print(distanceQuantity)
        let distance = HKQuantitySample(type: distanceType!, quantity: distanceQuantity, start: date as Date, end: date as Date)
        print(distance)
    //        HKQuantitySample(type: distanceType!, quantity: distanceQuantity, start: date as Date, end: date as Date)
        print("tried to save")
        self.healthKitStore.save(distance, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print(error)
            } else {
                print("The distance has been recorded! Better go check!")
            }
        })
    }
}
