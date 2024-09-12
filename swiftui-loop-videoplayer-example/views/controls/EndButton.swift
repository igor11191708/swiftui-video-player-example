//
//  EndButton.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 12.09.24.
//

import swiftui_loop_videoplayer
import SwiftUI

struct EndButton: View {
    
    @Binding public var playbackCommand: PlaybackCommand
    
    var body: some View {
        // Button to move playback to the end and pause
        makeButton(action: {
            end()
        }, imageName: "forward.end.fill")
    }
    
    private func end() {
        playbackCommand = .end
    }
}
