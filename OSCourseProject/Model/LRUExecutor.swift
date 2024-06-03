//
//  LRUExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

struct LRUExecutor{
    
    var pageFrames:[Int] = []
    var model = GameModel.shared
    
    var timeSpent:Double = 0
    
    var interruptionCount = 0

    

    
    mutating func step(pageIndex:Int){
        // 填充阶段
        if pageFrames.count < model.pageFrameCount {
            // 如果存在该元素，就将其移动到末尾
            if pageFrames.firstIndex(of: pageIndex) != nil{
                let index = pageFrames.firstIndex(of: pageIndex)
                pageFrames.remove(at: index!)
                pageFrames.append(pageIndex)
                timeSpent += model.storageTime
            }else{
                // 如果不存在，就将它添加到末尾
                interruptionCount += 1
                pageFrames.append(pageIndex)
                timeSpent = timeSpent + model.storageTime + model.interruptionTime
            }
            
        }else{
            // 稳定阶段，如果里面有，就将其移动到末尾。如果没有，就加到末尾，然后删除第一个元素
            if pageFrames.firstIndex(of: pageIndex) != nil{
                let index = pageFrames.firstIndex(of: pageIndex)
                pageFrames.remove(at: index!)
                pageFrames.append(pageIndex)
                timeSpent = timeSpent + model.storageTime
            }else{
                interruptionCount += 1
                pageFrames.append(pageIndex)
                pageFrames.removeFirst()
                timeSpent = timeSpent + model.storageTime + model.interruptionTime
            }
            
        }
    }
}
