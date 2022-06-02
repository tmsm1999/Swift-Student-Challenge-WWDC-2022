//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI
import AVFoundation

struct CountDown: View {
    
    let seconds = ["3", "2", "1", ""]
    
    @State var index: CGFloat = 0
    @State var animate = false
    
    @Binding var countDownIsConcluded: Bool
    var workoutTheme: Color
    
    var body: some View {
        VStack {
            Text("\(seconds[Int(index)])")
                .font(.system(size: screenHeight * 0.25, weight: .bold, design: .default))
                .italic()
                .scaleEffect(animate ? 1 : 0)
                .animation(Animation.linear(duration: 0.7).repeatCount(8), value: animate)
                .frame(width: screenWidth, height: screenHeight * 0.30, alignment: .center)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startTimer()
                animate = true
            }
        }
        .frame(width: screenWidth, height: screenHeight, alignment: .center)
        .background(workoutTheme.opacity(0.18))
        .onAppear {
            announceWorkoutStart()
        }
    }
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.4, repeats: true, block: { timer in
                index += 1
            
            if index == 3 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        countDownIsConcluded = true
                    }
                }
            }
        })
    }
    
    private func announceWorkoutStart() {
        
        let utteranceString = "Starting Workout... Get ready!"
        
        let utterance = AVSpeechUtterance(string: utteranceString)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.52
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct CountDown_Previews: PreviewProvider {
    static var previews: some View {
        CountDown(countDownIsConcluded: .constant(false), workoutTheme: Color.accentColor)
    }
}
