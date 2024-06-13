//
//  HistoryView.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/13.
//

import SwiftUI

struct HistoryCard: View {
    
    let recordList = [
    Record(inputPage: 2, content: [2,3,4,1,6]),
    Record(inputPage: 1, content: [2,3,4,1,5]),
    Record(inputPage: 3, content: [2,4,3,1,2])
    ]
    
    let history:History
    
//    init(){
//        history = History(date: .now, pageFrameCount: 3, storageTime: 0.1, interruptionTime: 0.5, useCache: false, cacheLookupTime: 0.01, cacheCapacity: 3, fifoResult: [1,2,3,4], fifoRecordList: recordList, fifoTimeDuration: 5, fifoInterruptionCount: 5, lruResult: [1,2,3,4], lruRecordList: recordList, lruTimeDuration: 5, lruInterruptionCount: 5, lfuResult: [1,2,3,4], lfuRecordList: recordList, lfuTimeDuration: 5, lfuInterruptionCount: 5, optResult: [1,2,3,4], optRecordList: recordList, optTimeDuration: 5, optInterruptionCount: 5)
//    }
    
    let dateFormatter = DateFormatter()
    var body: some View {
        VStack{
            Text("测试时间:\(ContentViewModel.shared.getFormattedDate(date: history.date))")
            HStack{
                VStack{
                    Text("页框数目:\(history.pageFrameCount)")
                    Text("访问内存时间:\(String(format: "%.2f", history.storageTime))")
                    Text("页面中断时间:\(String(format: "%.2f", history.interruptionTime))")
                }
                VStack{
                    Text("是否使用快表:\(history.useCache ? "是" : "否")")
                    Text("快表容量:\(history.cacheCapacity)")
                    Text("快表访问时间:\(String(format: "%.2f", history.cacheLookupTime))")
                }
            }
            
        }
        .font(.custom(SettingModel.shared.fontName, size: 15))
        Divider()
            HStack{
                fifoResult
                lruResult
                lfuResult
                optResult

            }
                        
        }
    
    var optResult:some View{
        VStack{
            Text("OPT结果")
                .font(.custom(SettingModel.shared.fontName, size: 15))
            List{
                ForEach(history.optRecordList,id: \.self){ element in
                    VStack(alignment: .leading){
                        HStack{
                            Text("插入:")
                                .font(.custom(SettingModel.shared.fontName, size: 12))
                            BlockView(number: element.inputPage)
                                .font(.custom(SettingModel.shared.fontName, size: 12))
                        }
                        MatrixView(array: element.content)
                            .font(.custom(SettingModel.shared.fontName, size: 12))
                    }
                    .padding()
                    
                }
            }
            Text("花费时间:\(String(format: "%.2f", history.optTimeDuration))")
            Text("中断次数:\(history.optInterruptionCount)")
        }
        .font(.custom(SettingModel.shared.fontName, size: 12))
    }
    
    var lfuResult:some View{
        VStack{
            Text("LFU结果")
                .font(.custom(SettingModel.shared.fontName, size: 15))
            List{
                ForEach(history.lfuRecordList,id: \.self){ element in
                    VStack(alignment: .leading){
                        HStack{
                            Text("插入:")
                                .font(.custom(SettingModel.shared.fontName, size: 12))
                            BlockView(number: element.inputPage)
                                .font(.custom(SettingModel.shared.fontName, size: 12))
                        }
                        MatrixView(array: element.content)
                            .font(.custom(SettingModel.shared.fontName, size: 12))
                    }
                    .padding()
                    
                }
            }
            Text("花费时间:\(String(format: "%.2f", history.lfuTimeDuration))")
            Text("中断次数:\(history.lfuInterruptionCount)")
        }
        .font(.custom(SettingModel.shared.fontName, size: 12))
    }
    
    var lruResult:some View{
        VStack{
            Text("LRU结果")
                .font(.custom(SettingModel.shared.fontName, size: 15))
            List{
                ForEach(history.lruRecordList,id: \.self){ element in
                    VStack(alignment: .leading){
                        HStack{
                            Text("插入:")
                                .font(.custom(SettingModel.shared.fontName, size: 12))
                            BlockView(number: element.inputPage)
                                .font(.custom(SettingModel.shared.fontName, size: 12))
                        }
                        MatrixView(array: element.content)
                            .font(.custom(SettingModel.shared.fontName, size: 12))
                    }
                    .padding()
                    
                }
            }
            Text("花费时间:\(String(format: "%.2f", history.lruTimeDuration))")
            Text("中断次数:\(history.lruInterruptionCount)")
        }
        .font(.custom(SettingModel.shared.fontName, size: 12))
    }
    
    var fifoResult:some View{
        VStack{
            Text("FIFO结果")
                .font(.custom(SettingModel.shared.fontName, size: 15))
            List{
                ForEach(history.fifoRecordList,id: \.self){ element in
                    VStack(alignment: .leading){
                        HStack{
                            Text("插入:")
                                .font(.custom(SettingModel.shared.fontName, size: 12))
                            BlockView(number: element.inputPage)
                                .font(.custom(SettingModel.shared.fontName, size: 12))
                        }
                        MatrixView(array: element.content)
                            .font(.custom(SettingModel.shared.fontName, size: 12))
                    }
                    .padding()
                    
                }
            }
            Text("花费时间:\(String(format: "%.2f", history.fifoTimeDuration))")
            Text("中断次数:\(history.fifoInterruptionCount)")
        }
        .font(.custom(SettingModel.shared.fontName, size: 12))
    }
}


struct HistoryBar:View {
    
    let recordList = [
    Record(inputPage: 2, content: [2,3,4,1,6]),
    Record(inputPage: 1, content: [2,3,4,1,5]),
    Record(inputPage: 3, content: [2,4,3,1,2])
    ]
    
    var history:History
    
//    init(){
//        history = History(date: .now, pageFrameCount: 3, storageTime: 0.1, interruptionTime: 0.5, useCache: false, cacheLookupTime: 0.01, cacheCapacity: 3, fifoResult: [1,2,3,4], fifoRecordList: recordList, fifoTimeDuration: 5, fifoInterruptionCount: 5, lruResult: [1,2,3,4], lruRecordList: recordList, lruTimeDuration: 5, lruInterruptionCount: 5, lfuResult: [1,2,3,4], lfuRecordList: recordList, lfuTimeDuration: 5, lfuInterruptionCount: 5, optResult: [1,2,3,4], optRecordList: recordList, optTimeDuration: 5, optInterruptionCount: 5)
//    }
    
    var body: some View {
        VStack{
            Text("\(history.date)")
            HStack{
                VStack{
                    HStack{
                        Text("FIFO结果:")
                        MatrixView(array: history.fifoResult)
                    }
                    HStack{
                        Text("LRU结果:")
                        MatrixView(array: history.lruResult)
                    }
                }
                VStack{
                    HStack{
                        Text("LFU结果:")
                        MatrixView(array: history.lfuResult)
                    }
                    HStack{
                        Text("OPT结果:")
                        MatrixView(array: history.optResult)
                    }
                }
            }
        }
    }
}



struct HistoryView:View {
    
    @ObservedObject var viewModel = ContentViewModel.shared

    
    var body: some View {
        NavigationView{
            List{
                ForEach(viewModel.historyList,id:\.self){ history in
                    NavigationLink(destination: {
                        HistoryCard(history: history)
                    }, label: {
                        Text("\(ContentViewModel.shared.getFormattedDate(date: history.date))")
                    })
                }
            }
        }
    }
}


#Preview{
    HistoryView()
}
