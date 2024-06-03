//
//  ContentViewModel.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

class ContentViewModel:ObservableObject{
    
    var model = GameModel.shared
    
    @Published var FIFOexecutor:FIFOExecutor?
    @Published var LRUexecutor:LRUExecutor?
    @Published var LFUexecutor:LFUExecutor?
    @Published var OPTexecutor:OPTExecutor?
    
    @Published var pageSequenceString = ""
    @Published var fifoResultString = ""
    @Published var lruResultString = ""
    @Published var lfuResultString = ""
    @Published var optResultString = ""
    
    var point:Int = 0

    // 预备阶段，解析用户输入，初始化算法运算器
    func prepare(inputString:String){
        let stringArray = inputString.split(separator: ",")
        model.pageSequence = stringArray.compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        pageSequenceString = "\(model.pageSequence)"
                       
        
        FIFOexecutor = FIFOExecutor()
        LRUexecutor = LRUExecutor()
        LFUexecutor = LFUExecutor()
        OPTexecutor = OPTExecutor()
    }
    
    // 单步步进，四个算法运算器分别进行一步步进
    func step(){

        if point < model.pageSequence.count - 1{
            FIFOexecutor?.step(pageIndex: model.pageSequence[point])
            LRUexecutor?.step(pageIndex: model.pageSequence[point])
            LFUexecutor?.step(pageIndex: model.pageSequence[point])
            OPTexecutor?.step(pageIndex: model.pageSequence[point], currentPoint: point)
            point += 1
        }
        
        if let fifoResult = FIFOexecutor?.pageFrames {
            fifoResultString = "\(fifoResult)"
        } else {
            fifoResultString = "无"
        }
        
        if let lruResult = LRUexecutor?.pageFrames {
            lruResultString = "\(lruResult)"
        } else {
            lruResultString = "无"
        }
        
        if let lfuResult = LFUexecutor?.pageFrames{
            lfuResultString = "\(lfuResult)"
        }else{
            lruResultString = "无"
        }
        
        if let optResult = OPTexecutor?.pageFrames{
            optResultString = "\(optResult)"
        }else{
            optResultString = "无"
        }
        
    }
    
    // 生成并返回随机数
    func generatePageSequenceRandomly(count:Int,minValue:Int,maxValue:Int) -> String{
        
        var result = ""
        for _ in 0...count{
            let number = Int.random(in: minValue...maxValue)
            result += "\(number),"
        }
        result.removeLast()
        return result        
    }
    
}
