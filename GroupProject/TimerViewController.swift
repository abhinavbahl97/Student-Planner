//
//  FitnessViewController.swift
//  GroupProject
//
//  Created by abhinav bahl on 5/7/19.
//  Copyright © 2019 Jonathan Kevin Rosales. All rights reserved.
//

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
        getHealthKitPermission();
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
    
    func getHealthKitPermission() {
        healthManager.authorizeHealthKit{ (authorized,  error) -> Void in
            if authorized {
                print("cameHere")
                self.setHeight()
                
                // Get and set the user's height.
              
            } else {
                if error != nil {
                    print("errerr")
                }
                print("Permission denied.")
            }
        }
    }
    
    func setHeight() {
        // Create the HKSample for Height.
        let heightSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)

        self.healthManager.getHeight(sampleType: heightSample!, completion: { (userHeight, error) -> Void in

            if( error != nil ) {
                print("Error: \(error!.localizedDescription)")
                return
            }

            var heightString = ""

            self.height = userHeight as? HKQuantitySample

            // The height is formatted to the user's locale.
            if let meters = self.height?.quantity.doubleValue(for: HKUnit.meter()) {
                let formatHeight = LengthFormatter()
                formatHeight.isForPersonHeightUse = true
                heightString = formatHeight.string(fromMeters: meters)
            }
            
            DispatchQueue.main.async { self.heightLabel.text = heightString }

        })
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
//        healthManager.saveDistance(distanceTraveled, date: NSDate())

    }
    
}
