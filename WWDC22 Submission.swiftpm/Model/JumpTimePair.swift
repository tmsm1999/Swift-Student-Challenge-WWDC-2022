//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation

struct JumpTimePair: Identifiable, Codable, Equatable {
    
    var jumpType: JumpType
    var duration: Int
    var id = UUID()
    var repetition: Int?
}
