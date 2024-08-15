//
//  Video1.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor  on 15.08.24.
//

import SwiftUI
import Combine
import swiftui_loop_videoplayer

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
        .modifier(ConditionalIgnoreSafeArea())
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
