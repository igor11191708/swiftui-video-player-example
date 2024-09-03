//
//  Video.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor  on 29.08.24.
//

import SwiftUI
import swiftui_loop_videoplayer

struct Video : VideoTpl{
    
    let fileName : String = "swipe"
    
    @State var loopCount : Int = 0
    
    var body: some View{
            ZStack{
                ExtVideoPlayer{
                    VideoSettings{
                        SourceName(fileName)
                        Ext("mp4")
                        Gravity(.resizeAspectFill)
                        Loop()
                    }
                }
                .onPlayerEventChange { events in
                    let count = events.filter {
                        if case .currentItemChanged(_) = $0 {
                            return true
                        } else {
                            return false
                        }
                    }.count
                    loopCount += count
                }
                .accessibilityIdentifier("Video_ExtVideoPlayer")
                Text("Loop count \(loopCount)")
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .accessibilityIdentifier("Video_LoopCounter")
            }.ignoresSafeArea()
    }
}
