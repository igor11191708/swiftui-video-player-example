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
    
    var body: some View{
        ZStack(alignment: .center) {
            ExtVideoPlayer{
                VideoSettings{
                    SourceName(fileName)
                    Ext("mp4")
                    Gravity(.resizeAspectFill)
                    Loop()
                }
            }
            .accessibilityIdentifier("Video_ExtVideoPlayer")
        }.ignoresSafeArea()
    }
}
