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
    
    @State var fileName : String = "swipe"
    
    let options: [String] = ["logo", "swipe"]
    
    var body: some View {
            NavigationStack{
                ZStack{
                    ResponsiveStack(spacing: 5) {
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
                                SourceName("apple_logo")
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
            Spacer()
        }
        .padding(.top, 50)
    }
    
    @ViewBuilder
    private func labelTpl(_ name : String, color : Color = .blue) -> some View{
        Image(systemName: name)
            .font(.system(size: 68))
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
            let adjustedSize = adjustChildSize(toFit: proxy.size, initialChildSize: .init(width: videoWidth, height: videoHeight))
            
            VStack(alignment : .trailing){
                Spacer()
                    LoopPlayerView(fileName : fileName)
                    .frame(width: adjustedSize.width, height: adjustedSize.height)
                Spacer()
            }.offset(x : proxy.size.width - adjustedSize.width)
        }
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

struct ResponsiveStack<Content: View>: View {
    
    let spacing : CGFloat
    
    @ViewBuilder let content: Content
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                // Landscape mode
                HStack(alignment: .center, spacing: spacing) {
                    Spacer()
                    content
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                // Portrait mode
                VStack(alignment: .center, spacing: spacing) {
                    Spacer()
                    content
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

fileprivate func adjustChildSize(toFit parentSize: CGSize, initialChildSize childSize: CGSize) -> CGSize {
    let maxWidth = parentSize.width * 0.75
    let maxHeight = parentSize.height * 0.75

    if childSize.width > maxWidth || childSize.height > maxHeight {
        let widthRatio = maxWidth / childSize.width
        let heightRatio = maxHeight / childSize.height
        let adjustmentRatio = min(widthRatio, heightRatio)

        return CGSize(width: childSize.width * adjustmentRatio, height: childSize.height * adjustmentRatio)
    } else {
        return childSize
    }
}
