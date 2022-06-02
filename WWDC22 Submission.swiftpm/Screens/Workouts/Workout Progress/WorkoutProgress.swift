//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI
import CoreLocation

struct WorkoutProgress: View {
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    @Binding var sessions: [JumpSession]
    var workout: JumpPlan
    
    @State var completeJumpSequence: [JumpTimePair]
    
    @State var activeJumpIndex = 0
    @State var activeJumpElapsedTime = 0
    @State var totalElapsedTime = 0
    
    @State var workoutIsPaused = false
    @State var workoutHasEnded = false
    
    @State var countDownIsConcluded = false
    
    @State var timer: Timer?
    @State var startDate = Date()
    
    @Environment(\.dismiss) private var dismiss
    
    let removeActivity: (UUID) -> Void
    
    var body: some View {
        
        ZStack {
            
            if workoutHasEnded {
                ActivityDetails(
                    jumpSession: sessions[0],
                    removeActivity: removeActivity,
                    enableDoneButton: true
                )
                    .transition(AnyTransition.move(edge: .leading))
                    .zIndex(2)
            }
            
            if workoutIsPaused {
                PausedWorkout(
                    currentTime: "\(String(format: "%02d", totalElapsedTime / 60)):\(String(format: "%02d", totalElapsedTime % 60))", jump: $completeJumpSequence[activeJumpIndex], workoutIsPaused: $workoutIsPaused,
                    startTimer: startTimer
                )
                    .transition(AnyTransition.move(edge: .leading))
                    .zIndex(2)
            }
            
            if countDownIsConcluded {
                VStack {
                    
                    HorizontalWorkoutDataBar(totalElapsedTime: $totalElapsedTime)
                        .offset(x: 0, y: -8)
                    
                    GeometryReader { geometry in
                        VStack {
                            
                            Spacer()
                            VStack {
                                if completeJumpSequence[activeJumpIndex].jumpType == .rest {
                                    RestText()
                                        .transition(AnyTransition.opacity)
                                }
                                else {
                                    JumpText()
                                        .transition(AnyTransition.opacity)
                                }
                            }
                            
                            Spacer()
                            
                            JumpSequenceView(
                                jumpSequence: completeJumpSequence,
                                numberOfRepetitions: workout.numberOfRepetitions,
                                timer: $timer,
                                activeJumpIndex: $activeJumpIndex,
                                activeJumpElapsedTime: $activeJumpElapsedTime,
                                workoutIsPaused: $workoutIsPaused,
                                workoutHasEnded: $workoutHasEnded,
                                startTimer: startTimer
                            )
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.72, alignment: .center)
                        }
                    }
                    .frame(height: screenHeight * 0.75)
                }
                .frame(width: screenWidth, height: screenHeight, alignment: .center)
                .zIndex(1)
                .background(workout.workoutTheme.opacity(0.18))
                .blur(radius: workoutIsPaused ? 120 : .zero, opaque: false)
                .animation(Animation.linear(duration: 0.35), value: workoutIsPaused)
                .animation(Animation.linear(duration: 0.35), value: workoutHasEnded)
                .transition(AnyTransition.opacity.animation(.linear(duration: 1)))
                .onAppear {
                    startTimer()
                }
            }
            
            CountDown(countDownIsConcluded: $countDownIsConcluded, workoutTheme: workout.workoutTheme)
                .opacity(countDownIsConcluded ? 0 : 1)
                .animation(Animation.linear(duration: 1), value: countDownIsConcluded)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if activeJumpElapsedTime == completeJumpSequence[activeJumpIndex].duration {
                
                if activeJumpIndex < completeJumpSequence.count - 1 {
                    withAnimation {
                        activeJumpIndex += 1
                        activeJumpElapsedTime = 0
                    }
                }
                else {
                    timer.invalidate()
                    
                    withAnimation(Animation.spring()) {
                        workoutHasEnded = true
                    }
                    
                    saveWorkout()
                    //dismiss()
                }
                
                timer.invalidate()
            }
            else if workoutIsPaused {
                timer.invalidate()
                totalElapsedTime -= 1
                activeJumpElapsedTime -= 1
            }
            
            activeJumpElapsedTime += 1
            totalElapsedTime += 1
        }
    }
    
    private func saveWorkout() {
        
        let startEndTime = formatStartEndTime()
        let workoutDateString = formatDayMonthYear()
        let workoutDurationString = formatWorkoutDuration(elapsedTimeJumping: totalElapsedTime)
        
        print(workoutDurationString)
        
        var newJumpSession = JumpSession(workout: workout, startDate: workoutDateString, startTime: startEndTime.0, endTime: startEndTime.1, duration: workoutDurationString)
        
        //newJumpSession.location = UserLocation().getUserLocation()
        newJumpSession.averageHeartRate = Int.random(in: 155 ... 180)
        newJumpSession.highestHeartRate = Int.random(in: 181 ... 199)
        newJumpSession.caloriesBurned = Int.random(in: 100 ... 300)
        
        sessions.insert(newJumpSession, at: 0)
    }
    
    private func formatStartEndTime() -> (String, String) {
        
        let workoutStartDate = startDate
        let workoutEndDate = Date()
        
        let startDateComponents = Calendar.current.dateComponents([.hour, .minute], from: workoutStartDate)
        let endDateComponents = Calendar.current.dateComponents([.hour, .minute], from: workoutEndDate)
        
        if startDateComponents.hour == nil || startDateComponents.minute == nil || endDateComponents.hour == nil || startDateComponents.minute == nil {
            return ("", "")
        }
        
        var startHour = ""
        var startMinutes = ""
        
        if startDateComponents.hour! >= 10 {
            startHour = String(startDateComponents.hour!)
        }
        else {
            startHour = String("0\(startDateComponents.hour!)")
        }
        
        if startDateComponents.minute! >= 10 {
            startMinutes = String(startDateComponents.minute!)
        }
        else {
            startMinutes = String("0\(startDateComponents.minute!)")
        }
        
        let startDateString = String("\(startHour):\(startMinutes)")
        
        
        var endHour = ""
        var endMinutes = ""
        
        if endDateComponents.hour! >= 10 {
            endHour = String(endDateComponents.hour!)
        }
        else {
            endHour = String("0\(endDateComponents.hour!)")
        }
        
        if endDateComponents.minute! >= 10 {
            endMinutes = String(endDateComponents.minute!)
        }
        else {
            endMinutes = String("0\(endDateComponents.minute!)")
        }
        
        let endDateString = String("\(endHour):\(endMinutes)")
        
        return (startDateString, endDateString)
    }
    
    private func formatDayMonthYear() -> String {
        
        let workoutStartDate = startDate
        let startDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: workoutStartDate)
        
        var day = ""
        var month = ""
        var year = ""
        
        if startDateComponents.day! >= 10 {
            day = String(startDateComponents.day!)
        }
        else {
            day = String("0\(startDateComponents.day!)")
        }
        
        if startDateComponents.month! >= 10 {
            month = String(startDateComponents.month!)
        }
        else {
            month = String("0\(startDateComponents.month!)")
        }
        
        if startDateComponents.year! >= 10 {
            year = String(startDateComponents.year!)
        }
        else {
            year = String("0\(startDateComponents.year!)")
        }
        
        let dayMonthYearString = String("\(day)/\(month)/\(year)")
        
        return dayMonthYearString
    }
    
    private func formatWorkoutDuration(elapsedTimeJumping: Int) -> String {
        
        let minutes = elapsedTimeJumping / 60
        let seconds = elapsedTimeJumping - (minutes * 60)
        
        var hoursString = ""
        if minutes >= 10 { hoursString = String(minutes) } else { hoursString = String("0\(minutes)")}
        
        var minutesString = ""
        if seconds >= 10 { minutesString = String(seconds) } else { minutesString = String("0\(seconds)")}
        
        let workoutDurationString = hoursString + ":" + minutesString
        
        return workoutDurationString
    }
    
    private let labelOpacity = 0.50
}

struct WorkoutProgress_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WorkoutProgress(
                sessions: .constant(UserData.jumpSessionsData),
                workout: UserData.workoutsData[0],
                completeJumpSequence: [
                    JumpTimePair(jumpType: .basic, duration: 10, id: UUID()),
                    JumpTimePair(jumpType: .basic, duration: 10, id: UUID())
                ],
                removeActivity: { _ in }
            )
            WorkoutProgress(
                sessions: .constant(UserData.jumpSessionsData),
                workout: UserData.workoutsData[0],
                completeJumpSequence: [
                    JumpTimePair(jumpType: .basic, duration: 10, id: UUID()),
                    JumpTimePair(jumpType: .basic, duration: 10, id: UUID())
                ],
                removeActivity: { _ in }
            )
.previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
