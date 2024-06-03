//
//  SettingView.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import SwiftUI

struct SettingView: View {
    
    @State var inputFrameCount:String = ""
    @State var inputStorageTime:String = ""
    @State var inputInterruptionTime:String = ""
    @State var inputCacheLookupTime:String = ""
    @State var inputUseCahce = false
    
    @ObservedObject var model = GameModel.shared
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            HStack{
                VStack{
                    HStack{
                        Text("驻内存页面数:")
                        TextField(text: $inputFrameCount, label: {
                            Text("在这里输入")
                        })
                    }
                    HStack{
                        Text("内存存取时间:")
                        TextField(text: $inputStorageTime, label: {
                            Text("在这里输入")
                        })
                    }
                    HStack{
                        Text("缺页中断时间:")
                        TextField(text: $inputInterruptionTime, label: {
                            Text("在这里输入")
                        })
                    }
               
                }
                VStack(alignment: .center){
                    HStack{
                        Toggle(isOn: $inputUseCahce, label: {
                            Text("是否使用快表")
                        })
                    }
                    
                    HStack{
                        Text("快表查询时间:")
                        TextField(text: $inputCacheLookupTime, label: {
                            Text("在这里输入")
                        })
                    }
                    
                }
            }
            
            Button("保存并返回"){
                model.pageFrameCount = Int(inputFrameCount) ?? 3
                model.storageTime = Double(inputStorageTime) ?? 0.1
                model.interruptionTime = Double(inputInterruptionTime) ?? 0.1
                model.cacheLookupTime = Double(inputCacheLookupTime) ?? 0.1
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear{
            loadData()
        }
        .frame(width: 400,height: 100)
        .padding()
    }
    
    
    func loadData(){
        inputUseCahce = model.useCache
        inputFrameCount = String(model.pageFrameCount)
        inputStorageTime = String(format: "%.1f", model.storageTime)
        inputInterruptionTime = String(format: "%.1f", model.interruptionTime)
        inputCacheLookupTime = String(format: "%.1f", model.cacheLookupTime)
    }
}

#Preview {
    SettingView()
}
