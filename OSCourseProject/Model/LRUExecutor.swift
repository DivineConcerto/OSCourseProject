//
//  LRUExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//
import Foundation

struct LRUExecutor {
    
    var model = SettingModel.shared
    var pageFrames: [Int] = []
    var cache: [Int] = []
    var cacheSize: Int = 2 // 设置快表大小
    var interruptionCount = 0
    var timeSpent: Double = 0
    
    var recordList:[Record] = []
    
    init(){
        cacheSize = model.cacheCapacity
    }
    
    mutating func step(pageIndex: Int) {
        if model.useCache{
            // 快表访问
            if let cacheIndex = cache.firstIndex(of: pageIndex) {
                // 快表命中
                timeSpent += model.cacheLookupTime
                // 更新快表顺序
                cache.remove(at: cacheIndex)
                cache.append(pageIndex)
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
        
        // 如果页面在主存中存在
        if pageFrames.firstIndex(of: pageIndex) != nil {
            timeSpent += model.storageTime
            // 更新主存顺序
            pageFrames.removeAll { $0 == pageIndex }
            pageFrames.append(pageIndex)
        } else {
            // 缺页中断
            interruptionCount += 1
            timeSpent += model.storageTime + model.interruptionTime
            if pageFrames.count < model.pageFrameCount {
                pageFrames.append(pageIndex)
            } else {
                pageFrames.removeFirst()
                pageFrames.append(pageIndex)
            }
        }
        
        recordList.append(Record(inputPage: pageIndex, content: pageFrames))
    }
}
