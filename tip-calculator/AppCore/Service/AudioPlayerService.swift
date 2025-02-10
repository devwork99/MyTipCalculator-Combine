//
//  AudioPlayerService.swift
//  tip-calculator
//
//  Created by Yasir on 04/11/2024.
//

import Foundation
import AVFoundation


protocol AudioPlayerService {
    func playSound()
}


final class DefaultAudioPlayer: AudioPlayerService {
    
    private var player : AVAudioPlayer?
    
    func playSound() {
        
        let path = Bundle.main.path(forResource:"click", ofType:"m4a")!
        let url = URL(fileURLWithPath: path)
        
        do {
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        }catch (let error) {
            print("DefaultAudioPlayer -> \(error.localizedDescription)")
        }
        
        
    }
    
    
}
