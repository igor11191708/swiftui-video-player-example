//
//  ContrastView.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 12.09.24.
//

import SwiftUI
import swiftui_loop_videoplayer

struct ContrastSlider: View {
    
    @Binding public var playbackCommand: PlaybackCommand
    
    @State private var contrast: Float = 0.0
    
    var body: some View {
        HStack {
            Text("Contrast")
                .frame(width: 102, alignment: .leading)
            Slider(value: $contrast, in: 1.0...2.0, step: 0.1) {
                Text(String(format: "%.2f", contrast))
                Spacer()
            }
        }
        .onChange(of: contrast, perform: onContrastChange)
    }
    
    private func onContrastChange(value: Float){
        playbackCommand = .contrast(value)
    }
}
