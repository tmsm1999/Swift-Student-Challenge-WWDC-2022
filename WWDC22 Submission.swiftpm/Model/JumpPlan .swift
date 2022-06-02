//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation
import SwiftUI

struct JumpPlan: Identifiable, Codable, Equatable {
    
    var id = UUID()
    var name: String
    var jumpSequence: [JumpTimePair]
    var numberOfRepetitions: Int
    var estimatedDuration: Int
    var isFavorite: Bool
    var isFeatured = false
    var workoutTheme: Color = Color.accentColor
    var scheduledDates: [WorkoutSchedule]
}


//Vai em cascata recursivamente

//extension JumpPlan {
//
//    init(safelyFrom data: Data) throws {
//        let decoder = JSONDecoder()
//        do {
//            self = try decoder.decode(JumpPlan.self, from: data)
//        } catch {
//            let jumpPlanV1 = try JumpPlanV1(safelyFrom: data)
//            self = JumpPlan(
//                id: jumpPlanV1.id,
//                ame: <#T##String#>,
//                jumpSequence: <#T##[JumpTimePair]#>,
//                numberOfRepetitions: <#T##Int#>,
//                estimatedDuration: <#T##Int#>,
//                isFavorite: <#T##Bool#>,
//                isFeatured: <#T##Bool#>,
//                workoutTheme: <#T##Color#>,
//                scheduledDates: <#T##[WorkoutSchedule]#>
//            )
//        }
//    }
//}
//
//struct JumpPlanV1: Identifiable, Codable, Equatable {
//
//    var id = UUID()
//    var name: String
//    var jumpSequence: [JumpTimePair]
//    var numberOfRepetitions: Int
//    var estimatedDuration: Int
//    var isFavorite: Bool
//    var isFeatured = false
//    var workoutTheme: Color = Color.accentColor
//    var scheduledDates: [WorkoutSchedule]
//}
//
//extension JumpPlanV1 {
//
//    init(safelyFrom data: Data) throws {
//        let decoder = JSONDecoder()
//        do {
//            self = try decoder.decode(JumpPlan.self, from: data)
//        } catch {
//            let jumpPlanV0 = try JumpPlanV0(safelyFrom: data)
//            self = JumpPlan(
//                id: jumpPlanV0.id,
//                ame: <#T##String#>,
//                jumpSequence: <#T##[JumpTimePair]#>,
//                numberOfRepetitions: <#T##Int#>,
//                estimatedDuration: <#T##Int#>,
//                isFavorite: <#T##Bool#>,
//                isFeatured: <#T##Bool#>,
//                workoutTheme: <#T##Color#>,
//                scheduledDates: <#T##[WorkoutSchedule]#>
//            )
//        }
//    }
//}
//
//func getJumpPlan(from data: Data) -> JumpPlan {
//    let decoder = JSONDecoder()
//    do {
//        return try decoder.decode(JumpPlan.self, from: data)
//    } catch {
//        self =
//        return JumpPlan(from: try decoder.decode(JumpPlanV0.self, from: data)
//    }
//}
//
//struct JumpPlanV0: Identifiable, Codable, Equatable {
//
//    var id = UUID()
//    var name: String
//    var jumpSequence: [JumpTimePair]
//    var numberOfRepetitions: Int
//    var estimatedDuration: Int
//    var isFavorite: Bool
//    //var isFeatured = false
//    var workoutTheme: Color = Color.accentColor
//    var scheduledDates: [WorkoutSchedule]
//}
//
//extension JumpPlanV0 {
//    init(safelyFrom data: Data) throws {
//        let decoder = JSONDecoder()
//        self = try decoder.decode(JumpPlanV0.self, from: data)
//    }
//}
