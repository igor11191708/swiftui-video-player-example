//
//  Video6.swift
//  loop_player
//
//  Created by Igor Shelopaev on 09.08.24.
//
import swiftui_loop_videoplayer
import SwiftUI
import AVFoundation
import CoreImage

struct Video6: VideoTpl {
    
    // MARK: - Testing
    
    static let videoPrefix : String = "Video6"
    
    static var videoPlayerIdentifier : String {  "\(videoPrefix)_ExtVideoPlayer" }
    
    // MARK: - Public properties
    
    @State public var playbackCommand: PlaybackCommand = .idle
    
    @State public var settings = VideoSettings {
        SourceName("apple_logo")
        Loop()
        Mute()
    }
    
    // MARK: - Life circle
    
    var body: some View {
        ResponsiveStack(spacing : 0) {
                ExtVideoPlayer(
                    settings : $settings,
                    command: $playbackCommand
                )
                .accessibilityIdentifier(Self.videoPlayerIdentifier)
                Spacer()
                VStack(alignment : .leading, spacing: 15) {
                    playbackControlsTpl
                    VectorToggle(playbackCommand: $playbackCommand)
                    FiltersPicker(playbackCommand: $playbackCommand)
                    /// Brightness and Contrast: These settings function also filters but are managed separately from the filter stack. Adjustments to brightness and contrast are applied additionally and independently of the image filters.
                    /// Independent Management: Developers should manage brightness and contrast adjustments through their dedicated methods or properties to ensure these settings are accurately reflected in the video output.
                    BrightnessSlider(playbackCommand: $playbackCommand)
                    ContrastSlider(playbackCommand: $playbackCommand)
                }.padding(.horizontal)
        }
    }

    @ViewBuilder
    private var playbackControlsTpl: some View{
        // Control Buttons
            HStack {
                Spacer()
                BeginButton(playbackCommand: $playbackCommand)
                PlayButton(playbackCommand: $playbackCommand)
                SeekButton(playbackCommand: $playbackCommand)
                EndButton(playbackCommand: $playbackCommand)
                MuteButton(playbackCommand: $playbackCommand)
                Spacer()
            }
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 50).fill(.ultraThinMaterial))
    }
}
