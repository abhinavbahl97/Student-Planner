//
//  FitnessViewController.swift
//  GroupProject
//
//  Created by abhinav bahl on 5/7/19.
//  Copyright © 2019 Jonathan Kevin Rosales. All rights reserved.
//
import UIKit
import CoreLocation
import HealthKit

class TimerViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var distanceTraveled = 0.0
    let healthManager = HealthKitManager()
    var height: HKQuantitySample?
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization();
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            print("check1")
        }
        else {
            print("Location service disabled");
        }
        //getHealthKitPermission();
        authorizeHealthKit(completion: { (success, error) -> Void in
            if error != nil {
                print("!!!!!!!!!!!!!!")
            }
            if success {
                print("Data was successfully saved in HealthKit")
            } else {
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func startTimer(sender: CustomButton) {
        print("here")
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        zeroTime = NSDate.timeIntervalSinceReferenceDate
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        locationManager.startUpdatingLocation()
        print("update started")
    }
    
    @IBAction func stopTimer(sender: CustomButton) {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    @objc func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        var timePassed: TimeInterval = currentTime - zeroTime
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        let millisecsX10 = UInt8(timePassed * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMSX10 = String(format: "%02d", millisecsX10)
        
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strMSX10)"
        
        if timerLabel.text == "60:00:00" {
            timer.invalidate()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        print("Came to authorize health kit")
        let writableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!]
        let readableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!]
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
        }
        
        
        healthStore.requestAuthorization(toShare: writableTypes, read: readableTypes) { (userWasShownPermissionView, error) in
            
            // Determine if the user saw the permission view
            if (userWasShownPermissionView) {
                print("User was shown permission view")
                
                if (self.healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!) == .sharingAuthorized) {
                    print("Permission Granted to Access Walking/Running")
                } else {
                    print("Permission Denied to Access walking")
                }
                
            } else {
                print("User was not shown permission view")
                
                // An error occurred
                if let e = error {
                    print(e)
                }
            }
        }
    }
    
    func getHealthKitPermission() {
        authorizeHealthKit(){ (authorized,  error) -> Void in
            if authorized {
                print("cameHereAuthorized")
            //    self.setHeight()
                
                // Get and set the user's height.
              
            } else {
                if error != nil {
                    print("errerr")
                }
                print("Permission denied.")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            print("start location inaccesible")
            startLocation = locations.first as CLLocation?
        } else {
            print("Location updating")
            let lastDistance = lastLocation.distance(from: (locations.last as CLLocation?)!)
            distanceTraveled += lastDistance * 0.000621371
            
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            
            milesLabel.text = "\(trimmedDistance) Miles"
        }
        
        lastLocation = locations.last as CLLocation?
    }
    

    
    @IBAction func share(sender: CustomButton) {
        let distanceType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let distanceQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: distanceTraveled)
        let distance = HKQuantitySample(type: distanceType!, quantity: distanceQuantity, start: NSDate() as Date, end: NSDate() as Date)
  
        print("tried to save")
        healthStore.save(distance, withCompletion: { (success, error) -> Void in
            if error != nil {
                print(error)
            }
            if success {
                print("Data was successfully saved in HealthKit")
            } else {
            }
        })
    }
}
