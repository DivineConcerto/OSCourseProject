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
    @State var showSettingView = false
    
    @State var inputString:String = ""
    
    // 随机生成
    @State var randomPageCount:String = ""
    @State var randomPageMin:String = ""
    @State var randomPageMax:String = ""
    
    var body: some View {
        HStack{
            prepareView
            Divider()
            VStack{
                HStack{
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("开始")
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("暂停")
                    })
                    Button(action: {
                        viewModel.step()
                    }, label: {
                        Text("步进")
                    })
                }
                HStack{
                    Text("输入序列：")
                    TextField(text: $viewModel.pageSequenceString, label: {
                        Text("")
                    })
                    
                }
                
                LazyVGrid(columns: [GridItem(),GridItem()], content: {
                    VStack{
                        HStack{
                            Text("FIFO结果：")
                            TextField(text: $viewModel.fifoResultString, label: {
                                Text("")
                            })
                        }
                       
                        if let time = viewModel.FIFOexecutor?.timeSpent{
                            Text("缺页次数:\(viewModel.FIFOexecutor!.interruptionCount)")
                            Text("消耗时间：\(String(format: "%.2f", time))")

                        }else{
                            Text("缺页次数：0")
                            Text("消耗时间：0.00")
                        }
                    }
                    
                    VStack{
                        HStack {
                            Text("LRU结果：")
                            TextField(text: $viewModel.lruResultString, label: {
                                Text("")
                            })
                        }
                        if let time = viewModel.LRUexecutor?.timeSpent{
                            Text("缺页次数:\(viewModel.LRUexecutor!.interruptionCount)")
                            Text("消耗时间：\(String(format: "%.2f", time))")
                        }else{
                            Text("缺页次数:0")
                            Text("消耗时间：0.00")
                        }
                    }
                    
                    VStack{
                        HStack {
                            Text("LFU结果：")
                            TextField(text: $viewModel.lfuResultString, label: {
                                Text("")
                            })
                        }
                        if let time = viewModel.LFUexecutor?.timeSpent{
                            Text("缺页次数:\(viewModel.LFUexecutor!.interruptionCount)")
                            Text("消耗时间：\(String(format: "%.2f", time))")
                        }else{
                            Text("缺页次数:0")
                            Text("消耗时间：0.00")
                        }
                    }
                    
                    VStack{
                        HStack {
                            Text("opt结果：")
                            TextField(text: $viewModel.optResultString, label: {
                                Text("")
                            })
                        }
                        if let time = viewModel.OPTexecutor?.timeSpent{
                            Text("缺页次数:\(viewModel.OPTexecutor!.interruptionCount)")
                            Text("消耗时间：\(String(format: "%.2f", time))")
                        }else{
                            Text("缺页次数:0")
                            Text("消耗时间：0.00")
                        }
                    }
                    
                })
            }
              
            }
        .padding()
        .sheet(isPresented: $showSettingView, content: {
            SettingView()
                .transition(.slide)
                .navigationTitle("设置")
        })
    }
    
    var prepareView:some View{
        VStack{
            Divider()
            Text("随机生成")
            HStack{
                Text("生成个数:")
                TextField(text: $randomPageCount, label: {
                    Text("个数")
                })
                .frame(width: 50)
            }
            
            HStack{
                Text("生成范围:")
                TextField(text: $randomPageMin, label: {
                    Text("最小值")
                })
                .frame(width: 50)
                Text(" - ")
                TextField(text: $randomPageMax, label: {
                    Text("最大值")
                })
                .frame(width: 50)
            }
            
            Button(action: {
                inputString = viewModel.generatePageSequenceRandomly(count: Int(randomPageCount) ?? 5, minValue: Int(randomPageMin) ?? 0, maxValue: Int(randomPageMax) ?? 9)
            }, label: {
                Text("生成")
                    .frame(width: 60,height: 30)
            })
            
            Divider()
            
            Text("用户输入")
            TextField(text: $inputString, label: {
                Text("请输入序列")
            })
            .frame(maxWidth: 200)
            Divider()
            Button(action: {
                viewModel.prepare(inputString: inputString)
            }, label: {
                Text("确定")
                    .frame(width: 100,height: 30)
            })
            Button(action: {
                showSettingView = true
            }, label: {
                Text("设置")
                    .frame(width: 100,height: 30)
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
