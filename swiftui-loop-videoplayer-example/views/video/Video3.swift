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
        ZStack(alignment: .top) {
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
                    if case .error(let e) = item {
                        error = e
                    }
                }
            }
            if let error{
                Text("\(error.description)")
                    .padding()
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(50)
                    .accessibilityIdentifier("Video3_Error")
            }
        } .background(Color("app_blue"))
    }
}
