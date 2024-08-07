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
                        NavigationLink(destination: Video6())
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
            ToolbarItem(placement: .navigationBarLeading){
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
                Settings{
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
    
    var isPlaying: Bool {
        playbackCommand == .play
    }
    
    var body: some View {
        VStack {
            LoopPlayerView(
                {
                    Settings {
                        SourceName("swipe")
                        ErrorGroup {
                            EFontSize(27)
                        }
                    }
                },
                command: $playbackCommand
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Button(action: {
                    playbackCommand = .play
                }) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(CustomButtonStyle(backgroundColor: isPlaying ? .gray : .blue))
                .disabled(isPlaying)
                
                Button(action: {
                    playbackCommand = .pause
                }) {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(CustomButtonStyle(backgroundColor: isPlaying ? .blue : .gray))
                .disabled(!isPlaying)
                
                Button(action: {
                    playbackCommand = .seek(to: 2.0)
                    DispatchQueue.main.async{
                        playbackCommand = .play
                    }
                }) {
                    Image(systemName: "checkmark.gobackward")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(CustomButtonStyle(backgroundColor: .blue))
            }
            .padding()
        }
    }
}


struct Video8: View {
    @State private var selectedVideoURL = "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8"

    let videoOptions = [
        "Apple HLS Stream from URL": "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8",
        "Big Buck Bunny from URL": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "Elephant's Dream from URL": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
    ]

    var body: some View {
        ZStack {
            LoopPlayerView {
                Settings {
                    SourceName(selectedVideoURL)
                    Gravity(.resizeAspectFill)
                    ErrorGroup {
                        EFontSize(27)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .tag(selectedVideoURL)
        .background(Color("app_blue"))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Picker("Select Video", selection: $selectedVideoURL) {
                    ForEach(videoOptions.keys.sorted(), id: \.self) { key in
                        Text(key).tag(videoOptions[key]!)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
    }
}

struct Video3 : View{
    var body: some View{
        ZStack(alignment: .center) {
            LoopPlayerView{
                Settings{
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
                Settings{
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
