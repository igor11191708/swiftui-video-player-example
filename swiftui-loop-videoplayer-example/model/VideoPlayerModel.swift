//
//  VideoModel.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 30.08.24.
//

import SwiftUI

struct VideoPlayerModel: Hashable{
    
    static let data : [VideoPlayerModel] = [
        .init(name: "Video", icon: "display", color: .green),
        .init(name: "Video1", icon: "video", color: .blue),
        .init(name: "Video2", icon: "airplayvideo.circle", color: .blue),
        .init(name: "Video6", icon: "appletvremote.gen2", color: .blue),
        .init(name: "Video8", icon: "cloud", color: .blue),
        .init(name: "Video3", icon: "e.circle", color: .red)
    ]
   
    let name : String
    
    let icon : String
    
    let color : Color
    
    init(name: String, icon: String, color: Color) {
        self.icon = icon
        self.name = name
        self.color = color
    }
}
