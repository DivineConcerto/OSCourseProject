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
                Text("花费时间:\(Int(timeDuration))秒")
                Text("缺页次数:\(interruptionCount)次")
            }
        }
        .font(.custom(settingModel.fontName, size: 15))
        .padding()
        .border(Color.black)
    }
}


