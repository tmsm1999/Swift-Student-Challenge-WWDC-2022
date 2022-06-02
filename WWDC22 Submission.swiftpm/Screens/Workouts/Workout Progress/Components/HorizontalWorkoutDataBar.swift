//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct HorizontalWorkoutDataBar: View {
    
    @State private var numberOfJumps = 850
    @State private var currentHeartRate = 152
    
    @Binding var totalElapsedTime: Int
    
    var body: some View {
        HStack {
            
            VStack {
                Text("\(numberOfJumps)")
                    .font(.title)
                    .bold()
                Text("Jumps")
                    .font(.title3)
                    .bold()
                    .opacity(labelOpacity)
            }
            .frame(width: screenWidth / 3)
            
            Spacer()
            
            VStack {
                Text("\(String(format: "%02d", totalElapsedTime / 60)):\(String(format: "%02d", totalElapsedTime % 60))")
                    .font(.title)
                    .bold()
                Text("Time")
                    .font(.title3)
                    .bold()
                    .opacity(labelOpacity)
            }
            .frame(width: screenWidth / 3)

            Spacer()
            
            VStack {
                Text("\(currentHeartRate)")
                    .font(.title)
                    .bold()
                Text("BPM")
                    .font(.title3)
                    .bold()
                    .opacity(labelOpacity)
            }
            .frame(width: screenWidth / 3)
        }
        .padding()
    }
    
    private let labelOpacity = 0.50
    private let screenWidth = UIScreen.main.bounds.width
}

struct HorizontalBar_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalWorkoutDataBar(totalElapsedTime: .constant(132))
    }
}
