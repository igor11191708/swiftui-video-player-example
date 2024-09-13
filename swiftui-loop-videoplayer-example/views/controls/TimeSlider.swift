//
//  TimeSlider.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 12.09.24.
//

import SwiftUI
import swiftui_loop_videoplayer

struct TimeSlider: View {
    
    let duration : Double
    
    @Binding public var playbackCommand: PlaybackCommand
    
    @Binding var currentTime : Double
    
    @Binding var isSeeking : Bool
    
    var body: some View {
        sliderTpl
    }
    
    @ViewBuilder
    private var sliderTpl: some View{
        HStack {
            Text(formatTime(currentTime))
            Slider(value: $currentTime, in: 0...duration, onEditingChanged: onEditingChanged)
                .disabled(duration == 0 || isSeeking == true)
            Text(formatTime(duration))
        }.padding()
    }
    
    private func onEditingChanged(editing: Bool) {
        if !editing {
            seekToTime(currentTime)
        }
    }
    
    private func seekToTime(_ time: Double) {
        let command: PlaybackCommand  = .seek(to: time)
        if playbackCommand != command{
            isSeeking = true
            playbackCommand = command
        }else{
            isSeeking = false
        }
    }
}

fileprivate func formatTime(_ time: Double) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%d:%02d", minutes, seconds)
}
