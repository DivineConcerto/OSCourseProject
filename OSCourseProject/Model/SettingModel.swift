//
//  GameModel.swift
//  OSCourseProject
//
//  Created by 张炫阳 on 2024/6/3.
//

import Foundation

class SettingModel:ObservableObject{

    
    // MARK: - 运行变量
    var pageCount:Int = 0 // 页面个数
    var pageFrameCount:Int = 5 // 页框数
    var storageTime:Double = 0.1 // 内存存取时间
    var interruptionTime:Double = 0.5 // 缺页中断时间
    var useCache:Bool = false // 是否使用快表
    var cacheLookupTime:Double = 0.1 // 快表时间
    var cacheCapacity:Int = 3 // 快表大小
    var intervals:Double = 0.5 // 间隔时间
    
    // MARK: - 外观设置
    var fontName =  "WeibeiSC-Bold" //"STSongti-SC-Regular"


    var resultList:[Result] = []
    
    // MARK: - 保存设置与加载设置
    func saveSetting(){
        
    }
    
    func loadSetting(){
        
    }

    
    
    static let shared = SettingModel()
    private init(){
        
    }
}
