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
    
    var point:Int = 0

    // 预备阶段，解析用户输入，初始化算法运算器
    func prepare(inputString:String){
        model.pageSequence = inputString.compactMap { $0.wholeNumberValue }
        
        FIFOexecutor = FIFOExecutor()
        LRUexecutor = LRUExecutor()
        LFUexecutor = LFUExecutor()
        OPTexecutor = OPTExecutor()
    }
    
    // 单步步进，四个算法运算器分别进行一步步进
    func step(){
        FIFOexecutor?.step(pageIndex: model.pageSequence[point])
        LRUexecutor?.step(pageIndex: model.pageSequence[point])
        LFUexecutor?.step(pageIndex: model.pageSequence[point])
        point += 1
    }
    
}
