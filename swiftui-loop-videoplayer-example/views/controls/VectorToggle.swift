//
//  VectorToggle.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 12.09.24.
//

import SwiftUI
import swiftui_loop_videoplayer

struct VectorToggle: View{
    
    @Binding public var playbackCommand: PlaybackCommand
    
    @State private var toggleVector: Bool = false
    
    var body: some View {
        vectorControlsTpl
            .onChange(of: toggleVector, perform: onVectorChange)
    }
    
    @ViewBuilder
    private var vectorControlsTpl : some View{
        HStack {
            Toggle("Vector layer", isOn: $toggleVector)
                .tint(.blue)
        }
    }
    
    private func onVectorChange(value : Bool){
        playbackCommand = value ? .addVector(VectorLogoLayer()) : .removeAllVectors
    }
    
}
