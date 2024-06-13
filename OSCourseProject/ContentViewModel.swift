//
//  ContentViewModel.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

class ContentViewModel:ObservableObject{
    
    var settingModel = SettingModel.shared
    
    @Published var status:Status = .preparing
    // MARK: - 基础运行模块，包括基础算法执行类，保存的页面队列
    // 基础的页面队列
    @Published var pageSequence:[Int] = [] // 逻辑页面访问序列
    
    // 基础算法执行类
    @Published var FIFOexecutor:FIFOExecutor?
    @Published var LRUexecutor:LRUExecutor?
    @Published var LFUexecutor:LFUExecutor?
    @Published var OPTexecutor:OPTExecutor?
    
    
    
    // 基础算法输出类
    @Published var pageSequenceString = ""
    @Published var fifoResultString = ""
    @Published var lruResultString = ""
    @Published var lfuResultString = ""
    @Published var optResultString = ""
    
    // MARK: - 经典单步执行模块，已被弃用
    var point = 0
    
    // 预备阶段，解析用户输入，初始化算法运算器
    func prepare(inputString:String){
        let stringArray = inputString.split(separator: ",")
        pageSequence = stringArray.compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        pageSequenceString = "\(pageSequence)"
                       
        
        FIFOexecutor = FIFOExecutor()
        LRUexecutor = LRUExecutor()
        LFUexecutor = LFUExecutor()
        OPTexecutor = OPTExecutor(pageSequence: pageSequence)
        
        fifoPoint = 0
        lruPoint = 0
        lfuPoint = 0
        optPoint = 0
        
        fifoResultString = ""
        lruResultString = ""
        lfuResultString = ""
        optResultString = ""
        
        point = 0
        status = .preparing
        
    }
    // 单步步进，四个算法运算器分别进行一步步进
    func step(){

        if point < pageSequence.count {
            FIFOexecutor?.step(pageIndex: pageSequence[point])
            LRUexecutor?.step(pageIndex: pageSequence[point])
            LFUexecutor?.step(pageIndex: pageSequence[point])
            OPTexecutor?.step(pageIndex: pageSequence[point], currentPoint: point)
            point += 1
            if point == pageSequence.count{
                // TODO: 在这里保存数据
                status = .end
            }
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
    
    // MARK: - 工具函数扩展，包括生成随机数
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
    

    
    // MARK: - 多线程控制板块，当前使用方案
    let dispatchGroup = DispatchGroup()
    @Published var fifoPoint = 0
    @Published var lruPoint = 0
    @Published var lfuPoint = 0
    @Published var optPoint = 0

    let queue = DispatchQueue.global()

    func start() {
        self.dispatchGroup.enter()
        self.queue.async(group: self.dispatchGroup) {
            self.runFIFO()
        }

        self.dispatchGroup.enter()
        self.queue.async(group: self.dispatchGroup) {
            self.runLRU()
        }

        self.dispatchGroup.enter()
        self.queue.async(group: self.dispatchGroup) {
            self.runLFU()
        }

        self.dispatchGroup.enter()
        self.queue.async(group: self.dispatchGroup) {
            self.runOPT()
        }

        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            print("All functions completed")
        }
    }

    func runFIFO() {
        DispatchQueue.global().async {
            while self.fifoPoint < self.pageSequence.count {
                self.FIFOexecutor?.step(pageIndex: self.pageSequence[self.fifoPoint])
                self.fifoPoint += 1
                Thread.sleep(forTimeInterval: self.settingModel.intervals)
            }
            print("FIFO completed")
            self.dispatchGroup.leave()
        }
    }

    func runLRU() {
        DispatchQueue.global().async {
            while self.lruPoint < self.pageSequence.count {
                self.LRUexecutor?.step(pageIndex: self.pageSequence[self.lruPoint])
                self.lruPoint += 1
                Thread.sleep(forTimeInterval: self.settingModel.intervals)
            }
            print("LRU completed")
            self.dispatchGroup.leave()
        }
    }

    func runLFU() {
        DispatchQueue.global().async {
            while self.lfuPoint < self.pageSequence.count {
                self.LFUexecutor?.step(pageIndex: self.pageSequence[self.lfuPoint])
                self.lfuPoint += 1
                Thread.sleep(forTimeInterval: self.settingModel.intervals)
            }
            print("LFU completed")
            self.dispatchGroup.leave()
        }
    }

    func runOPT() {
        DispatchQueue.global().async {
            while self.optPoint < self.pageSequence.count {
                self.OPTexecutor?.step(pageIndex: self.pageSequence[self.optPoint], currentPoint: self.optPoint)
                self.optPoint += 1
                Thread.sleep(forTimeInterval: self.settingModel.intervals)
            }
            print("OPT completed")
            self.dispatchGroup.leave()
        }
    }

    // 确保在使用索引时进行边界检查
    func getPageSequenceValue(at index: Int) -> Int? {
        return index < pageSequence.count ? pageSequence[index] : pageSequence.last
    }


    
    // MARK: - 其他模块
    
    static let shared = ContentViewModel()
    private init(){
        
    }
}

