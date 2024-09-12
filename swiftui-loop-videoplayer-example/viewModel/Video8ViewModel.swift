//
//  Video8ViewModel.swift
//  swiftui-loop-videoplayer-example
//
//  Created by Igor Shelopaev on 12.09.24.
//

import SwiftUI
import AVFoundation

final class Video8ViewModel : ObservableObject{
    
    @Published private(set) var duration: Double? = nil
    
    public func getDuration(from url: String) {
        
        duration = nil
        
        guard let videoURL = URL(string: url) else { return }
        let asset = AVAsset(url: videoURL)
        
        Task { @MainActor in
            if let duration = try? await asset.load(.duration){
                self.duration = duration.seconds
            }
        }
    }
}
