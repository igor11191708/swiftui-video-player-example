//
//  VideoModel.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 30.08.24.
//

import SwiftUI


struct VideoPlayerModel: Hashable {
    
    static let data : [VideoPlayerModel] = [
        .init(name: "Video11", icon: "display", color: .green),
        .init(name: "Video1", icon: "video", color: .blue),
        .init(name: "Video2", icon: "airplayvideo.circle", color: .blue),
        .init(name: "Video6", icon: "appletvremote.gen2", color: .blue),
        .init(name: "Video8", icon: "cloud", color: .blue),
        .init(name: "Video3", icon: "e.circle", color: .red),
    ]
    
    let name: String
    let icon: String
    let color: Color
    
    init(name: String, icon: String, color: Color) {
        self.icon = icon
        self.name = name
        self.color = color
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(icon)
        hasher.combine(color)
    }
    
    static func ==(lhs: VideoPlayerModel, rhs: VideoPlayerModel) -> Bool {
        return lhs.name == rhs.name &&
               lhs.icon == rhs.icon &&
               lhs.color == rhs.color
    }
}

@ViewBuilder
func getDestination(for name: String) -> some View {
    switch name{
        case "Video11": Video11()
        case "Video1": Video1()
        case "Video2": Video2()
        case "Video6": ScrollView{
            VStack(spacing: 29){
                Video6(videoName: "apple_logo")
                Divider()
                Video6(videoName: "swipe")
            }
        }
        case "Video8": Video8()
        case "Video3": Video3()
        default : EmptyView()
    }
}
