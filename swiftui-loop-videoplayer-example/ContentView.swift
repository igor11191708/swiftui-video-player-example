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
