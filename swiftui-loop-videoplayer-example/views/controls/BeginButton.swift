//
//  BeginButton.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 12.09.24.
//

import swiftui_loop_videoplayer
import SwiftUI

struct BeginButton: View {
    
    @Binding public var playbackCommand: PlaybackCommand
    
    var body: some View {
        // Button to move playback to the beginning and pause
        makeButton(action: {
            begin()
        }, imageName: "backward.end.fill")
    }
    
    private func begin() {
        playbackCommand = .begin
    }
}
