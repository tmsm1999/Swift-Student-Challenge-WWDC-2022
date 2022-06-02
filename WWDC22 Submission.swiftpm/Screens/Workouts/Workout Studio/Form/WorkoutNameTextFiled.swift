//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct WorkoutNameTextFiled: View {
    
    @Binding var name: String
    
    var body: some View {
        Section {
            TextField(
                "Workout Name",
                text: $name,
                prompt: Text(" Workout name")
            )
        }
    }
}

struct WorkoutNameTextFiled_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutNameTextFiled(
            name: .constant("Saturday Jumps")
        )
    }
}
