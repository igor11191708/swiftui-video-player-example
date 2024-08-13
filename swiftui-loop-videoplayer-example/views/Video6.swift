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

struct Video6: View {
    
    @State private var playbackCommand: PlaybackCommand = .play
    @State private var isPlaying: Bool = true
    @State private var isLogoAdded: Bool = false
    @State private var isMuted: Bool = true
    @State private var selectedFilterIndex: Int = 0

    @State private var settings: VideoSettings
    @State var brightness: Float = 0.0
    @State var contrast: Float = 1.0
    
    // Define the filters with their names and parameters
    let filters = [
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
    
    // Initialize settings using a custom init to ensure proper setup
    init(_ settings: () -> VideoSettings) {
        self._settings = State(initialValue: settings())
    }
    
    var body: some View {
        VStack {
            LoopPlayerView(
                settings : $settings,
                command: $playbackCommand
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: playbackCommand) { value in
                updatePlayingState(for: value)
            }
            
            // Control Buttons
            HStack {
                makeButton(action: {
                    playbackCommand = .begin
                    pause()
                }, imageName: "backward.end.fill")
                
                makeButton(action: {
                    playbackCommand = .play
                }, imageName: "play.fill", backgroundColor: isPlaying ? .gray : .blue)
                .disabled(isPlaying)
                
                makeButton(action: {
                    playbackCommand = .pause
                }, imageName: "pause.fill", backgroundColor: isPlaying ? .blue : .gray)
                .disabled(!isPlaying)
                
                makeButton(action: {
                    playbackCommand = .seek(to: 2.0)
                    pause()
                }, imageName: "gobackward.10")
                
                makeButton(action: {
                    playbackCommand = .end
                    pause()
                }, imageName: "forward.end.fill")
                
                makeButton(action: {
                    isMuted.toggle()
                    playbackCommand = isMuted ? .mute : .unmute
                }, imageName: isMuted ? "speaker.slash.fill" : "speaker.2.fill")
                Spacer()
            }
            .padding()
            HStack {
                makeButton(action: {
                    playbackCommand = .addVector(VectorLogoLayer())
                    isLogoAdded.toggle()
                }, imageName: "diamond.fill", backgroundColor: isLogoAdded ? .gray : .blue )
                .disabled(isLogoAdded)
                makeButton(action: {
                    playbackCommand = .removeAllVectors
                    isLogoAdded.toggle()
                }, imageName: "diamond", backgroundColor: isLogoAdded ? .blue : .gray )
                .disabled(!isLogoAdded)
                Spacer()
                // Segmented Control for Filters
                Picker("Select Filter", selection: $selectedFilterIndex) {
                    ForEach(0..<filters.count, id: \.self) { index in
                        Text(self.filters[index].0).tag(index)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: selectedFilterIndex) { newIndex in
                    // Apply the selected filter
                    let filter = filters[newIndex]
                    print(filter.0)
                    if filter.0 == "None" {
                        playbackCommand = .removeAllFilters
                        return
                    }else if let filter = CIFilter(name: filter.0, parameters: filter.1) {
                        playbackCommand = .filter(filter, clear: true)
                    }else{
                        let filter = ArtFilter()
                        playbackCommand = .filter(filter, clear: true)
                    }
                }
            }                .padding(.horizontal)

            
            /// Brightness and Contrast: These settings function also filters but are managed separately from the filter stack. Adjustments to brightness and contrast are applied additionally and independently of the image filters.
            /// Independent Management: Developers should manage brightness and contrast adjustments through their dedicated methods or properties to ensure these settings are accurately reflected in the video output.
            VStack {
                HStack {
                    Text("Brightness")
                    Slider(value: $brightness, in: 0.0...1.0, step: 0.1) { _ in
                        playbackCommand = .brightness(brightness)
                    }
                    .padding()
                }
                
                HStack {
                    Text("Contrast")
                    Slider(value: $contrast, in: 1.0...2.0, step: 0.1) { _ in
                        playbackCommand = .contrast(contrast)
                    }
                    .padding()
                }
            }.padding()
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
    
    private func makeButton(action: @escaping () -> Void, imageName: String, backgroundColor: Color = .blue) -> some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 20, height: 20)
        }
        .buttonStyle(CustomButtonStyle(backgroundColor: backgroundColor))
    }
    
    func pause() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            playbackCommand = .pause
        }
    }
}

fileprivate struct CustomButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}


