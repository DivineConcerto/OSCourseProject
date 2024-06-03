//
//  FIFOExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

class FIFOExecutor{
    
    var model = GameModel.shared
    
    var pageSequence:[Int]
    var pageFrames:[Int]
    var point:Int = 0
    
    init(){
        pageSequence = model.pageSequence
        pageFrames = Array(repeating: -1, count: model.pageFrameCount)
    }
    
    func step(pageIndex:Int){
        pageFrames[point] = pageIndex
        point = point + 1 % model.pageCount
    }
     
    
}
