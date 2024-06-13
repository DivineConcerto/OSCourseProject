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

        let semaphore = DispatchSemaphore(value: 1)
        @Published var isPaused = false

        func start() {
            dispatchGroup.enter()
            queue.async(group: dispatchGroup) {
                self.runFIFO()
            }

            dispatchGroup.enter()
            queue.async(group: dispatchGroup) {
                self.runLRU()
            }

            dispatchGroup.enter()
            queue.async(group: dispatchGroup) {
                self.runLFU()
            }

            dispatchGroup.enter()
            queue.async(group: dispatchGroup) {
                self.runOPT()
            }

            dispatchGroup.notify(queue: DispatchQueue.main) {
                print("All functions completed")
            }
        }

        func runFIFO() {
            while fifoPoint < pageSequence.count {
                semaphore.wait()
                defer { semaphore.signal() }
                if isPaused {
                    continue
                }
                DispatchQueue.main.async {
                    self.FIFOexecutor?.step(pageIndex: self.pageSequence[self.fifoPoint])
                    self.fifoPoint += 1
                }
                Thread.sleep(forTimeInterval: settingModel.intervals)
            }
            print("FIFO completed")
            dispatchGroup.leave()
        }

        func runLRU() {
            while lruPoint < pageSequence.count {
                semaphore.wait()
                defer { semaphore.signal() }
                if isPaused {
                    continue
                }
                DispatchQueue.main.async {
                    self.LRUexecutor?.step(pageIndex: self.pageSequence[self.lruPoint])
                    self.lruPoint += 1
                }
                Thread.sleep(forTimeInterval: settingModel.intervals)
            }
            print("LRU completed")
            dispatchGroup.leave()
        }

        func runLFU() {
            while lfuPoint < pageSequence.count {
                semaphore.wait()
                defer { semaphore.signal() }
                if isPaused {
                    continue
                }
                DispatchQueue.main.async {
                    self.LFUexecutor?.step(pageIndex: self.pageSequence[self.lfuPoint])
                    self.lfuPoint += 1
                }
                Thread.sleep(forTimeInterval: settingModel.intervals)
            }
            print("LFU completed")
            dispatchGroup.leave()
        }

        func runOPT() {
            while optPoint < pageSequence.count {
                semaphore.wait()
                defer { semaphore.signal() }
                if isPaused {
                    continue
                }
                DispatchQueue.main.async {
                    self.OPTexecutor?.step(pageIndex: self.pageSequence[self.optPoint], currentPoint: self.optPoint)
                    self.optPoint += 1
                }
                Thread.sleep(forTimeInterval: settingModel.intervals)
            }
            print("OPT completed")
            dispatchGroup.leave()
        }

        func pause() {
            isPaused = true
        }

        func resume() {
            isPaused = false
            semaphore.signal()
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

