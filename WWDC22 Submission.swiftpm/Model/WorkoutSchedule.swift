//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation

enum TypeofRepetition: String, CaseIterable, Codable {
    case none = "Never"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct WorkoutSchedule: Identifiable, Codable, Equatable {
    var date = Date()
    var typeOfRepetition: TypeofRepetition = .none
    var id = UUID()
}
