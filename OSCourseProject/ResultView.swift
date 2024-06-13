//
//  ResultView.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/12.
//

import SwiftUI

struct ResultView: View {
    
    var title:String
    var inputNumber:Int
    var timeDuration:Double
    var interruptionCount:Int
    var pageSequence:[Int]
    
    var settingModel = SettingModel.shared
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(title)
                Text("当前输入:")
                BlockView(number: inputNumber)
            }
            MatrixView(array: pageSequence)
            HStack{
                Text("花费时间: \(String(format: "%.2f", timeDuration))")
                Text("缺页次数:\(interruptionCount)")
            }
        }
        .font(.custom(settingModel.fontName, size: 15))
        .padding()
        .border(Color.black)
    }
}

struct ShowView:View {
    
    var recordList:[Record] =
    [
        Record(inputPage: 2, content: [2,3,4,1,6]),
        Record(inputPage: 1, content: [2,3,4,1,5]),
        Record(inputPage: 3, content: [2,4,3,1,2])
    ]
    
    
    var body: some View {
        VStack{
            List{
                ForEach(recordList.indices, id: \.self) { index in
                    let element = recordList[index]
                    VStack(alignment:.leading){
                        HStack{
                            Text("第\(index + 1)步")
                            
                            Text("访问")
                            BlockView(number: element.inputPage)
                        }
                        HStack{
                                MatrixView(array: element.content)

                        }
                    }
                    .font(.custom(SettingModel.shared.fontName, size: 12))
                    .padding()
                }
            }
        }
    }
}


#Preview{
    ShowView()
}
