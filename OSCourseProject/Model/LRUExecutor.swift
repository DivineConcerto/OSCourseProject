//
//  LRUExecutor.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

class LRUExecutor{
    
    var model = GameModel.shared
    
    var pageSequence:[Int]
    var pageFrames:[Int] = []
    
    
    init(){
        pageSequence = model.pageSequence
    }
    
    func step(pageIndex:Int){
        // 填充阶段
        if pageFrames.count < model.pageCount {
            // 如果存在该元素，就将其移动到末尾
            if pageFrames.firstIndex(of: pageIndex) != nil{
                let index = pageFrames.firstIndex(of: pageIndex)
                pageFrames.remove(at: index!)
                pageFrames.append(pageIndex)
            }else{
                // 如果不存在，就将它添加到末尾
                pageFrames.append(pageIndex)
            }
            
        }else{
            // 稳定阶段，如果里面有，就将其移动到末尾。如果没有，就加到末尾，然后删除第一个元素
            if pageFrames.firstIndex(of: pageIndex) != nil{
                let index = pageFrames.firstIndex(of: pageIndex)
                pageFrames.remove(at: index!)
                pageFrames.append(pageIndex)
            }else{
                pageFrames.append(pageIndex)
                pageFrames.removeFirst()
            }
            
        }
    }
}
