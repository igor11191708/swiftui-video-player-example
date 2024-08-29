//
//  Video3.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor  on 29.08.24.
//

import SwiftUI
import swiftui_loop_videoplayer

struct Video3 : View{
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
        } .background(Color("app_blue"))
    }
}
