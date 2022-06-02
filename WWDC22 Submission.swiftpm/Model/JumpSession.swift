//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation
import CoreLocation
import SwiftUI

struct JumpSession: Identifiable, Codable, Equatable {
    
    static func == (lhs: JumpSession, rhs: JumpSession) -> Bool {
        return lhs.id == rhs.id ? true : false
    }
    
    
    var id = UUID()
    var location: Location?
    var workout: JumpPlan
    
    var startDate: String
    var startTime: String
    var endTime: String
    var duration: String
    
    var highestHeartRate: Int?
    var averageHeartRate: Int?
    var caloriesBurned: Int?
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double
}
