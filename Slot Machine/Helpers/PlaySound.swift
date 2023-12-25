//
//  PlaySound.swift
//  Slot Machine
//
//  Created by Drashti on 22/12/23.
//

import AVFoundation

var audioPlayer : AVAudioPlayer?

func playSound(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: path))
            audioPlayer?.play()
        }
        catch {
            print("Could not find and play the sound file!")
        }
        
    }
}
