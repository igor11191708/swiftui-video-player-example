//
//  BrightnessView.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 12.09.24.
//

import SwiftUI
import swiftui_loop_videoplayer

struct BrightnessSlider: View {
    
    @Binding public var playbackCommand: PlaybackCommand
    
    @State private var brightness: Float = 0.0
    
    var body: some View {
        HStack {
            Text("Brightness")
                .frame(width: 102, alignment: .leading)
                Slider(value: $brightness, in: 0.0...1.0, step: 0.1) {
                Text(String(format: "%.2f", brightness))
                Spacer()
            }
        }
        .onChange(of: brightness, perform: onBrightnessChange)
    }
    
    private func onBrightnessChange(value: Float){
        playbackCommand = .brightness(value)
    }
}
