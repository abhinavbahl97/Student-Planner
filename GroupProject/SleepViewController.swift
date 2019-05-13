//  SleepAnalysis
import UIKit
import HealthKit

class SleepViewController: UIViewController {
    
    
    @IBOutlet var displayTimeLabel: UILabel!
    
    var startTime = TimeInterval()
    var alarmTime: NSDate!
    var timer:Timer = Timer()
    var endTime: NSDate!
    let health = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        self.view.backgroundColor = UIColor.black
        self.health.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                NSLog(" Display not allowed")
            }
        }
    }
    
    @IBAction func start(sender: AnyObject) {
        alarmTime = NSDate()
        if (!timer.isValid) {
            let aSelector : Selector = #selector(SleepViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
        }
        
    }
    @IBAction func stop(sender: AnyObject) {
        endTime = NSDate()
        saveAnalysis()
        retrieveAnalysis()
        timer.invalidate()
    }
    @objc func updateTime() {
        let currTime = NSDate.timeIntervalSinceReferenceDate
        var elapsed: TimeInterval = currTime - startTime
        
        let min = UInt8(elapsed / 60.0)
        elapsed = elapsed - (TimeInterval(min) * 60)
        let sec = UInt8(elapsed)
        elapsed = elapsed - TimeInterval(sec)
        convertTime(min, sec, elapsed)
    }
    
    func convertTime(_ min : UInt8, _ sec: UInt8, _ elapsed: TimeInterval){
        let fraction = UInt8(elapsed * 100)
        let strMin = String(format: "%02d", min)
        let strSec = String(format: "%02d", sec)
        let strFrac = String(format: "%02d", fraction)
        displayTimeLabel.text = "\(strMin):\(strSec):\(strFrac)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createObj(_ sleepType: HKCategoryType){
        // The new object that we need to push in Health app
        let obj = HKCategorySample(type:sleepType, value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: self.alarmTime as Date, end: self.endTime as Date)
        
        health.save(obj, withCompletion: { (success, error) -> Void in
            if error != nil {
                return
            }
            if success {
                print("Data was successfully saved in HealthKit")
            } else {
            }
        })
    }
    
    func createObjTwo(_ sleepType: HKCategoryType){
        let obj2 = HKCategorySample(type:sleepType, value: HKCategoryValueSleepAnalysis.asleep.rawValue, start: self.alarmTime as Date, end: self.endTime as Date)
        health.save(obj2, withCompletion: { (success, error) -> Void in
            if error != nil {
                return
            }
            if success {
                print("Data 2 was successfully saved in HealthKit")
            } else {
            }
        })
    }
    
    func saveAnalysis() {
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            createObj(sleepType)
            createObjTwo(sleepType)
        }
    }
    
    func retrieveAnalysis() {
        if let type = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let exe = HKSampleQuery(sampleType: type, predicate: nil, limit: 30, sortDescriptors: [sort]) { (exe, tmpResult, error) -> Void in
                if error != nil {
                    return
                }
                if let result = tmpResult {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                            print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                        }
                    }
                }
            }
            health.execute(exe)
        }
    }
}

