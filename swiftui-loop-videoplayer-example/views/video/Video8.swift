//
//  Video8.swift
//  loop_player
//
//  Created by Igor Shelopaev on 15.08.24.
//

import swiftui_loop_videoplayer
import SwiftUI
import AVFoundation

struct Video8: VideoTpl {
    @State private var playbackCommand: PlaybackCommand = .play
    static let initVideo = "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8"
    @State private var isEditing = false
    @State private var selectedVideoURL = Video8.initVideo
    @State private var currentTime: Double = 0
    @State private var duration: Double? = nil
    
    let videoOptions = [
        "Apple HLS Stream from URL": "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8",
        "Big Buck Bunny from URL": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "Elephant's Dream from URL": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
    ]
    
    @State private var settings: VideoSettings = .init {
        SourceName(Video8.initVideo)
        Gravity(.resizeAspectFill)
        TimePublishing()
        Loop()
    }

    var body: some View {
        VStack {
            ZStack {
                ExtVideoPlayer(settings: $settings, command: $playbackCommand)
                    .accessibilityIdentifier("Video8_ExtVideoPlayer")
                    .onPlayerTimeChange { newTime in
                        if !isEditing {
                            currentTime = newTime
                        }
                    }
                    .onPlayerEventChange{ events in
                        print(events)
                        events.forEach{
                            if case .seek(let success, let currentTime) = $0{
                                if success{
                                    self.currentTime = currentTime
                                    playbackCommand = .play
                                }
                                isEditing = false
                            }
                        }
                    }
            }
            .ignoresSafeArea() 
            .tag(selectedVideoURL)
            .background(Color("app_blue"))
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Picker("Select Video", selection: $selectedVideoURL) {
                        ForEach(videoOptions.keys.sorted(), id: \.self) { key in
                            Text(key).tag(videoOptions[key]!)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedVideoURL) { newURL in
                        handleVideoSelectionChange(newURL)
                    }
                }
            }
            
            HStack {
                Text(formatTime(currentTime))
                Slider(value: $currentTime, in: 0...(duration ?? 0), onEditingChanged: onEditingChanged)
                    .disabled(duration == nil || isEditing == true)
                Text(formatTime(duration ?? 0))
            }
            .padding()
        }
        .onAppear {
            handleVideoSelectionChange(selectedVideoURL)
        }
    }
    
    private func handleVideoSelectionChange(_ newURL: String) {
        loadVideo(from: newURL)
        currentTime = 0
        duration = nil
        settings = VideoSettings {
            SourceName(newURL)
            Gravity(.resizeAspectFill)
            Loop()
        }
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func loadVideo(from url: String) {
        guard let videoURL = URL(string: url) else { return }
        let asset = AVAsset(url: videoURL)
        
        Task {
            if let duration = try? await asset.load(.duration){
                self.duration = duration.seconds
            }
        }
    }
    
    private func onEditingChanged(editing: Bool) {
        isEditing = true
        if !editing {
            seekToTime(currentTime)
        }
    }
    
    private func seekToTime(_ time: Double) {
        playbackCommand = .seek(to: time)
    }
}
