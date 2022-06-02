//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation
import SwiftUI

// Any view observing an instance of UserData will re-render when values change.
class UserData: ObservableObject {
    
    @Published var personalData: PersonalData = PersonalData(name: "Tomás", height: 181)
    @Published var workouts: [JumpPlan] = []
    @Published var sessions: [JumpSession] = []
    
    // We will load and save scrums to a file in the user's Documents Folder.
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    private static var personalDataFileURL: URL {
        return documentsFolder.appendingPathComponent("Personal.data")
    }
    
    private static var workoutsDataFileURL: URL {
        return documentsFolder.appendingPathComponent("Workouts.data")
    }
    
    private static var sessionsDataFileURL: URL {
        return documentsFolder.appendingPathComponent("Sessions.data")
    }
    
    // Load data
    func loadData() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.personalDataFileURL) else { return }
            guard let personalData = try? JSONDecoder().decode(PersonalData.self, from: data) else {
                fatalError("Can't decode saved personal data.")
            }
            
            DispatchQueue.main.async {
                self?.personalData = personalData
            }
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.workoutsDataFileURL) else { return }
            guard let workouts = try? JSONDecoder().decode([JumpPlan].self, from: data) else {
                fatalError("Can't decode saved workouts data.")
            }
            
            DispatchQueue.main.async {
                self?.workouts = workouts
            }
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.sessionsDataFileURL) else { return }
            guard let sessions = try? JSONDecoder().decode([JumpSession].self, from: data) else {
                fatalError("Can't decode saved sessions data.")
            }
            
            DispatchQueue.main.async {
                self?.sessions = sessions
            }
        }
    }
    
    func saveData() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let personalData = self?.personalData else { fatalError("Self out of scope.") }
            guard let data = try? JSONEncoder().encode(personalData) else {
                fatalError("Error encoding user's personal data.")
            }
            
            do {
                let personalDataFile = Self.personalDataFileURL
                try data.write(to: personalDataFile)
            } catch {
                fatalError("Can't write to personal data file.")
            }
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let workouts = self?.workouts else { fatalError("Self out of scope.") }
            guard let data = try? JSONEncoder().encode(workouts) else {
                fatalError("Error encoding user's workouts.")
            }
            
            do {
                let workoutsFile = Self.workoutsDataFileURL
                try data.write(to: workoutsFile)
            } catch {
                fatalError("Can't write to workouts file.")
            }
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let sessions = self?.sessions else { fatalError("Self out of scope.") }
            guard let data = try? JSONEncoder().encode(sessions) else {
                fatalError("Error encoding user's sessions.")
            }
            
            do {
                let sessionsFile = Self.sessionsDataFileURL
                try data.write(to: sessionsFile)
            } catch {
                fatalError("Can't write to sessions file.")
            }
        }
    }
}

