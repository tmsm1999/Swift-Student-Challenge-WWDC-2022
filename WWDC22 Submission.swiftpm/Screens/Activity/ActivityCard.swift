//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct ActivityCard: View {
    
    var jumpSession: JumpSession
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(jumpSession.workout.name)
                        .italic()
                        .font(.system(size: 20.5))
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text(jumpSession.startDate)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text(jumpSession.startTime + " - " + jumpSession.endTime)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text(jumpSession.duration)
                        .fontWeight(.semibold)
                    Text("Duration")
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(jumpSession.averageHeartRate != nil ? String("\(jumpSession.averageHeartRate!)") : "-")
                            .fontWeight(.semibold)
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                    Text("Avg. HR")
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text(jumpSession.caloriesBurned != nil ? String("\(jumpSession.caloriesBurned!)") : "-")
                        .fontWeight(.semibold)
                    Text("Calories")
                }
            }
            .padding([.bottom, .leading, .trailing])
            
            Spacer()
        }
        .frame(width: screenWidth * 0.92, height: 145, alignment: .center)
        .background(jumpSession.workout.workoutTheme.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 15.0))
    }
    
    private let screenWidth = UIScreen.main.bounds.width
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard(jumpSession: UserData.jumpSessionsData[3])
    }
}
