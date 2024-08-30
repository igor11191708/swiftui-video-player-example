//
//  ContentView.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 03.07.2023.
//

import SwiftUI

struct ContentView: View {

    
    @State public var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ResponsiveStack(spacing: 5) {
                Spacer()
                ForEach(VideoPlayerModel.data, id: \.self) { view in
                    NavigationLink(value: view.name) {
                        labelTpl(view.icon, color: view.color)
                    }
                    .accessibilityIdentifier(view.name)
                }
                Spacer()
            }
            .background(.quaternary)
            .ignoresSafeArea()
            .navigationDestination(for: String.self) { item in
                switch item {
                case "Video":
                    Video()
                case "Video1":
                    Video1()
                case "Video2":
                    Video2()
                case "Video6":
                    Video6()
                case "Video8":
                    Video8()
                case "Video3":
                    Video3()
                default:
                    EmptyView()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    private func labelTpl(_ name: String, color: Color = .blue) -> some View {
        Image(systemName: name)
            .font(.system(size: 68))
            .padding(8)
            .foregroundColor(color)
            .frame(width: 102)
    }
}