extension UserData {
    static var workoutsData = [
        JumpPlan(
            id: UUID(),
            name: "Saturday Jumps",
            jumpSequence: [
                JumpTimePair(jumpType: .basic, duration: 5, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 5, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 5, id: UUID()),
                JumpTimePair(jumpType: .crissCross, duration: 5, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 5, id: UUID()),
                JumpTimePair(jumpType: .crissCross, duration: 5, id: UUID()),
            ],
            numberOfRepetitions: 3,
            estimatedDuration: 5,
            isFavorite: false,
            workoutTheme: Color.accentColor,
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .weekly, id: UUID()),
                WorkoutSchedule(date: Date(), typeOfRepetition: .weekly, id: UUID())
            ]
        ),
        
        JumpPlan(
            id: UUID(),
            name: "All-in",
            jumpSequence: [
                JumpTimePair(jumpType: .basic, duration: 20, id: UUID()),
                JumpTimePair(jumpType: .crissCross, duration: 40, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 30, id: UUID()),
                JumpTimePair(jumpType: .doubleUnder, duration: 20, id: UUID()),
                JumpTimePair(jumpType: .highKnee, duration: 40, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 60, id: UUID()),
            ],
            numberOfRepetitions: 4,
            estimatedDuration: 6,
            isFavorite: true,
            workoutTheme: Color.accentColor,
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .none, id: UUID()),
                WorkoutSchedule(date: Date(), typeOfRepetition: .none, id: UUID())
            ]
        ),
        
        JumpPlan(
            id: UUID(),
            name: "Day off",
            jumpSequence: [
                JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
            ],
            numberOfRepetitions: 7,
            estimatedDuration: 5,
            isFavorite: true,
            workoutTheme: Color.accentColor,
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID()),
                WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
            ]
        )
    ]
    
    static var jumpSessionsData = [
        JumpSession(
            id: UUID(),
            location: UserLocation().getUserLocation(),
            workout: JumpPlan(
                id: UUID(),
                name: "Warm-up",
                jumpSequence: [
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
                ],
                numberOfRepetitions: 7,
                estimatedDuration: 5,
                isFavorite: true,
                isFeatured: false,
                workoutTheme: Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
                ]
            ),
            startDate: "03/10/2021",
            startTime: "16:33",
            endTime: "16:55",
            duration: "00:22",
            highestHeartRate: 188,
            averageHeartRate: 159,
            caloriesBurned: 276
            //workoutTheme: Color.accentColor
        ),
        
        JumpSession(
            id: UUID(),
            location: UserLocation().getUserLocation(),
            workout: JumpPlan(
                id: UUID(),
                name: "Warm-up",
                jumpSequence: [
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
                ],
                numberOfRepetitions: 7,
                estimatedDuration: 5,
                isFavorite: true,
                isFeatured: false,
                workoutTheme: Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
                ]
            ),
            startDate: "05/11/2021",
            startTime: "16:33",
            endTime: "16:55",
            duration: "00:33",
            highestHeartRate: 192,
            averageHeartRate: 171,
            caloriesBurned: 311
            //workoutTheme: Color.accentColor
        ),
        
        JumpSession(
            id: UUID(),
            location: UserLocation().getUserLocation(),
            workout: JumpPlan(
                id: UUID(),
                name: "Warm-up",
                jumpSequence: [
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
                ],
                numberOfRepetitions: 7,
                estimatedDuration: 5,
                isFavorite: true,
                isFeatured: false,
                workoutTheme: Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
                ]
            ),
            startDate: "16/11/2021",
            startTime: "18:33",
            endTime: "18:55",
            duration: "00:20",
            highestHeartRate: 196,
            averageHeartRate: 166,
            caloriesBurned: 298
            //workoutTheme: Color.accentColor
        ),
        
        JumpSession(
            id: UUID(),
            location: UserLocation().getUserLocation(),
            workout: JumpPlan(
                id: UUID(),
                name: "Warm-up",
                jumpSequence: [
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
                ],
                numberOfRepetitions: 7,
                estimatedDuration: 5,
                isFavorite: true,
                isFeatured: false,
                workoutTheme: Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
                ]
            ),
            startDate: "02/12/2021",
            startTime: "16:33",
            endTime: "16:55",
            duration: "00:15",
            highestHeartRate: 202,
            averageHeartRate: 165,
            caloriesBurned: 250
            //workoutTheme: Color.accentColor
        ),
        
        JumpSession(
            id: UUID(),
            location: UserLocation().getUserLocation(),
            workout: JumpPlan(
                id: UUID(),
                name: "Warm-up",
                jumpSequence: [
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
                ],
                numberOfRepetitions: 7,
                estimatedDuration: 5,
                isFavorite: true,
                isFeatured: false,
                workoutTheme: Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
                ]
            ),
            startDate: "20/12/2021",
            startTime: "16:33",
            endTime: "16:55",
            duration: "00:30",
            highestHeartRate: 199,
            averageHeartRate: 159,
            caloriesBurned: 300
            //workoutTheme: Color.accentColor
        )
    ]
}
