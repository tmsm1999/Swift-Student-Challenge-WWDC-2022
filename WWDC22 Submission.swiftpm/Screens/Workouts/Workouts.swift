//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct Workouts: View {
    
    enum SortBy: String, CaseIterable {
        case nameAscending = "Name Ascending"
        case nameDescending = "Name Descending"
        case duration = "Duration"
        case favorites = "Favorites"
    }
    
    @Binding var workouts: [JumpPlan]
    @Binding var sessions: [JumpSession]
    
    @State private var showWorkoutStudioEditor = false
    @State private var sortedBy: SortBy = .nameAscending
    @State private var segmentSelection = 1
    
    @State private var showFavortiesOnly = true
    
    @Environment(\.scenePhase) private var scenePhase
    
    let addWorkout: (JumpPlan) -> Void
    let removeWorkout: (UUID) -> Void
    let removeActivity: (UUID) -> Void
    let saveAction: () -> Void
    
    @State private var searchText = ""

    var body: some View {
        
        NavigationView {
            ScrollView(showsIndicators: true) {
                
                Picker("Jump Segments", selection: $segmentSelection) {
                    Text("Your Jumps").tag(1)
                    Text("Featured Jumps").tag(0)
                }
                .frame(width: screenWidth * 0.90)
                .padding([.top, .bottom], 12)
                .pickerStyle(SegmentedPickerStyle())
                
                switch segmentSelection {
                case 0:
                    ForEach($workouts) { $workout in
                        if workout.isFeatured && (workout.isFavorite || showFavortiesOnly) && (searchText.isEmpty || workout.name.lowercased().contains(searchText.lowercased())) {
                            
                            WorkoutCard(
                                workout: $workout,
                                sessions: $sessions,
                                removeWorkout: removeWorkout,
                                removeActivity: removeActivity
                            )
                                .padding([.leading, .trailing])
                                .padding(.top, 4)
                        }
                    }
                default:
                    ForEach($workouts) { $workout in
                        if !workout.isFeatured && (workout.isFavorite || showFavortiesOnly) && (searchText.isEmpty || workout.name.lowercased().contains(searchText.lowercased())) {
                            WorkoutCard(
                                workout: $workout,
                                sessions: $sessions,
                                removeWorkout: removeWorkout,
                                removeActivity: removeActivity
                            )
                                .padding([.leading, .trailing])
                                .padding(.top, 4)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText)
            .animation(.easeInOut(duration: 0.25), value: workouts)
            .transition(.asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing))
            )
            .navigationTitle(Text("Jump Plans"))
            .navigationBarItems(
                leading:
                    Button(showFavortiesOnly ? "Show Favorites Only" : "Show All") {
                        showFavortiesOnly.toggle()
                    },
                trailing:
                    HStack {
                        Button {
                            showWorkoutStudioEditor.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                        }
                        .opacity(segmentSelection == 0 ? 0 : 1)
                        .fullScreenCover(isPresented: $showWorkoutStudioEditor) {
                            WorkoutStudio(
                                createOrEdit: .create(addWorkout)
                            )
                        }
                    }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0))
            .onChange(of: scenePhase) { phase in
                if phase == .inactive { saveAction() }
            }
            
        }
    }
    
    let screenWidth = UIScreen.main.bounds.width
}

struct JumpPlans_Previews: PreviewProvider {
    static var previews: some View {
        Workouts(
            workouts: .constant(UserData.workoutsData),
            sessions: .constant(UserData.jumpSessionsData),
            addWorkout: { _ in },
            removeWorkout: { _ in },
            removeActivity: { _ in },
            saveAction: { }
        )
    }
}
