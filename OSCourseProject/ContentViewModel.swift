//
//  ContentViewModel.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

class ContentViewModel:ObservableObject{
    
    var settingModel = SettingModel.shared
    @Published var isFinished:Bool = false
    // MARK: - 基础运行模块，包括基础算法执行类，保存的页面队列
    // 基础的页面队列
    @Published var pageSequence:[Int] = [] // 逻辑页面访问序列
    
    // 基础算法执行类
    @Published var FIFOexecutor:FIFOExecutor?
    @Published var LRUexecutor:LRUExecutor?
    @Published var LFUexecutor:LFUExecutor?
    @Published var OPTexecutor:OPTExecutor?
    
    
    // MARK: - 经典单步执行模块，已被弃用

    
    // 预备阶段，解析用户输入，初始化算法运算器
    func prepare(inputString:String){
        let stringArray = inputString.split(separator: ",")
        pageSequence = stringArray.compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

      
        FIFOexecutor = FIFOExecutor()
        LRUexecutor = LRUExecutor()
        LFUexecutor = LFUExecutor()
        OPTexecutor = OPTExecutor(pageSequence: pageSequence)
        
        fifoPoint = 0
        lruPoint = 0
        lfuPoint = 0
        optPoint = 0
        isFinished = false
  
    }
    
    // MARK: - 工具函数扩展，包括生成随机数,返回格式化日期值
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
    
    func getFormattedDate(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dateFormatter.string(from: date)
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

            dispatchGroup.notify(queue: DispatchQueue.main) { [self] in
                // 当所有任务完成的时候，保存一次数据
                let history = History(date: .now, pageFrameCount: settingModel.pageFrameCount, storageTime: settingModel.storageTime, interruptionTime: settingModel.interruptionTime, useCache: settingModel.useCache, cacheLookupTime: settingModel.cacheLookupTime, cacheCapacity: settingModel.cacheCapacity, fifoResult: self.FIFOexecutor!.pageFrames, fifoRecordList: FIFOexecutor!.recordList, fifoTimeDuration: self.FIFOexecutor!.timeSpent, fifoInterruptionCount: self.FIFOexecutor!.interruptionCount, lruResult: self.LRUexecutor!.pageFrames, lruRecordList: self.LRUexecutor!.recordList, lruTimeDuration: self.LRUexecutor!.timeSpent, lruInterruptionCount: self.LRUexecutor!.interruptionCount, lfuResult: self.LFUexecutor!.pageFrames, lfuRecordList: self.LFUexecutor!.recordList, lfuTimeDuration: self.LFUexecutor!.timeSpent, lfuInterruptionCount: self.LFUexecutor!.interruptionCount, optResult: self.OPTexecutor!.pageFrames, optRecordList: self.OPTexecutor!.recordList, optTimeDuration: self.OPTexecutor!.timeSpent, optInterruptionCount: self.OPTexecutor!.interruptionCount)
                historyList.append(history)
                isFinished = true
                saveData()
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
    
    // MARK: - 历史数据加载和保存模块
    @Published var historyList:[History] = []
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData(){
        let url = getDocumentsDirectory().appendingPathComponent("HistoryList.json")
        if let data = try? Data(contentsOf: url){
            let decoder = JSONDecoder()
            if let modelStorage = try? decoder.decode([History].self, from: data){
                historyList = modelStorage
                return
            }
        }
        historyList = []
    }
    
    func saveData(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(historyList){
            let url = getDocumentsDirectory().appendingPathComponent("HistoryList.json")
            try? encoded.write(to: url)
        }else{
            print("保存失败")
        }
    }
    
    // MARK: - 其他模块
    
    static let shared = ContentViewModel()
    private init(){
        loadData()
    }
}

