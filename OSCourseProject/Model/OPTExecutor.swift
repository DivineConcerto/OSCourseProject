//
//  OPTExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

struct OPTExecutor {
    
    var model = SettingModel.shared
    var pageFrames: [Int] = []
    var timeSpent: Double = 0
    var interruptionCount = 0
    var pageSequence: [Int] = []
    
    var cache: [Int] = []
    var cacheSize: Int
    
    init(pageSequence: [Int]) {
        self.pageSequence = pageSequence
        self.cacheSize = model.cacheCapacity
    }
    
    mutating func step(pageIndex: Int, currentPoint: Int) {
        
        if model.useCache{
            // 快表访问
            if let cacheIndex = cache.firstIndex(of: pageIndex) {
                // 快表命中
                timeSpent += model.cacheLookupTime
                return
            } else {
                // 快表缺失
                if cache.count < cacheSize {
                    cache.append(pageIndex)
                } else {
                    // 找到未来访问最远的缓存页
                    let farthestCacheIndex = cache.max { futurePosition(of: $0, currentPoint: currentPoint) < futurePosition(of: $1, currentPoint: currentPoint) }!
                    cache.removeAll { $0 == farthestCacheIndex }
                    cache.append(pageIndex)
                }
            }
        }
        
        // 填充阶段，如果页面不存在于主存，则添加到末尾
        if pageFrames.count < model.pageFrameCount && pageFrames.firstIndex(of: pageIndex) == nil {
            pageFrames.append(pageIndex)
            timeSpent += model.storageTime + model.interruptionTime
            interruptionCount += 1
            return
        }
        
        // 稳定阶段，如果页面存在于主存
        if pageFrames.firstIndex(of: pageIndex) != nil {
            timeSpent += model.storageTime
            return
        }
        
        // 页面不在主存中，选择将来不会再被访问的页面换掉
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
    
    private func futurePosition(of page: Int, currentPoint: Int) -> Int {
        if let index = pageSequence[currentPoint...].firstIndex(of: page) {
            return index
        } else {
            return Int.max
        }
    }
}
