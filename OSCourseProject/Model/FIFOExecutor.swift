//
//  FIFOExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

struct FIFOExecutor{
    
    var model = SettingModel.shared
    var pageFrames:[Int] = []
    var interruptionCount = 0
    var timeSpent:Double = 0
    
    mutating func step(pageIndex:Int){
        // 如果里面存在，就跳过
        if pageFrames.firstIndex(of: pageIndex) != nil{
            timeSpent += model.storageTime
            return
        }else {
            interruptionCount += 1
            // 填充阶段
            timeSpent = timeSpent + model.storageTime + model.interruptionTime
            if pageFrames.count < model.pageFrameCount{
                pageFrames.append(pageIndex)
            }else{
                pageFrames.removeFirst()
                pageFrames.append(pageIndex)
            }
        }
    }
}
