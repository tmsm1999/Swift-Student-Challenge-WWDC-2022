//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation

enum JumpType: String, CaseIterable, Codable {
    case rest = "Rest"
    case basic = "Basic"
    case alternateFootStep = "Alternate Footstep"
    case highKnee = "High-Knees"
    case crissCross = "Criss-Cross"
    case doubleUnder = "Double-Under"
    case singleFoot = "Single-Foot"
    case other = "Other"
}
