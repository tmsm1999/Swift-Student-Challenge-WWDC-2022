//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation
import AVFoundation

enum WorkoutState: String {
    case paused = "Pausing Workout ..."
    case resume = "Resuming Workout ..."
    case complete = "Workout completed ..."
}

func announceWorkoutState(state: WorkoutState) {
    
    let utteranceString = state.rawValue
    
    let utterance = AVSpeechUtterance(string: utteranceString)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    utterance.rate = 0.52
    
    let synthesizer = AVSpeechSynthesizer()
    synthesizer.speak(utterance)
}
