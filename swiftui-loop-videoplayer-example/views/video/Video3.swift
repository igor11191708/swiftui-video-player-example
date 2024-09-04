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
    
    var getOffsetY : CGFloat{
        error == nil ? -1002 : 0
    }
    
    var body: some View{
        ZStack(alignment: .center) {
            ExtVideoPlayer{
                VideoSettings{
                    SourceName("swipe_")
                    ErrorWidgetOff()
                    Loop()
                }
            }
            .accessibilityIdentifier("Video3_ExtVideoPlayer")
            .onPlayerEventChange { events in
                events.forEach { item in
                    if case .error(let e) = item {
                        withAnimation(.spring){
                            error = e
                        }
                    }
                }
            }
            errorTpl
        } .background(Color("app_blue"))
    }
    
    @ViewBuilder
    var errorTpl : some View{
        Text("\(error?.description ?? "")")
            .padding()
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(50)
            .font(.largeTitle)
            .offset(y: getOffsetY )
            .accessibilityIdentifier("Video3_Error")
    }
}
