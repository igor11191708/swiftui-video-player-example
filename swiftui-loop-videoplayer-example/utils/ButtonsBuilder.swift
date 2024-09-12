//
//  ButtonsBuilder.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 12.09.24.
//

import SwiftUI

fileprivate struct CustomButtonStyle: ButtonStyle {
    
    let backgroundColor: Material

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

func makeButton(action: @escaping () -> Void, imageName: String, backgroundColor: Material = .ultraThickMaterial) -> some View {
    Button(action: action) {
        Image(systemName: imageName)
            .resizable()
            .frame(width: 20, height: 20)
    }
    .buttonStyle(CustomButtonStyle(backgroundColor: backgroundColor))
}
