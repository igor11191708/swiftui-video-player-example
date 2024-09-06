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
    
    static public let videoPrefix : String = "Video8"
    
    static public var videoPlayerIdentifier : String {
        "\(videoPrefix)_ExtVideoPlayer"
    }
    
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
    
    @State private var settings = getSettings(for: Video8.initVideo)

    var body: some View {
        VStack {
            ZStack {
                ExtVideoPlayer(settings: $settings, command: $playbackCommand)
                    .accessibilityIdentifier(Self.videoPlayerIdentifier)
                    .onPlayerTimeChange(perform: onPlayerTimeChange)
                    .onPlayerEventChange(perform: onPlayerEventChange)
            }
            .ignoresSafeArea() 
            .tag(selectedVideoURL)
            .background(Color("app_blue"))
            .toolbar { toolbarTpl }
             sliderTpl
        }
        .onAppear {
            handleVideoSelectionChange(selectedVideoURL)
        }
    }
    
    private func onPlayerTimeChange(newTime: Double){
        if !isEditing {
            currentTime = newTime
        }
    }
    
    private func onPlayerEventChange(events: [PlayerEvent]){
        print(events)
        events.forEach{
            if case .seek(let success, let currentTime) = $0{
                if success{
                    self.currentTime = currentTime
                }
                isEditing = false
            }
        }
    }
    
    private func handleVideoSelectionChange(_ newURL: String) {
        loadVideo(from: newURL)
        currentTime = 0
        duration = nil
        settings = getSettings(for: newURL)
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
        if !editing {
            seekToTime(currentTime)
        }
    }
    
    private func seekToTime(_ time: Double) {
        let command: PlaybackCommand  = .seek(to: time)
        if playbackCommand != command{
            isEditing = true
            playbackCommand = command
        }
    }
    
    @ViewBuilder
    private var sliderTpl: some View{
        HStack {
            Text(formatTime(currentTime))
            Slider(value: $currentTime, in: 0...(duration ?? 0), onEditingChanged: onEditingChanged)
                .disabled(duration == nil || isEditing == true)
            Text(formatTime(duration ?? 0))
        }.padding()
    }
    
    @ToolbarContentBuilder
    private var toolbarTpl: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            pickerContent()
        }
    }

    @ViewBuilder
    private func pickerContent() -> some View {
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

// MARK: - Fileprivate

fileprivate func getSettings(for name: String) -> VideoSettings{
    VideoSettings {
        SourceName(name)
        Gravity(.resizeAspectFill)
        TimePublishing()
        Loop()
    }
}

fileprivate func formatTime(_ time: Double) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%d:%02d", minutes, seconds)
}
