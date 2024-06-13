//
//  LFUExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

struct LFUExecutor {
    
    var model = SettingModel.shared
    var pageFrames: [Int] = []
    var cache: [Int] = []
    var cacheSize: Int = 2 // 设置快表大小
    var pageFrequency: [Int: Int] = [:] // 页面访问频率
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
                pageFrequency[pageIndex]! += 1
                recordList.append(Record(inputPage: pageIndex, content: pageFrames))
                return
            } else {
                // 快表缺失
                if cache.count < cacheSize {
                    cache.append(pageIndex)
                } else {
                    let lfuPage = cache.min { pageFrequency[$0]! < pageFrequency[$1]! }!
                    cache.removeAll { $0 == lfuPage }
                    cache.append(pageIndex)
                }
                pageFrequency[pageIndex] = 1
            }
        }
        
        // 如果页面在主存中存在
        if pageFrames.firstIndex(of: pageIndex) != nil {
            timeSpent += model.storageTime
            pageFrequency[pageIndex]! += 1
        } else {
            // 缺页中断
            interruptionCount += 1
            timeSpent += model.storageTime + model.interruptionTime
            if pageFrames.count < model.pageFrameCount {
                pageFrames.append(pageIndex)
            } else {
                let lfuPage = pageFrames.min { pageFrequency[$0]! < pageFrequency[$1]! }!
                pageFrames.removeAll { $0 == lfuPage }
                pageFrames.append(pageIndex)
            }
            pageFrequency[pageIndex] = 1
        }
        recordList.append(Record(inputPage: pageIndex, content: pageFrames))
    }
}
