//
//  RecordModel.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/12.
//

import Foundation

struct Record:Hashable,Decodable,Encodable{
    
    var inputPage:Int
    var content:[Int]
    
}

struct History:Hashable,Encodable,Decodable{
    
    // MARK: - 整体配置区
    let date:Date
    let pageFrameCount:Int
    let storageTime:Double
    let interruptionTime:Double
    let useCache:Bool
    let cacheLookupTime:Double
    let cacheCapacity:Int
    
    // MARK: - FIFO区
    let fifoResult:[Int]
    let fifoRecordList:[Record]
    let fifoTimeDuration:Double
    let fifoInterruptionCount:Int
    
    // MARK: - LRU区
    let lruResult:[Int]
    let lruRecordList:[Record]
    let lruTimeDuration:Double
    let lruInterruptionCount:Int
    
    // MARK: - LFU区
    let lfuResult:[Int]
    let lfuRecordList:[Record]
    let lfuTimeDuration:Double
    let lfuInterruptionCount:Int
    
    // MARK: - OPT区
    let optResult:[Int]
    let optRecordList:[Record]
    let optTimeDuration:Double
    let optInterruptionCount:Int
     
}
