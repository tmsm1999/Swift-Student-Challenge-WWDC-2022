//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI
import AVFoundation

struct PausedWorkout: View {
    
    var currentTime: String
    
    @Binding var jump: JumpTimePair
    @Binding var workoutIsPaused: Bool
    
    @State private var showEndWorkoutAlert = false
    
    let startTimer: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Spacer()
                
            VStack {
                Text(currentTime)
                    .font(.largeTitle)
                    .bold()
                Text(jump.jumpType == .rest ? "" : "Jump Type: \(jump.jumpType.rawValue)")
                    .font(.subheadline)
                    .opacity(0.6)
            }
            .padding()
            
            Spacer()
            
            GeometryReader { geometry in
                VStack {
                    
                    Spacer()
                    
                    VStack() {
                        if jump.jumpType == .rest {
                            RestText()
                        }
                        else {
                            JumpText()
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        
                        Spacer()
                        
                        Button {
                            withAnimation(Animation.spring()) {
                                workoutIsPaused = false
                                announceWorkoutState(state: .resume)
                                startTimer()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(.black)
                                    .opacity(0.85)
                                
                                Image(systemName: "play.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 90, height: 90)
                        }
                        
                        Button(action: {
                            
                        }, label: {
                            HStack(spacing: -9) {
                                Image(systemName: "music.note")
                                    .foregroundColor(.black)
                                    .font(.system(size: 30))
                                Image(systemName: "music.note")
                                    .foregroundColor(.black)
                                    .font(.system(size: 30))
                            }
                            
                        })
                            .padding(30)
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.6)
                }
            }
            .frame(width: screenWidth, height: screenHeight * 0.60)
            
            Spacer()
                
            Button {
                showEndWorkoutAlert = true
            } label: {
                Text("End Workout")
                    .bold()
                    .frame(width: screenWidth)
            }
            .frame(maxWidth: screenWidth * 0.85)
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
            
            Spacer()
        }
        .background(Color.clear)
        .alert(isPresented: $showEndWorkoutAlert) {
            Alert(
                title: Text("Are you sure you want to end the current workout?"),
                message: Text("This action is irreversable and only the data up to this point in time will be saved."),
                primaryButton: .destructive(Text("Yes"), action: {
                    announceWorkoutState(state: .complete)
                    dismiss()
                }),
                secondaryButton: .cancel()
            )
        }
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
}

struct PausedWorkout_Previews: PreviewProvider {
    static var previews: some View {
        PausedWorkout(
            currentTime: "00:25", jump: .constant(JumpTimePair(jumpType: .rest, duration: 10, id: UUID())),
            workoutIsPaused: .constant(true),
            startTimer: { })
    }
}
