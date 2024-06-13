//
//  MatrixView.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/5.
//

import SwiftUI

struct MatrixView: View {
    
    var array = [1,2,3,4,5,6,7]
    
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(array,id: \.self){ element in
                    BlockView(number: element)
                }
                .animation(.easeInOut)
            }
        }
    }
}

struct BlockView:View {
    
    var number:Int = 0
    
    var body: some View {
        ZStack{
            Rectangle()
                .stroke()
                .frame(width: 20,height: 20)
            Text("\(number)")
                .frame(width: 20,height: 20)
        }
    }
}

#Preview {
    MatrixView()
}
