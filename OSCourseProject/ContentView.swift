//
//  ContentView.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = GameModel.shared
    @ObservedObject var viewModel = ContentViewModel()
    
    @State var inputString:String = ""
    
    var body: some View {
        VStack{
            TextField(text: $inputString, label: {
                Text("请输入文本")
            })
            HStack{
                Button(action: {
                    viewModel.prepare(inputString: inputString)
                }, label: {
                    Text("确定")
                })
                
                Button(action: {
                    viewModel.step()
                }, label: {
                    Text("步进")
                })
                
            }
            Text("输入页面：\(model.pageSequence)")
            
            Text("FIFO结果:\(String(describing: viewModel.FIFOexecutor?.pageFrames))")
            Text("LRU结果:\(String(describing: viewModel.LRUexecutor?.pageFrames))")
            Text("LFU结果:\(String(describing: viewModel.LFUexecutor?.pageFrames))")
            Text("频率结果:\(String(describing: viewModel.LFUexecutor?.frequency))")
            
        }
        .frame(minWidth: 300,minHeight: 300)
    }
}

#Preview {
    ContentView()
}
