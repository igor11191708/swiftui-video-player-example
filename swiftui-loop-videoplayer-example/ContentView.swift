//
//  ContentView.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor on 03.07.2023.
//

import SwiftUI
import swiftui_loop_videoplayer

struct ContentView: View {
    
    @State var hintOn : Bool = false
    
    @State var fileName : String = "logo"
    
    let options: [String] = ["logo", "swipe"]
    
    var body: some View {
            NavigationStack{
                ZStack{
                    VStack{
                        Spacer()
                        NavigationLink(destination: Video(fileName: $fileName))
                        {
                            labelTpl("display", color: .green)
                        }
                        NavigationLink(destination: Video1(fileName: $fileName))
                        {
                            labelTpl("video")
                        }
                        NavigationLink(destination: Video2())
                        {
                            labelTpl("airplayvideo.circle")
                        }
                        
                        NavigationLink(destination: Video6{
                            VideoSettings {
                                SourceName("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
                                ErrorGroup {
                                    EFontSize(27)
                                }
                            }
                        })
                        {
                            labelTpl("appletvremote.gen2")
                        }
                        NavigationLink(destination: Video8())
                        {
                            labelTpl("cloud")
                        }
                        NavigationLink(destination: Video3())
                        {
                            labelTpl("e.circle", color: .red)
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.quaternary)
                .ignoresSafeArea()
            }.preferredColorScheme(.dark)
            .sheet(isPresented: $hintOn){
                    Video2()
                    .overlay(hintTitleTpl, alignment: .topLeading)
            }
           
            
    }
    
    @ViewBuilder
    private var hintTitleTpl : some View{
        HStack{
            Spacer()
            VStack(){
                Image(systemName: "questionmark.video")
                Text("Video hint")
                    .font(.system(size: 50))
                    .padding()
            }.foregroundColor(.orange)
                .font(.system(size: 70))
                .fontWeight(.thin)
            Spacer()
        }
        .padding(.top, 50)
    }
    
    @ViewBuilder
    private func labelTpl(_ name : String, color : Color = .blue) -> some View{
        Image(systemName: name)
            .font(.system(size: 78))
            .padding(8)
            .foregroundColor(color)
            .frame(width: 102)
    }
}

struct Video1 : View{
    
    @Binding var fileName : String
    
    let options: [String] = ["logo", "swipe"]
    
    var videoWidth : CGFloat{
        fileName == "logo" ? 794 : 600
    }
    var videoHeight : CGFloat{
        fileName == "logo" ? 1088 : 476
    }
    
    var body: some View{
        GeometryReader{ proxy in
            let width = min(proxy.size.width / 1.5, videoWidth)
            let ratio = width / videoWidth
            let length = videoWidth * ratio
            VStack{
                Spacer()
                LoopPlayerView(fileName : fileName)
                    .frame(width: videoWidth * ratio, height: videoHeight * ratio)
                Spacer()
            }.offset(x : proxy.size.width - length)
        }
        .ignoresSafeArea()
        .background(Color("app_blue"))
        .toolbar{
            ToolbarItem(placement: .navigation){
                Picker("Select an option", selection: $fileName) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct Video2 : View{
    var body: some View{
        ZStack {
            LoopPlayerView{
                VideoSettings{
                    SourceName("swipe")
                    ErrorGroup{
                        EFontSize(27)
                    }
                }
            }
        }.background(Color("app_blue"))
    }
}


struct Video6: View {
    
    @State private var playbackCommand: PlaybackCommand = .play
    @State private var isPlaying: Bool = true
    @State private var isMuted: Bool = true
    @State private var settings: VideoSettings

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
            }
            .padding()
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

struct Video8: View {
    
    static let initVideo = "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8"
    
    @State private var selectedVideoURL = Video8.initVideo

    let videoOptions = [
        "Apple HLS Stream from URL": "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8",
        "Big Buck Bunny from URL": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "Elephant's Dream from URL": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
    ]
    
    @State private var settings: VideoSettings = .init{
        SourceName(Video8.initVideo)
        Gravity(.resizeAspectFill)
    }

    var body: some View {
        ZStack {
            LoopPlayerView {
                settings
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
            }
        }
        .onChange(of: selectedVideoURL){ value in
            settings = VideoSettings {
                SourceName(selectedVideoURL)
                Gravity(.resizeAspectFill)
            }
        }
    }
}

struct Video3 : View{
    var body: some View{
        ZStack(alignment: .center) {
            LoopPlayerView{
                VideoSettings{
                    SourceName("swipe_")
                    EColor(.orange)
                    EFontSize(33)
                }
            }
        } .background(Color("app_blue"))
    }
}


struct Video : View{
    
    @Binding var fileName : String
    
    var body: some View{
        ZStack(alignment: .center) {
            LoopPlayerView{
                VideoSettings{
                    SourceName(fileName)
                    Ext("mp4")
                    Gravity(.resizeAspectFill)
                }
            }
        }.ignoresSafeArea()
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
