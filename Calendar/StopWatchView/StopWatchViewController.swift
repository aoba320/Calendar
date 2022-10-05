//
//  StopWatch.swift
//  Calendar
//
//  Created by 鈴木　葵葉 on 2021/07/14.
//

import UIKit
import SwiftUI
import RealmSwift
import HealthKit

class StopWatchViewController: UIViewController {
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    @IBOutlet var circularGaugeView: UIView!
    @IBOutlet var inturrptedView: UIView!
    @IBOutlet weak var picker: UIDatePicker! {
        didSet {
            picker.datePickerMode = .countDownTimer
        }
    }
    
    var count: Int = 0
    
    var latestHeartRate = 0.0
    
    var focusRate = 0
    
    var timer: Timer = Timer()
    var targetTimeInterval: CFTimeInterval = 0
    
    //時間の型で保存する、秒数で保存
    var startTime = TimeInterval()
    //UIDeviceクラスを呼ぶ
    let myDevice: UIDevice = UIDevice.current
    
    var result: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(targetTimeInterval)
        print("👻👻👻👻")
        // 近接センサーの有効化
        UIDevice.current.isProximityMonitoringEnabled = true
        
        // 近接センサーのON-Offが切り替わる通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(proximityMonitorStateDidChange),
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil
        )
        // インスタンスを生成し prepare() をコール
        feedbackGenerator.prepare()
        
        //healthkit使用の許可
        let typeOfRead = Set([typeOfHeartRate])
        myHealthStore.requestAuthorization(toShare: [],read: typeOfRead,completion: { (success, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            print(success)
        })
        
        readHeartRate()
    }
    @IBAction func start() {
        performSegue(withIdentifier: "tocountdown", sender: .none)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tocountdown"{
            let vc = segue.destination as! StopWatchViewController
            vc.targetTimeInterval = picker.countDownDuration
        }
        if segue.identifier == "totimer"{
            let vc = segue.destination as! TimerViewController
            vc.count = self.count
            vc.latestHeartRate = self.latestHeartRate
            vc.focusRate = self.focusRate
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIDevice.current.isProximityMonitoringEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIDevice.current.isProximityMonitoringEnabled = false
    }
    
    @IBAction func exitButtonPressed(){
        self.performSegue(withIdentifier: "totimer", sender: nil)
    }
    
    // 近接センサーのON-Offが切り替わると実行される
    @objc func proximityMonitorStateDidChange() {
        if inturrptedView.isHidden == false {
            inturrptedView.isHidden = true
        }
        let proximityState = UIDevice.current.proximityState
        print(proximityState)
        self.feedbackGenerator.notificationOccurred(.warning)
        if proximityState {
            if !timer.isValid {
                //タイマーが動作してなかったら動かす
                timer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(self.up),
                                             userInfo: nil,
                                             repeats:true
                )
            }
        } else {
            timer.invalidate()
        }
    }
    
    @objc func up() {
        //countを0.01足す
        count = count + 1
        //ラベル表示
        let interval = Int(targetTimeInterval) - Int(count)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        //        label.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        updateGaugePrgress(remainingTime: String(format: "%02d:%02d:%02d", hours, minutes, seconds),
                           remainingRate: (targetTimeInterval - Double(count)) / targetTimeInterval)
    }
    
    func updateGaugePrgress(remainingTime: String, remainingRate: Double) {
        for view in self.circularGaugeView.subviews {
            view.removeFromSuperview()
        }
        let vc = UIHostingController(rootView: CircularGauge(remainingRate: remainingRate, remainingTimeString: remainingTime))
        self.addChild(vc)
        self.circularGaugeView.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.backgroundColor = .clear
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: circularGaugeView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: circularGaugeView.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: circularGaugeView.bottomAnchor),
            vc.view.topAnchor.constraint(equalTo: circularGaugeView.topAnchor)])
    }
    
    //ヘルスキット系
    let myHealthStore = HKHealthStore()
    var typeOfHeartRate = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    
    var heartRateArray: [Double] = []
    
    func readHeartRate() {
        //期間の設定
        let calendar = Calendar.current
        let date = Date()
        let endDate = calendar.date(byAdding: .day, value: -0, to: calendar.startOfDay(for: date))
        let startDate = calendar.date(byAdding: .day, value: -10, to: calendar.startOfDay(for: date))
        print("startDate")
        print(startDate)
        print("endDate")
        print(endDate)
        
        let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        
        //resultsに指定した期間のヘルスデータが取得される
        let query = HKSampleQuery(sampleType: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!, predicate: HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: []), limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]){ [self] (query, results, error) in
            
            guard results != [] else { return }
            
            print(results?[0])
            
            for result in results ?? [] {
                guard let currData = result as? HKQuantitySample else { return }
                //                print("心拍数: \(currData.quantity.doubleValue(for: heartRateUnit))")
                let heartRate = currData.quantity.doubleValue(for: heartRateUnit)
                self.heartRateArray.append(heartRate)
            }
            print("heartRateArray")
            print(self.heartRateArray)
            
            latestHeartRate = self.heartRateArray.last ?? 0
            
            // aveHeartRateに平均心拍数を代入
            let heart = heartRateArray
            let sum = self.heartRateArray.reduce(0) {(num1: Double, num2: Double) -> Double in
                return num1 + num2
            }
            print(sum/Double(heart.count))
            let aveHeartRate = sum/Double(heart.count)
            
            // 平均心拍数からスコアを判定
            if ( aveHeartRate > sum/Double(heart.count) + 1 ) {
                print("超集中")
                focusRate = 3
                self.result = "超集中"
            } else if ( sum/Double(heart.count) + 1 > aveHeartRate &&  aveHeartRate > sum/Double(heart.count) - 1 ) {
                print("集中")
                focusRate = 2
                self.result = "集中"
            } else if ( sum/Double(heart.count) - 1 > aveHeartRate) {
                print("普通")
                focusRate = 1
                self.result = "普通"
            } else {
                print("error")
            }
        }
        myHealthStore.execute(query)
    }
}
