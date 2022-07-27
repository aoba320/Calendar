//
//  StudyRecordManager.swift
//  Calendar
//
//  Created by 鈴木　葵葉 on 2022/07/06.
//

import Foundation
import RealmSwift


final class StudyRecordManager {
    static let shared = StudyRecordManager()
    
    private init() { }
    
    let realm = try! Realm()
    
    func getWeekData() -> [ToyShape] {
        let results = realm.objects(StudyRecord.self)
        print(results)
        
        var toyShapeArray = [ToyShape]()
        
        let weekAgo = Date(timeIntervalSinceNow: -60*60*24*7)
        let sixDaysAgo = Date(timeIntervalSinceNow: -60*60*24*6)
        let fiveDaysAgo = Date(timeIntervalSinceNow: -60*60*24*5)
        let fourDaysAgo = Date(timeIntervalSinceNow: -60*60*24*4)
        let threeDaysAgo = Date(timeIntervalSinceNow: -60*60*24*3)
        let twoDaysAgo = Date(timeIntervalSinceNow: -60*60*24*2)
        let yesterday = Date(timeIntervalSinceNow: -60*60*24)
        
        let todayData = results.filter { $0.date > yesterday }
        let yesterdayData = results.filter { $0.date > twoDaysAgo && $0.date < yesterday }
        let threeDaysAgoData = results.filter { $0.date > threeDaysAgo && $0.date < twoDaysAgo }
        let fourDaysAgoData = results.filter { $0.date > threeDaysAgo && $0.date < twoDaysAgo }
        let fiveDaysAgoData = results.filter { $0.date > fiveDaysAgo && $0.date < fourDaysAgo }
        let sixDaysAgoData = results.filter { $0.date > sixDaysAgo && $0.date < fiveDaysAgo }
        let weekAgoData = results.filter { $0.date > weekAgo && $0.date < sixDaysAgo }
        
        let todayQuality1 = todayData.filter { $0.quality == 1 }
        let todayQuality2 = todayData.filter { $0.quality == 2 }
        let todayQuality3 = todayData.filter { $0.quality == 3 }
        let todayArray = [todayQuality1, todayQuality2, todayQuality3]
       
        let yesterdayQuality1 = yesterdayData.filter { $0.quality == 1 }
        let yesterdayQuality2 = yesterdayData.filter { $0.quality == 2 }
        let yesterdayQuality3 = yesterdayData.filter { $0.quality == 3 }
        let yesterdayArray = [yesterdayQuality1, yesterdayQuality2, yesterdayQuality3]
        
        let threeDaysQuality1 = threeDaysAgoData.filter { $0.quality == 1 }
        let threeDaysQuality2 = threeDaysAgoData.filter { $0.quality == 2 }
        let threeDaysQuality3 = threeDaysAgoData.filter { $0.quality == 3 }
        let threeDaysArray = [threeDaysQuality1, threeDaysQuality2, threeDaysQuality3]
        
        let fourDaysQuality1 = fourDaysAgoData.filter { $0.quality == 1 }
        let fourDaysQuality2 = fourDaysAgoData.filter { $0.quality == 2 }
        let fourDaysQuality3 = fourDaysAgoData.filter { $0.quality == 3 }
        let fourDaysArray = [fourDaysQuality1, fourDaysQuality2, fourDaysQuality3]
        
        let fiveDaysQuality1 = fiveDaysAgoData.filter { $0.quality == 1 }
        let fiveDaysQuality2 = fiveDaysAgoData.filter { $0.quality == 2 }
        let fiveDaysQuality3 = fiveDaysAgoData.filter { $0.quality == 3 }
        let fiveDaysArray = [fiveDaysQuality1, fiveDaysQuality2, fiveDaysQuality3]
        
        let sixDaysQuality1 = sixDaysAgoData.filter { $0.quality == 1 }
        let sixDaysQuality2 = sixDaysAgoData.filter { $0.quality == 2 }
        let sixDaysQuality3 = sixDaysAgoData.filter { $0.quality == 3 }
        let sixDaysArray = [sixDaysQuality1, sixDaysQuality2, sixDaysQuality3]
        
        let weekAgoQuality1 = weekAgoData.filter { $0.quality == 1 }
        let weekAgoQuality2 = weekAgoData.filter { $0.quality == 2 }
        let weekAgoQuality3 = weekAgoData.filter { $0.quality == 3 }
        let weekAgoArray = [weekAgoQuality1, weekAgoQuality2, weekAgoQuality3]
        
        let today = todayArray.map {
            $0.map {
                $0.time
            }.reduce(0) { (num1, num2) -> Double in
                num1 + num2
            }
        }

        toyShapeArray.append(ToyShape(color: "charts-lightblue", type: "Today", count: Int(today[0])))
        toyShapeArray.append(ToyShape(color: "charts-blue", type: "Today", count: Int(today[1])))
        toyShapeArray.append(ToyShape(color: "charts-deepblue", type: "Today", count: Int(today[2])))
        
        let twoDays = yesterdayArray.map {
            $0.map {
                $0.time
            }.reduce(0) { (num1, num2) -> Double in
                num1 + num2
            }
        }

        toyShapeArray.append(ToyShape(color: "charts-lightblue", type: "Today", count: Int(twoDays[0])))
        toyShapeArray.append(ToyShape(color: "charts-blue", type: "Today", count: Int(twoDays[1])))
        toyShapeArray.append(ToyShape(color: "charts-deepblue", type: "Today", count: Int(twoDays[2])))
        
        let threeDays = threeDaysArray.map {
            $0.map {
                $0.time
            }.reduce(0) { (num1, num2) -> Double in
                num1 + num2
            }
        }

        toyShapeArray.append(ToyShape(color: "charts-lightblue", type: "Today", count: Int(threeDays[0])))
        toyShapeArray.append(ToyShape(color: "charts-blue", type: "Today", count: Int(threeDays[1])))
        toyShapeArray.append(ToyShape(color: "charts-deepblue", type: "Today", count: Int(threeDays[2])))
        
        let fourDays = fourDaysArray.map {
            $0.map {
                $0.time
            }.reduce(0) { (num1, num2) -> Double in
                num1 + num2
            }
        }

        toyShapeArray.append(ToyShape(color: "charts-lightblue", type: "Today", count: Int(fourDays[0])))
        toyShapeArray.append(ToyShape(color: "charts-blue", type: "Today", count: Int(fourDays[1])))
        toyShapeArray.append(ToyShape(color: "charts-deepblue", type: "Today", count: Int(fourDays[2])))
        
        let fiveDays = fiveDaysArray.map {
            $0.map {
                $0.time
            }.reduce(0) { (num1, num2) -> Double in
                num1 + num2
            }
        }
        
        toyShapeArray.append(ToyShape(color: "charts-lightblue", type: "Today", count: Int(fiveDays[0])))
        toyShapeArray.append(ToyShape(color: "charts-blue", type: "Today", count: Int(fiveDays[1])))
        toyShapeArray.append(ToyShape(color: "charts-deepblue", type: "Today", count: Int(fiveDays[2])))
        
        let sixDays = sixDaysArray.map {
            $0.map {
                $0.time
            }.reduce(0) { (num1, num2) -> Double in
                num1 + num2
            }
        }
        
        toyShapeArray.append(ToyShape(color: "charts-lightblue", type: "Today", count: Int(sixDays[0])))
        toyShapeArray.append(ToyShape(color: "charts-blue", type: "Today", count: Int(sixDays[1])))
        toyShapeArray.append(ToyShape(color: "charts-deepblue", type: "Today", count: Int(sixDays[2])))
        
        let sevenDays = weekAgoArray.map {
            $0.map {
                $0.time
            }.reduce(0) { (num1, num2) -> Double in
                num1 + num2
            }
        }
        
        toyShapeArray.append(ToyShape(color: "charts-lightblue", type: "Today", count: Int(sevenDays[0])))
        toyShapeArray.append(ToyShape(color: "charts-blue", type: "Today", count: Int(sevenDays[1])))
        toyShapeArray.append(ToyShape(color: "charts-deepblue", type: "Today", count: Int(sevenDays[2])))
        
        return toyShapeArray

    }
}