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
        }
    }
    
    @ViewBuilder
    private func labelTpl(_ name : String, color : Color = .blue) -> some View{
        Image(systemName: name)
            .font(.system(size: 50))
            .padding(8)
            .foregroundColor(color)
    }
}

struct Video1 : View{
    var body: some View{
        VStack {
           PlayerView(resourceName: "swipe")
                .frame(width: 300, height: 239)
                .offset(x: 102, y: -25)
        }
        .ignoresSafeArea()
    }
}

struct Video2 : View{
    var body: some View{
        ZStack {
           PlayerView(resourceName: "swipe")
        }
    }
}

struct Video3 : View{
    var body: some View{
        ZStack(alignment: .center) {
           PlayerView(resourceName: "swipe_")
        }
    }
}


struct Video : View{
    var body: some View{
        ZStack(alignment: .center) {
            PlayerView(resourceName: "swipe", videoGravity: .resizeAspectFill)
        }.ignoresSafeArea()
    }
}
