//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI
import AVFoundation

struct JumpSequenceView: View {
    
    @State var jumpSequence: [JumpTimePair]
    @State var currentRepetition = 1
    var numberOfRepetitions: Int
    
    @Binding var timer: Timer?
    
    @Binding var activeJumpIndex: Int
    @Binding var activeJumpElapsedTime: Int
    
    @Binding var workoutIsPaused: Bool
    @Binding var workoutHasEnded: Bool
    
    let startTimer: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Jump Sequence")
                    .font(.title3)
                    .bold()
                    //.opacity(0.70)
                    .padding(.leading)

                Spacer()
            }
            
            HStack {
                Text("Repetition \(currentRepetition) of \(numberOfRepetitions)")
                    .bold()
                Spacer()
            }
            .font(.headline)
            .opacity(0.80)
            .padding([.leading, .trailing])
            
            ScrollViewReader { scrollView in
                ScrollView(.vertical) {
                    ForEach(0 ..< jumpSequence.count, id: \.self) { index in
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(jumpSequence[index].jumpType != .rest ? "Jump Type: \(jumpSequence[index].jumpType.rawValue)" : "Rest")
                                    .bold()
                                Text("\(jumpSequence[index].duration) seconds")
                                    .bold()
                                    .opacity(0.50)

                            }
                            .font(.body)
                            .opacity(activeJumpIndex < jumpSequence.count && jumpSequence[index].id == jumpSequence[activeJumpIndex].id ? 1 : 0.4)

                            Spacer()
                            
                            if activeJumpIndex < jumpSequence.count && jumpSequence[index].id == jumpSequence[activeJumpIndex].id {
                                Button {
                                    withAnimation(Animation.spring()) {
                                        workoutIsPaused = true
                                        announceWorkoutState(state: .paused)
                                    }
                                } label: {
                                    CircularProgressView(
                                        jumpDuration: CGFloat(jumpSequence[index].duration),
                                        progress: CGFloat(activeJumpElapsedTime)
                                    )
                                    .offset(x: -15, y: 0)
                                    .frame(width: 35, height: 35)
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                        .contentShape(Rectangle())
                        .id(jumpSequence[index].id)
                        .onTapGesture {
                            workoutHasEnded = false
                            
                            var i = 0
                            for j in jumpSequence {

                                if j.id == jumpSequence[index].id {
                                    timer?.invalidate()
                                    
                                    withAnimation {
                                        if i == activeJumpIndex { startTimer() }
                                        
                                        activeJumpIndex = i
                                        activeJumpElapsedTime = 0
                                    }
                                    
                                    break
                                }
                                i += 1
                            }
                        }
                        
                        Divider()
                            .padding([.leading, .trailing])
                    }
                    .onChange(of: activeJumpIndex) { newValue in

                        if newValue < jumpSequence.count {
                            startTimer()
                            withAnimation {
                                scrollView.scrollTo(jumpSequence[newValue].id, anchor: .top)
                            }
                            
                            announceJump(jump: jumpSequence[newValue])
                            
                            if let repetition = jumpSequence[activeJumpIndex].repetition {
                                currentRepetition = repetition
                            }
                        }
                    }

                    Spacer(minLength: screenHeight * 0.50)
                }
                .padding(.top, 10)
                
            }
        }
        .offset(x: 0, y: 20)
        .onAppear {
            announceJump(jump: jumpSequence[0])
        }
    }
    
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    
    private func announceJump(jump: JumpTimePair) {
        
        var utteranceString = ""
        
        if jump.jumpType == .rest {
            utteranceString = "\(jump.jumpType.rawValue) ... \(jump.duration) seconds ..."
        }
        else {
            utteranceString = "\(jump.jumpType.rawValue) jump ... \(jump.duration) seconds ..."
        }
        
        let utterance = AVSpeechUtterance(string: utteranceString)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.52
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct JumpSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        JumpSequenceView(
            jumpSequence: [
                JumpTimePair(jumpType: .basic, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID())
            ],
            numberOfRepetitions: 3,
            timer: .constant(Timer()),
            activeJumpIndex: .constant(0),
            activeJumpElapsedTime: .constant(5),
            workoutIsPaused: .constant(false),
            workoutHasEnded: .constant(false),
            startTimer: { }
        )
    }
}
