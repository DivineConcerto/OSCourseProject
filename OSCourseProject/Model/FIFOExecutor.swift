//
//  FIFOExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

struct FIFOExecutor{
    
    var model = GameModel.shared
    var pageFrames:[Int]
    var point:Int = 0
    
    init(){
        pageFrames = Array(repeating: -1, count: model.pageFrameCount)
    }
    
    mutating func step(pageIndex:Int){
        // 如果里面存在，就跳过
        if pageFrames.firstIndex(of: pageIndex) != nil{
            return
        }
        // 如果不存在，再玩这一套
        pageFrames[point] = pageIndex
        point = (point + 1) % model.pageFrameCount
    }
     
    
}
