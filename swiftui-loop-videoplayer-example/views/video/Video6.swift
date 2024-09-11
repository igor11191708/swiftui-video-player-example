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
import CompactSlider
/// The slider from the package https://github.com/buh/CompactSlider

struct Video6: VideoTpl {
    
    static let videoPrefix : String = "Video6"
    
    static var videoPlayerIdentifier : String {  "\(videoPrefix)_ExtVideoPlayer" }
    
    @State private var playbackCommand: PlaybackCommand = .idle
    
    @State private var isPlaying: Bool = true
    
    @State private var isLogoAdded: Bool = false
    
    @State private var isSeeking : Bool = false
    
    @State private var isMuted: Bool = true
    
    @State private var selectedFilterIndex: Int = 0
    
    @State var brightness: Float = 0.0
    
    @State var contrast: Float = 1.0

    @State private var settings = VideoSettings {
        SourceName("apple_logo")
        Loop()
        Mute()
    }
    
    var body: some View {
        ResponsiveStack(spacing : 0) {
                ExtVideoPlayer(
                    settings : $settings,
                    command: $playbackCommand
                )
                .onPlayerEventChange(perform: onPlayerEventChange)
                .accessibilityIdentifier(Self.videoPlayerIdentifier)
                .onChange(of: playbackCommand, perform: updatePlayingState)
                .onChange(of: isLogoAdded, perform: onVectorChange)
                .onChange(of: brightness, perform: onBrightnessChange)
                .onChange(of: contrast, perform: onContrastChange)
                Spacer()
                VStack(alignment : .leading, spacing: 15) {
                    playbackControlsTpl
                    vectorControlsTpl
                    pickerTpl
                    slidersBar
                }.padding(.horizontal)
        }
    }
    
    private func onVectorChange(value : Bool){
        playbackCommand = value ? .addVector(VectorLogoLayer()) : .removeAllVectors
    }
    
    private func onContrastChange(value: Float){
        playbackCommand = .contrast(value)
    }
    
    private func onBrightnessChange(value: Float){
        playbackCommand = .brightness(value)
    }
    
    private func onPlayerEventChange(events: [PlayerEvent]){
        print(events)
        events.forEach{
            if case .seek(_, _) = $0{
                playbackCommand = .idle
                isSeeking = false
            }
        }
    }
    
    private func updatePlayingState(for command: PlaybackCommand) {
        switch command {
        case .play:
            isPlaying = true
        case .pause:
            isPlaying = false
        default:
            break // No action needed for other commands
        }
    }
    
    private func pause() {
        playbackCommand = .pause
    }
    
    @ViewBuilder
    private var pickerTpl : some View {
        HStack {
            Text("Select Filter")
                .fixedSize(horizontal: true, vertical: false)
                .lineLimit(1)
            Spacer()
            Picker("Select Filter", selection: $selectedFilterIndex) {
                ForEach(0..<filters.count, id: \.self) { index in
                    Text(filters[index].0).tag(index)
                }
            }
            .pickerStyle(.menu)
        }
        .onChange(of: selectedFilterIndex) { newIndex in
            applySelectedFilter(index: newIndex)
        }
    }

    private func applySelectedFilter(index: Int) {
        let filter = filters[index]

        if filter.0 == "None" {
            playbackCommand = .removeAllFilters
        } else if let filter = CIFilter(name: filter.0, parameters: filter.1) {
            playbackCommand = .filter(filter, clear: true)
        } else {
            let filter = ArtFilter()
            playbackCommand = .filter(filter, clear: true)
        }
    }
    
    @ViewBuilder
    private var vectorControlsTpl : some View{
        HStack {
            Toggle("Vector layer", isOn: $isLogoAdded)
                .tint(.blue)
        }
    }
    
    @ViewBuilder
    private var playbackControlsTpl: some View{
        // Control Buttons
            HStack {
                Spacer()
                // Button to move playback to the beginning and pause
                makeButton(action: {
                    playbackCommand = .begin
                    pause()
                }, imageName: "backward.end.fill")
                
                // Button to play the video
                if !isPlaying{
                    makeButton(action: {
                        playbackCommand = .play
                    }, imageName: "play.fill", backgroundColor: .ultraThin)
                }else{
                    // Button to pause the video
                    makeButton(action: {
                        playbackCommand = .pause
                    }, imageName: "pause.fill", backgroundColor: .ultraThin)
                }
                // Button to seek back 2 seconds in the video and pause
                makeButton(action: {
                    isSeeking = true
                    playbackCommand = .seek(to: 2.0)
                }, imageName: "gobackward.10")
                .disabled(isSeeking)
                
                // Button to move playback to the end and pause
                makeButton(action: {
                    playbackCommand = .end
                    pause()
                }, imageName: "forward.end.fill")
                
                // Button to toggle mute and unmute
                makeButton(action: {
                    isMuted.toggle()
                    playbackCommand = isMuted ? .mute : .unmute
                }, imageName: isMuted ? "speaker.slash.fill" : "speaker.2.fill")
                Spacer()
            }
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 50).fill(.ultraThinMaterial))
    }
    
    @ViewBuilder
    private var slidersBar: some View{
        /// Brightness and Contrast: These settings function also filters but are managed separately from the filter stack. Adjustments to brightness and contrast are applied additionally and independently of the image filters.
        /// Independent Management: Developers should manage brightness and contrast adjustments through their dedicated methods or properties to ensure these settings are accurately reflected in the video output.
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Brightness")
                    .frame(width: 102, alignment: .leading)
                CompactSlider(value: $brightness, in: 0.0...1.0, step: 0.1) {
                    Text(String(format: "%.2f", brightness))
                    Spacer()
                }
            }
            
            HStack {
                Text("Contrast")
                    .frame(width: 102, alignment: .leading)
                CompactSlider(value: $contrast, in: 1.0...2.0, step: 0.1) {
                    Text(String(format: "%.2f", contrast))
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Fileprivate

// Define the filters with their names and parameters
fileprivate let filters = [
    ("None", [String: Any]()),
    ("Glow", [String: Any]()),
    ("CISepiaTone", [kCIInputIntensityKey: 0.8]),
    ("CIColorMonochrome", [kCIInputColorKey: CIColor(color: .gray), kCIInputIntensityKey: 1.0]),
    ("CIPixellate", [kCIInputScaleKey: 8.0]),
    ("CICrystallize", [kCIInputRadiusKey: 20, kCIInputCenterKey: CIVector(x: 150, y: 150)]),
    ("CIGloom", [kCIInputRadiusKey: 10, kCIInputIntensityKey: 0.75]),
    ("CIHoleDistortion", [kCIInputRadiusKey: 150, kCIInputCenterKey: CIVector(x: 150, y: 150)]),
    ("CIKaleidoscope", ["inputCount": 6, "inputCenter": CIVector(x: 150, y: 150)]),
    ("CIZoomBlur", [kCIInputAmountKey: 20, kCIInputCenterKey: CIVector(x: 150, y: 150)])
]

fileprivate struct CustomButtonStyle: ButtonStyle {
    
    let backgroundColor: Material

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

fileprivate func makeButton(action: @escaping () -> Void, imageName: String, backgroundColor: Material = .ultraThickMaterial) -> some View {
    Button(action: action) {
        Image(systemName: imageName)
            .resizable()
            .frame(width: 20, height: 20)
    }
    .buttonStyle(CustomButtonStyle(backgroundColor: backgroundColor))
}
