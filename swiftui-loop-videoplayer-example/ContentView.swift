//
//  ContentView.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor on 03.07.2023.
//

import SwiftUI
import swiftui_loop_videoplayer

struct ContentView: View {
    var body: some View {
            NavigationStack{
                ZStack{
                    VStack{
                        Spacer()
                        NavigationLink(destination: Video())
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
                        NavigationLink(destination: Video3())
                        {
                            labelTpl("e.circle", color: .red)
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color("app_blue"))
                .ignoresSafeArea()
            }.preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    private func labelTpl(_ name : String, color : Color = .blue) -> some View{
        Image(systemName: name)
            .font(.system(size: 102))
            .padding(8)
            .foregroundColor(color)
    }
}

struct Video1 : View{
    var body: some View{
        VStack {
            Spacer()
            LoopPlayerView(fileName : "swipe")
                .frame(width: 300, height: 239)
                .offset(x: 102, y: -25)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
        .background(Color("app_blue"))
    }
}

struct Video2 : View{
    var body: some View{
        ZStack {
            LoopPlayerView{
                Settings{
                    FileName("swipe")
                    ErrorGroup{
                        EText("File not found")
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
                Settings{
                    FileName("swipe_")
                    EText("Custom error text")
                    EFontSize(33)
                }
            }
        } .background(Color("app_blue"))
    }
}


struct Video : View{
    var body: some View{
        ZStack(alignment: .center) {
            LoopPlayerView{
                Settings{
                    FileName("swipe")
                    Ext("mp4")
                    Gravity(.resizeAspectFill)
                }
            }
        }.ignoresSafeArea()
    }
}
