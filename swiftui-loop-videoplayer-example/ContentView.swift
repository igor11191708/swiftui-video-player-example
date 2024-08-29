//
//  ContentView.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 03.07.2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
            NavigationStack{
                ZStack{
                    ResponsiveStack(spacing: 5) {
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
    }
}

// MARK: - Fileprivate

@ViewBuilder
fileprivate func labelTpl(_ name : String, color : Color = .blue) -> some View{
    Image(systemName: name)
        .font(.system(size: 68))
        .padding(8)
        .foregroundColor(color)
        .frame(width: 102)
}
