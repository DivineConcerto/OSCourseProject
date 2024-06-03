//
//  LFUExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

class LFUExecutor{
    
    var model = GameModel.shared
    
    var pageSequence:[Int]
    var pageFrames:[Int] = []
    var frequency:[Int]
    
    init(){
        pageSequence = model.pageSequence
        frequency = Array(repeating: 0, count: model.pageCount)
    }
    
    func step(pageIndex:Int){
        // 填充阶段，如果里面存在，相应位置就加一；如果里面不存在，就将其加到后面。
        if pageFrames.count < model.pageCount{
            if pageFrames.contains(pageIndex){
                let index:Int! = pageFrames.firstIndex(of: pageIndex)
                frequency[index] += 1
            }else{
                pageFrames.append(pageIndex)
                pageFrames[pageFrames.count - 1] += 1
            }
        }else{
            // 稳定阶段，如果里面存在，相应位置加一，如果里面不存在，就删除最小频率，频率归零，将其加在最后面，频率加一。
            if pageFrames.contains(pageIndex){
                let index:Int! = pageFrames.firstIndex(of: pageIndex)
                frequency[index] += 1
            }else{
                let minValue:Int! = pageFrames.min()
                let index:Int! = pageFrames.firstIndex(of: minValue)
                pageFrames.remove(at: index)
                pageFrames.append(pageIndex)
                frequency.remove(at: index)
                frequency[pageFrames.count - 1] += 1
            }
        }
        
        
        
    }
}
