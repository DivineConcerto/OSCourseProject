//
//  OPTExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

struct OPTExecutor{
    
    init(pageSequence:[Int]){
        self.pageSequence = pageSequence
    }
    
    var model = SettingModel.shared
    var pageFrames:[Int] = []
    var timeSpent:Double = 0
    var interruptionCount = 0
    var pageSequence:[Int] = []
    
    mutating func step(pageIndex:Int,currentPoint:Int){
        
        // 填充阶段，如果里面不存在，则添加到末尾
        if pageFrames.count < model.pageFrameCount && pageFrames.firstIndex(of: pageIndex) == nil{
            pageFrames.append(pageIndex)
            timeSpent = timeSpent + model.storageTime + model.interruptionTime
            interruptionCount += 1
            return
        }
        
        // 稳定阶段，如果里面存在，就存在；如果里面不存在，就选一个将来不会再被访问的元素换掉
        if pageFrames.count == model.pageFrameCount{
            if pageFrames.firstIndex(of: pageIndex) != nil {
                timeSpent = timeSpent + model.storageTime
                return
            }
            
            // 遍历每一个页框，找到在Sequence中的最远，或不再存在的元素，然后把它扔掉。
            // 具体思路，如果后面不包含，就直接替换掉。否则，就存储其坐标，
            var farthestDistance = -1
            var farthestIndex = -1
            for (index, page) in pageFrames.enumerated() {
                if let futureIndex = pageSequence[currentPoint...].firstIndex(of: page) {
                    if futureIndex > farthestDistance {
                        farthestDistance = futureIndex
                        farthestIndex = index
                    }
                } else {
                    // 如果后续不再访问此页面，直接替换掉
                    farthestIndex = index
                    break
                }
            }
            pageFrames.remove(at: farthestIndex)
            pageFrames.append(pageIndex)
            timeSpent += model.storageTime + model.interruptionTime
            interruptionCount += 1
        }
    }    
}
