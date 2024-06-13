//
//  Utility.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/5.
//

import Foundation



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
