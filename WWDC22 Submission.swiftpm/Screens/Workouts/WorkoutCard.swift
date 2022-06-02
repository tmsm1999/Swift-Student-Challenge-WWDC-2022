//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct WorkoutCard: View {
    
    @Binding var workout: JumpPlan
    @Binding var sessions: [JumpSession]
    
    @State private var showWorkoutStudioEditor = false
    @State private var showWorkoutProgressView = false
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let cornerRadius: CGFloat = 15
    
    let removeWorkout: (UUID) -> Void
    let removeActivity: (UUID) -> Void
    
    var body: some View {
            
        GeometryReader { geometry in
            
            VStack {
                
                HStack {
                    Text(workout.name)
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                    
                    if workout.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.yellow)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .onTapGesture {
                            showWorkoutStudioEditor = true
                        }
                }
                .offset(x: 0, y: geometry.size.height * 0.1)
                
                Spacer()
                
                HStack {
                    
                    HStack {
                        Image(systemName: "clock")
                            .font(.system(size: 20, weight: .semibold))
                        
                        workout.estimatedDuration != 1 ?
                        Text(String("\(workout.estimatedDuration) minutes"))
                            .font(.system(size: 18))
                            .fontWeight(.semibold) :
                        Text(String("\(workout.estimatedDuration) minute"))
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .offset(x: 0, y: -geometry.size.height * 0.065)
                    
                    Spacer()
                    
                    Button(action: {
                        showWorkoutProgressView.toggle()
                    }, label: {
                        HStack {
                            Text("Start")
                                .foregroundColor(workout.workoutTheme)
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                        }
                        .frame(width: 90, height: 27, alignment: .center)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                    })
                    .foregroundColor(.white)
                    .offset(x: 0, y: -geometry.size.height * 0.065)
                }
                .padding(.bottom, geometry.size.height * 0.06)
            }
            .padding([.leading, .trailing], 20)
            .contentShape(Rectangle())
//            .onTapGesture {
//                showWorkoutProgressView = true
//            }
        }
        .frame(height: 100)
        .background(workout.workoutTheme)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .transition(.move(edge: .leading))
        .fullScreenCover(isPresented: $showWorkoutStudioEditor) {
            WorkoutStudio(
                createOrEdit: .edit(
                    workout: $workout,
                    removeWorkout: removeWorkout)
            )
        }
        .fullScreenCover(isPresented: $showWorkoutProgressView) {
            WorkoutProgress(
                sessions: $sessions,
                workout: workout,
                completeJumpSequence: buildCompleteJumpSequence(),
                removeActivity: removeActivity
            )
        }
    }
    
    private func buildCompleteJumpSequence() -> [JumpTimePair] {
        var completeJumpSequence = [JumpTimePair]()
        
        for rep in 0 ..< workout.numberOfRepetitions {
            for jump in workout.jumpSequence {
                var newJump = jump
                newJump.id = UUID()
                newJump.repetition = rep + 1
                completeJumpSequence.append(newJump)
            }
        }
        
        return completeJumpSequence
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(
            workout: .constant(UserData.workoutsData[0]),
            sessions: .constant(UserData.jumpSessionsData),
            removeWorkout: { _ in },
            removeActivity: { _ in}
        )
    }
}
