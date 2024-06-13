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
    
    var cache:[Int] = []
    var cacheSize:Int = 3
    
    var recordList:[Record] = []
    
    init(){
        cacheSize = model.cacheCapacity
    }
    
    mutating func step(pageIndex:Int){
        
        if model.useCache{
            // 快表访问
                    if let cacheIndex = cache.firstIndex(of: pageIndex) {
                        // 快表命中
                        timeSpent += model.cacheLookupTime
                        recordList.append(Record(inputPage: pageIndex, content: pageFrames))
                        return
                    } else {
                        // 快表缺失
                        if cache.count < cacheSize {
                            cache.append(pageIndex)
                        } else {
                            cache.removeFirst()
                            cache.append(pageIndex)
                        }
                    }
        }
   
        // 如果里面存在，就跳过
        if pageFrames.firstIndex(of: pageIndex) != nil{
            timeSpent += model.storageTime
            recordList.append(Record(inputPage: pageIndex, content: pageFrames))
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
        
        recordList.append(Record(inputPage: pageIndex, content: pageFrames))
    }
    
}
