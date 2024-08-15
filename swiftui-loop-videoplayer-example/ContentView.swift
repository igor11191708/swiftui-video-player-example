//
//  ContentView.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor on 03.07.2023.
//

import SwiftUI
import Combine
import swiftui_loop_videoplayer

struct ContentView: View {
    
    @State var hintOn : Bool = false

    
    var body: some View {
            NavigationStack{
                ZStack{
                    ResponsiveStack(spacing: 5) {
                        Spacer()
                        NavigationLink(destination: Video(fileName: .constant("swipe")))
                        {
                            labelTpl("display", color: .green)
                        }
                        NavigationLink(destination: Video1())
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
    
    @State var fileName : String = "swipe"
    @State private var playbackCommand: PlaybackCommand = .play
    
    let options: [String] = ["apple_logo", "swipe"]
    
    var videoWidth : CGFloat{
        fileName == "apple_logo" ? 652 : 600
    }
    var videoHeight : CGFloat{
        fileName == "apple_logo" ? 720 : 476
    }
    
    @State private var settings: VideoSettings = .init {
        SourceName("swipe")
    }
    
    var body: some View{
        GeometryReader{ proxy in
            let adjustedSize = adjustChildSize(toFit: proxy.size, initialChildSize: .init(width: videoWidth, height: videoHeight))
            
            VStack(alignment : .trailing){
                Spacer()
                    LoopPlayerView(settings: $settings, command: $playbackCommand)
                    .frame(width: adjustedSize.width, height: adjustedSize.height)
                Spacer()
            }.offset(x : proxy.size.width - adjustedSize.width)
        }
        .background(fileName == "swipe" ? Color("app_blue") : Color.black)
        .onChange(of: fileName){ name in
            self.settings = .init {
                SourceName(fileName)
            }
        }
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

fileprivate struct ConditionalIgnoreSafeArea: ViewModifier {

    class OrientationManager: ObservableObject {
        @Published var orientation: UIDeviceOrientation = .unknown
        private var cancellables: Set<AnyCancellable> = []

        init() {
            NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
                .map { _ in UIDevice.current.orientation }
                .receive(on: RunLoop.main)
                .assign(to: \.orientation, on: self)
                .store(in: &cancellables)
        }
    }
    
    @StateObject var model = OrientationManager()
    
    
    func body(content: Content) -> some View {
        if model.orientation == .landscapeLeft {
            content
                .ignoresSafeArea()
        } else {
            content
        }
    }
}
