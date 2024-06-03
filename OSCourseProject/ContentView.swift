//
//  ContentView.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = GameModel.shared
    @State var inputString:String = ""
    
    var body: some View {
        VStack{
            TextField(text: $inputString, label: {
                Text("请输入文本")
            })
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("确定")
            })
            
        }
        .frame(minWidth: 300,minHeight: 300)
    }
}

#Preview {
    ContentView()
}
