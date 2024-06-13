//
//  Utility.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/5.
//

import Foundation


struct Result:Codable,Hashable{
    // 输入序列
    var inputSequence:[Int]
    
    // 输出结果
    var fifoResult:[Int]
    var lruResult:[Int]
    var lfuResult:[Int]
    var optResult:[Int]
    
    // 所用时间
    var fifoTimeSpent:Double
    var lruTimeSpent:Double
    var lfuTimeSpent:Double
    var optTImeSpent:Double
    
    // 缺页次数
    var fifoInterruptionCount:Int
    var lruInterruptionCount:Int
    var lfuInterruptionCount:Int
    var optIntterruptionCount:Int
}

// 堆栈和数列
struct Stack{
    
    var count:Int
    var content:[Int] = []
    
    
    mutating func push(element:Int){
        if content.count < count{
            content.append(element)
        }else{
            content.removeFirst()
            content.append(element)
        }
    }
}

struct Queue{
    var count:Int
    var content:[Int] = []
    
    mutating func enqueue(element:Int){
        if content.count < count{
            content.append(element)
        }else{
            content.removeFirst()
            content.append(element)
        }
    }
}

// 状态表
enum Status{
    case running,preparing,end
}
