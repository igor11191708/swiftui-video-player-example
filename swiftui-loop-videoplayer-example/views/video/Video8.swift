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
    
    @StateObject var viewModel = Video8ViewModel()
    
    static let videoPrefix : String = "Video8"
    
    static var videoPlayerIdentifier : String {  "\(videoPrefix)_ExtVideoPlayer" }
    
    // MARK: - Public properties
    
    @State public var playbackCommand: PlaybackCommand = .idle
    
    @State public var settings = getSettings(for: initVideo)
    
    // MARK: - Private properties
    
    @State private var isEditing = false
    
    @State private var selectedVideoURL = initVideo
    
    @State private var currentTime: Double = 0

    var body: some View {
        VStack {
            ZStack {
                ExtVideoPlayer(settings: $settings, command: $playbackCommand)
                    .accessibilityIdentifier(Self.videoPlayerIdentifier)
                    .onPlayerTimeChange(perform: onPlayerTimeChange)
                    .onPlayerEventChange(perform: onPlayerEventChange)
            }
            .ignoresSafeArea() 
            .background(Color("app_blue"))
             sliderTpl
        }
        .toolbar { toolbarTpl }
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
        viewModel.getDuration(from: newURL)
        settings = getSettings(for: newURL)
        currentTime = 0
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
        }else{
            isEditing = false
        }
    }
    
    @ViewBuilder
    private var sliderTpl: some View{
        HStack {
            Text(formatTime(currentTime))
            Slider(value: $currentTime, in: 0...(viewModel.duration ?? 0), onEditingChanged: onEditingChanged)
                .disabled(viewModel.duration == nil || isEditing == true)
            Text(formatTime(viewModel.duration ?? 0))
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

fileprivate let videoOptions = [
    "Apple HLS Stream from URL": "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8",
    "Big Buck Bunny from URL": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "Elephant's Dream from URL": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
]

fileprivate let initVideo = "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8"
