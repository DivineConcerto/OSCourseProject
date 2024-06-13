//
//  ResultView.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/5.
//

import SwiftUI

struct RecordView: View {
    
    @ObservedObject var model = SettingModel.shared
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(model.resultList,id:\.self){ result in
                    Text("\(result.inputSequence)")
                }
            }
        }
        
        .onAppear{
            
        }
    }
}

#Preview {
    RecordView()
}
