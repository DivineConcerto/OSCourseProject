//
//  ResultView.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/5.
//

import SwiftUI

struct RecordView: View {
    
    @ObservedObject var viewModel = ContentViewModel.shared
    
    var body: some View {
        HStack{
            if let fifo = viewModel.FIFOexecutor,let lru = viewModel.LRUexecutor,let lfu = viewModel.LFUexecutor,let opt = viewModel.OPTexecutor{
                VStack{
                    Text("FIFO历史记录")
                    ShowView(recordList: fifo.recordList)
                }
                VStack{
                    Text("LRU历史记录")
                    ShowView(recordList: lru.recordList)
                }
                VStack{
                    Text("LFU历史记录")
                    ShowView(recordList: lfu.recordList)
                }
                VStack{
                    Text("OPT历史记录")
                    ShowView(recordList: opt.recordList)
                }
            }else{
                VStack{
                    Text("FIFO历史记录")
                    ShowView()
                }
                VStack{
                    Text("LRU历史记录")
                    ShowView()
                }
                VStack{
                    Text("LFU历史记录")
                    ShowView()
                }
                VStack{
                    Text("OPT历史记录")
                    ShowView()
                }
            }
            
        }
        .font(.custom(SettingModel.shared.fontName, size: 20))

    }
}

#Preview {
    RecordView()
}
