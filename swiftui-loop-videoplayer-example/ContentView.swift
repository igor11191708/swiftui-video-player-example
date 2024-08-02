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
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Picker("Select an option", selection: $fileName) {
                            ForEach(options, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: { hintOn = true }, label: {
                            Image(systemName: "questionmark.circle.fill")
                        })
                    }
                }
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
            .font(.system(size: 102))
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
                    FileName("swipe")
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
                Settings{
                    FileName("swipe_")
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
                    FileName(fileName)
                    Ext("mp4")
                    Gravity(.resizeAspectFill)
                }
            }
        }.ignoresSafeArea()
    }
}
