//
//  MuteButton.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 12.09.24.
//
import swiftui_loop_videoplayer
import SwiftUI

struct MuteButton : View {
    
    @Binding public var playbackCommand: PlaybackCommand
    
    @State private var toggleMute: Bool = true
    
    var body: some View {
        // Button to toggle mute and unmute
        makeButton(action: {
            toggleMute.toggle()
            playbackCommand = toggleMute ? .mute : .unmute
        }, imageName: toggleMute ? "speaker.slash.fill" : "speaker.2.fill")
    }
}

