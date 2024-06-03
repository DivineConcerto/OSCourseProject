//
//  LFUExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

struct LFUExecutor{
    
    var model = GameModel.shared
    
    var pageFrames:[Int] = []
    var frequency:[Int] = []
    
    var timeSpent:Double = 0
    var interruptionCount = 0
    
    init(){
        frequency = Array(repeating: 0, count: model.pageFrameCount)
    }
    
    mutating func step(pageIndex:Int){
        // 填充阶段，如果里面存在，相应位置就加一；如果里面不存在，就将其加到后面。
        if pageFrames.count < model.pageFrameCount{
            if pageFrames.firstIndex(of: pageIndex) != nil{
                let index:Int! = pageFrames.firstIndex(of: pageIndex)
                frequency[index] += 1
                timeSpent = timeSpent + model.storageTime
            }else{
                interruptionCount += 1
                pageFrames.append(pageIndex)
                frequency[pageFrames.count - 1] += 1
                timeSpent = timeSpent + model.storageTime + model.interruptionTime
            }
        }else{
            // 稳定阶段，如果里面存在，相应位置加一，如果里面不存在，就删除最小频率，频率归零，将其加在最后面，频率加一。
            if pageFrames.contains(pageIndex){
                let index:Int! = pageFrames.firstIndex(of: pageIndex)
                frequency[index] += 1
                timeSpent = timeSpent + model.storageTime
            }else{
                interruptionCount += 1
                if let minValue = frequency.min(),let minIndex = frequency.firstIndex(of: minValue){
                    print("最小索引:\(String(describing: minIndex))")
                    pageFrames.remove(at: minIndex)
                    pageFrames.append(pageIndex)
                    frequency.remove(at: minIndex)
                    frequency.append(1)
                    timeSpent = timeSpent + model.storageTime + model.interruptionTime

                }
            }
        }
        
        
        
    }
}
