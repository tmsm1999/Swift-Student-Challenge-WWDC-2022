//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct Activity: View {
    
    @Binding var sessions: [JumpSession]
    
    let removeActivity: (UUID) -> Void
    let saveAction: () -> Void
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var currentMonth = ""
    @State private var previousMonth = ""
    
    var sessionSections: [(Int, Int, [JumpSession])] {
        var sections: [(Int, Int, [JumpSession])] = []
        for session in sessions {
            
            guard let month = Int(session.startDate.split(separator: "/")[1]) else {
                continue
            }
            
            guard let year = Int(session.startDate.split(separator: "/")[2]) else {
                continue
            }
            
            if let (currentMonth, _, sessions) = sections.last, currentMonth == month {
                sections[sections.endIndex - 1] = (
                    currentMonth,
                    year,
                    sessions + [session]
                )
            } else {
                sections.append(
                    (
                        month,
                        year,
                        [session]
                    )
                )
            }
        }
        
        return sections
    }
    
    var body: some View {
        NavigationView {
            
            if sessions.isEmpty {
                VStack {
                    Text("You haven't done any workouts yet")
                        .foregroundColor(Color.gray)
                        .bold()
                }
                .navigationBarTitle(Text("Activity"))
            } else {
                
                ScrollView {
                    ForEach(sessionSections, id: \.0) { month, year, jumpSessions in
                        
                        HStack {
                            Text("\(digitToMonthString(month: month)) \(String(format: "%d", year))")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        .padding([.leading, .top])

                        ForEach(jumpSessions) { session in
                            NavigationLink(destination: ActivityDetails(jumpSession: session, removeActivity: removeActivity, enableDoneButton: false)) {
                                ActivityCard(jumpSession: session)
                                    .padding(.top, 5)
                                    .tint(.black)
                            }
                        }
                    }
                }
                .padding(.bottom)
                .navigationBarTitle(Text("Activity"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0))
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive { saveAction() }
                }
                .animation(.easeInOut(duration: 0.25), value: sessions)
                .transition(.asymmetric(
                    insertion: .move(edge: .leading),
                    removal: .move(edge: .trailing))
                )
            }
        }
    }
    
    func isEqualMonth(workoutOneDate: String, workoutTwoString: String) -> Bool {
        return workoutOneDate.split(separator: "/")[1] != workoutTwoString.split(separator: "/")[1]
    }
    
    func digitToMonthString(month: Int) -> String {
        
        if month == 1 { return "January" }
        else if month == 2 { return "February" }
        else if month == 3 { return "March" }
        else if month == 4 { return "April" }
        else if month == 5 { return "May" }
        else if month == 6 { return "June" }
        else if month == 7 { return "July" }
        else if month == 8 { return "August" }
        else if month == 9 { return "September" }
        else if month == 10 { return "October" }
        else if month == 11 { return "November" }
        else if month == 12 { return "December" }
        return ""
    }
}

struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        Activity(
            sessions: .constant(UserData.jumpSessionsData),
            removeActivity: { _ in },
            saveAction: {}
        )
    }
}
