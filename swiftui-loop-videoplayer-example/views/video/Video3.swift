//
//  Video3.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor  on 29.08.24.
//

import SwiftUI
import swiftui_loop_videoplayer

struct Video3 : VideoTpl{
    
    @State var error : VPErrors? = nil
    
    var body: some View{
        ZStack(alignment: .center) {
            ExtVideoPlayer{
                VideoSettings{
                    SourceName("swipe_")
                    EColor(.orange)
                    EFontSize(33)
                    Loop()
                }
            }
            .accessibilityIdentifier("Video3_ExtVideoPlayer")
            .onPlayerEventChange { events in
                events.forEach { item in
                    print(item)
                    if case .error(let e) = item {
                        error = e
                        print(e.description)
                    }
                }
            }
        } .background(Color("app_blue"))
    }
}
