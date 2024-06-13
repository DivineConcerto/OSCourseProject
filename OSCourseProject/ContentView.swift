//
//  ContentView.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var settingModel = SettingModel.shared
    @ObservedObject var viewModel = ContentViewModel.shared
    @State var showSettingView = false
    @State var showResultView = false
    
    @State var inputString:String = ""
    
    // 随机生成
    @State var randomPageCount:String = ""
    @State var randomPageMin:String = ""
    @State var randomPageMax:String = ""
    
    var body: some View {
        VStack{
            TabView{
                prepareView
                .tabItem {
                    Text("做点准备🤗")
                }
                executeView
                    .tabItem {
                        Text("开始测试😇")
                    }
                RecordView()
                    .tabItem {
                        Text("看看结果🤩")
                    }
                SettingView()
                    .tabItem {
                        Text("设置一下😅")
                    }            
            }
        }
        .padding()
    }
    
    var executeView:some View{
        VStack{
            HStack{
                Button(action: {
                    viewModel.start()
                }, label: {
                    Text("开始")
                        .font(.custom(settingModel.fontName, size: 20))

                })
                if viewModel.isPaused{
                    Button("运行"){
                        viewModel.resume()
                    }
                    .font(.custom(settingModel.fontName, size: 20))
                }else{
                    Button(action: {
                        viewModel.pause()
                    }, label: {
                        Text("暂停")
                            .font(.custom(settingModel.fontName, size: 20))
                        
                    })
                }
                Button(action: {
                    viewModel.step()
                }, label: {
                    Text("步进")
                        .font(.custom(settingModel.fontName, size: 20))

                })
            }
            HStack{
                Text("输入序列：")
                    .font(.custom(settingModel.fontName, size: 15))
                MatrixView(array: viewModel.pageSequence)
            }
            LazyVGrid(columns: [GridItem(),GridItem()],spacing: 10, content: {
                
                if let fifo = viewModel.FIFOexecutor, let lru = viewModel.LRUexecutor, let lfu = viewModel.LFUexecutor, let opt = viewModel.OPTexecutor {
                    if let fifoInputNumber = viewModel.getPageSequenceValue(at: viewModel.fifoPoint) {
                        ResultView(title: "FIFO算法", inputNumber: fifoInputNumber, timeDuration: fifo.timeSpent, interruptionCount: fifo.interruptionCount, pageSequence: fifo.pageFrames)
                    }
                    if let lruInputNumber = viewModel.getPageSequenceValue(at: viewModel.lruPoint) {
                        ResultView(title: "LRU算法", inputNumber: lruInputNumber, timeDuration: lru.timeSpent, interruptionCount: lru.interruptionCount, pageSequence: lru.pageFrames)
                    }
                    if let lfuInputNumber = viewModel.getPageSequenceValue(at: viewModel.lfuPoint) {
                        ResultView(title: "LFU算法", inputNumber: lfuInputNumber, timeDuration: lfu.timeSpent, interruptionCount: lfu.interruptionCount, pageSequence: lfu.pageFrames)
                    }
                    if let optInputNumber = viewModel.getPageSequenceValue(at: viewModel.optPoint) {
                        ResultView(title: "OPT算法", inputNumber: optInputNumber, timeDuration: opt.timeSpent, interruptionCount: opt.interruptionCount, pageSequence: opt.pageFrames)
                    }
                }

            })
        }
        .padding()
    }
    
    var prepareView:some View{
        HStack{
            VStack(alignment:.center){
                Text("随机生成")
                    .font(.custom(settingModel.fontName, size: 20))
                    .padding(.bottom,0)
                HStack{
                    Text("生成个数:")
                        .font(.custom(settingModel.fontName, size: 15))
                    TextField(text: $randomPageCount, label: {
                        Text("")

                    })
                    .frame(width: 50)
                }
                
                HStack{
                    Text("生成范围:")
                        .font(.custom(settingModel.fontName, size: 15))
                    TextField(text: $randomPageMin, label: {
                        Text("")
                    })
                    .frame(width: 50)
                    Text(" - ")
                    TextField(text: $randomPageMax, label: {
                        Text("")
                    })
                    .frame(width: 50)
                }
                
                Button(action: {
                    inputString = viewModel.generatePageSequenceRandomly(count: Int(randomPageCount) ?? 5, minValue: Int(randomPageMin) ?? 0, maxValue: Int(randomPageMax) ?? 9)
                }, label: {
                    Text("确认生成")
                        .font(.custom(settingModel.fontName, size: 20))
                        .shadow(radius: 10)
                })
            }.padding()
            
            Divider()
            VStack{
                Text("用户输入")
                    .font(.custom(settingModel.fontName, size: 20))
                    .padding(.bottom,35)
                TextField(text: $inputString, label: {
                    Text("")
                })
                HStack{
                    Button(action: {
                        viewModel.prepare(inputString: inputString)
                    }, label: {
                        Text("确定")
                            .font(.custom(settingModel.fontName, size: 20))
                    })
                    Button(action: {
                        showSettingView = true
                    }, label: {
                        Text("设置")
                            .font(.custom(settingModel.fontName, size: 20))
                        
                    })
                    Button(action: {
                        showResultView = true
                    }, label: {
                        Text("记录")
                            .font(.custom(settingModel.fontName, size: 20))
                    })
                }
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
