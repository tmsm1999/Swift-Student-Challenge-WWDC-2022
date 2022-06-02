import SwiftUI

@main
struct MyApp: App {
    
    @ObservedObject private var userData = UserData()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Home(name: $personalData.name)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                Workouts(workouts: $workoutsData, sessions: $sessions, addWorkout: addWorkout, removeWorkout: removeWorkout, removeActivity: removeActivity) {
                    userData.saveData()
                }
                    .tabItem {
                        Label("Workouts", systemImage: "rectangle.grid.1x2.fill")
                    }
                
                Activity(sessions: $sessions, removeActivity: removeActivity) {
                    userData.saveData()
                }
                    .tabItem {
                        Label("Activity", systemImage: "chart.bar.fill")
                    }

//                Text("Insights")
//                    .tabItem {
//                        Label("Insights", systemImage: "chart.pie.fill")
//                }

                Settings(personalData: $personalData, activity: $sessions) {
                    userData.saveData()
                }
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .onAppear {
                //userData.loadData()
                //requestUserLocationWhileInUse()
            }
        }
    }
    
    @State var personalData = PersonalData(name: "WWDC22", height: 181)
    
    @State var workoutsData = [
        JumpPlan(
            id: UUID(),
            name: "Jumping to WWDC",
            jumpSequence: [
                JumpTimePair(jumpType: .crissCross, duration: 20, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .crissCross, duration: 20, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 20, id: UUID()),
            ],
            numberOfRepetitions: 2,
            estimatedDuration: 4,
            isFavorite: true,
            workoutTheme: Color.init(red: 93 / 255, green: 201 / 255, blue: 170 / 255),
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .weekly, id: UUID())
            ]
        ),
        JumpPlan(
            id: UUID(),
            name: "California Dreaming",
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
            isFeatured: true,
            workoutTheme: Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .none, id: UUID())
            ]
        ),
        JumpPlan(
            id: UUID(),
            name: "Flying to Cupertino",
            jumpSequence: [
                JumpTimePair(jumpType: .doubleUnder, duration: 40, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .singleFoot, duration: 40, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
            ],
            numberOfRepetitions: 5,
            estimatedDuration: 4,
            isFavorite: false,
            isFeatured: true,
            workoutTheme: Color.init(red: 224 / 255, green: 101 / 255, blue: 101 / 255),
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
            ]
        ),
        JumpPlan(
            id: UUID(),
            name: "Jumping Like Phil",
            jumpSequence: [
                JumpTimePair(jumpType: .basic, duration: 30, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .highKnee, duration: 30, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .doubleUnder, duration: 30, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 30, id: UUID()),
            ],
            numberOfRepetitions: 2,
            estimatedDuration: 5,
            isFavorite: true,
            isFeatured: false,
            workoutTheme: Color.init(red: 229 / 255, green: 195 / 255, blue: 66 / 255),
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
            ]
        ),
        JumpPlan(
            id: UUID(),
            name: "Going All-in",
            jumpSequence: [
                JumpTimePair(jumpType: .basic, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .crissCross, duration: 30, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .doubleUnder, duration: 30, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 20, id: UUID()),
                
            ],
            numberOfRepetitions: 7,
            estimatedDuration: 5,
            isFavorite: false,
            isFeatured: false,
            workoutTheme: Color.init(red: 173 / 255, green: 119 / 255, blue: 220 / 255),
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID()),
                WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
            ]
        ),
        JumpPlan(
            id: UUID(),
            name: "Jump Higher",
            jumpSequence: [
                JumpTimePair(jumpType: .basic, duration: 20, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .alternateFootStep, duration: 20, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                JumpTimePair(jumpType: .crissCross, duration: 20, id: UUID()),
                
            ],
            numberOfRepetitions: 2,
            estimatedDuration: 3,
            isFavorite: false,
            isFeatured: true,
            workoutTheme: Color.init(red: 90 / 255, green: 196 / 255, blue: 217 / 255),
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
            ]
        ),
        JumpPlan(
            id: UUID(),
            name: "Warm-up",
            jumpSequence: [
                JumpTimePair(jumpType: .basic, duration: 30, id: UUID()),
                JumpTimePair(jumpType: .rest, duration: 10, id: UUID())
            ],
            numberOfRepetitions: 5,
            estimatedDuration: 3,
            isFavorite: true,
            isFeatured: false,
            workoutTheme: Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
            scheduledDates: [
                WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
            ]
        )
    ]
    
    @State private var sessions = [
        JumpSession(
            id: UUID(),
            location: Location(latitude: 37.334886, longitude: -122.008988),
            workout: JumpPlan(
                id: UUID(),
                name: "Jumping to WWDC",
                jumpSequence: [
                    JumpTimePair(jumpType: .basic, duration: 20, id: UUID()),
                    JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                    JumpTimePair(jumpType: .basic, duration: 20, id: UUID()),
                    JumpTimePair(jumpType: .rest, duration: 10, id: UUID()),
                    JumpTimePair(jumpType: .basic, duration: 20, id: UUID()),
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID()),
                ],
                numberOfRepetitions: 2,
                estimatedDuration: 4,
                isFavorite: true,
                workoutTheme: Color.init(red: 93 / 255, green: 201 / 255, blue: 170 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .weekly, id: UUID())
                ]
            ),
            startDate: "05/06/2022",
            startTime: "09:41",
            endTime: "10:11",
            duration: "00:30",
            highestHeartRate: 186,
            averageHeartRate: 166,
            caloriesBurned: 300
        ),
        JumpSession(
            id: UUID(),
            location: Location(latitude: 37.334886, longitude: -122.008988),
            workout: JumpPlan(
                id: UUID(),
                name: "California Dreaming",
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
                isFeatured: true,
                workoutTheme: Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .none, id: UUID())
                ]
            ),
            startDate: "13/05/2022",
            startTime: "08:38",
            endTime: "09:11",
            duration: "00:33",
            highestHeartRate: 181,
            averageHeartRate: 163,
            caloriesBurned: 298
        ),
        JumpSession(
            id: UUID(),
            location: Location(latitude: 37.334886, longitude: -122.008988),
            workout: JumpPlan(
                id: UUID(),
                name: "Flying to Cupertino",
                jumpSequence: [
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
                ],
                numberOfRepetitions: 7,
                estimatedDuration: 5,
                isFavorite: false,
                isFeatured: true,
                workoutTheme: Color.init(red: 224 / 255, green: 101 / 255, blue: 101 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
                ]
            ),
            startDate: "07/05/2022",
            startTime: "09:40",
            endTime: "10:00",
            duration: "00:20",
            highestHeartRate: 177,
            averageHeartRate: 162,
            caloriesBurned: 272
        ),
        JumpSession(
            id: UUID(),
            location: Location(latitude: 37.334886, longitude: -122.008988),
            workout: JumpPlan(
                id: UUID(),
                name: "Jumping Like Phil",
                jumpSequence: [
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
                ],
                numberOfRepetitions: 7,
                estimatedDuration: 5,
                isFavorite: true,
                isFeatured: false,
                workoutTheme: Color.init(red: 229 / 255, green: 195 / 255, blue: 66 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
                ]
            ),
            startDate: "24/02/2022",
            startTime: "10:30",
            endTime: "10:50",
            duration: "00:20",
            highestHeartRate: 199,
            averageHeartRate: 177,
            caloriesBurned: 342
        ),
        JumpSession(
            id: UUID(),
            location: Location(latitude: 37.334886, longitude: -122.008988),
            workout: JumpPlan(
                id: UUID(),
                name: "Going All-in",
                jumpSequence: [
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
                ],
                numberOfRepetitions: 7,
                estimatedDuration: 5,
                isFavorite: false,
                isFeatured: false,
                workoutTheme: Color.init(red: 173 / 255, green: 119 / 255, blue: 220 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID()),
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
                ]
            ),
            startDate: "02/02/2022",
            startTime: "19:32",
            endTime: "20:01",
            duration: "00:29",
            highestHeartRate: 198,
            averageHeartRate: 179,
            caloriesBurned: 334
        ),
        JumpSession(
            id: UUID(),
            location: Location(latitude: 37.334886, longitude: -122.008988),
            workout: JumpPlan(
                id: UUID(),
                name: "Jump Higher",
                jumpSequence: [
                    JumpTimePair(jumpType: .rest, duration: 20, id: UUID())
                ],
                numberOfRepetitions: 7,
                estimatedDuration: 5,
                isFavorite: false,
                isFeatured: true,
                workoutTheme: Color.init(red: 90 / 255, green: 196 / 255, blue: 217 / 255),
                scheduledDates: [
                    WorkoutSchedule(date: Date(), typeOfRepetition: .monthly, id: UUID())
                ]
            ),
            startDate: "01/01/2022",
            startTime: "00:01",
            endTime: "00:11",
            duration: "00:10",
            highestHeartRate: 192,
            averageHeartRate: 176,
            caloriesBurned: 304
        ),
        JumpSession(
            id: UUID(),
            location: Location(latitude: 37.334886, longitude: -122.008988),
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
            startDate: "25/12/2021",
            startTime: "16:33",
            endTime: "16:55",
            duration: "00:22",
            highestHeartRate: 190,
            averageHeartRate: 160,
            caloriesBurned: 260
        ),
    ]
    
    func addWorkout(workout: JumpPlan) {
        workoutsData.insert(workout, at: 0)
    }
    
    func removeWorkout(workoutToRemoveID: UUID) {
        workoutsData.removeAll(where: { $0.id == workoutToRemoveID })
    }
    
    func removeActivity(activityToRemoveID: UUID) {
        sessions.removeAll(where: { $0.id == activityToRemoveID })
    }
}
