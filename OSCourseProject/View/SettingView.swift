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
    @State var inputCacheCapacity:String = ""
    
    var model = SettingModel.shared


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
                VStack(alignment: .leading){
                    HStack{
                        Toggle(isOn: $inputUseCahce, label: {
                            Text("是否使用快表")
                        })
                    }
                    
                    HStack{
                        Text("快表容量大小:")
                        TextField(text: $inputCacheCapacity, label: {
                            Text("在这里输入")
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
            .font(.custom(model.fontName, size: 14))
            
            Button("保存设置"){
                model.pageFrameCount = Int(inputFrameCount) ?? 5
                model.storageTime = Double(inputStorageTime) ?? 0.1
                model.interruptionTime = Double(inputInterruptionTime) ?? 0.5
                model.cacheLookupTime = Double(inputCacheLookupTime) ?? 0.01
                model.useCache = inputUseCahce
                model.cacheCapacity = Int(inputCacheCapacity) ?? 3
            }
            .font(.custom(model.fontName, size: 15))
        }
        .onAppear{
             loadData()
        }
        .padding()
    }
    
    
    func loadData(){
        inputUseCahce = model.useCache
        inputFrameCount = String(model.pageFrameCount)
        inputStorageTime = String(format: "%.2f", model.storageTime)
        inputInterruptionTime = String(format: "%.2f", model.interruptionTime)
        inputCacheLookupTime = String(format: "%.2f", model.cacheLookupTime)
        inputCacheCapacity = String(Int(model.cacheCapacity))
    }
}

#Preview {
    SettingView()
}
