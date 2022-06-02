//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct ScheduleWorkoutSection: View {
    
    @Binding var scheduledDates: [WorkoutSchedule]

    @State private var isInEditMode = false
    @State private var isInCreationMode = false
    @State private var indexToShow = 0
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Section {
            List {
                ForEach($scheduledDates) { $scheduledDate in
                    HStack {
                        Text(formatDate(date: scheduledDate.date))
                        Spacer()
                        if scheduledDate.typeOfRepetition.rawValue == "Weekly" ||
                            scheduledDate.typeOfRepetition.rawValue == "Monthly" {
                            Image(systemName: "repeat.circle")
                                .foregroundColor(Color.black)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        for index in 0 ..< scheduledDates.count {
                            if scheduledDates[index].id == scheduledDate.id {
                                indexToShow = index
                                isInEditMode.toggle()
                                break
                            }
                        }
                    }
                    .sheet(isPresented: $isInEditMode) {
                        ScheduleWorkoutSheet(
                            createOrEdit: .edit(
                                schedule: $scheduledDates[indexToShow],
                                removeWorkoutSchedule: removeWorkoutSchedule
                            )
                        )
                    }
                }
                .onDelete { indices in
                    scheduledDates.remove(atOffsets: indices)
                }
                
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .imageScale(.large)
                        .padding(.leading, -2)
                        .padding(.trailing, 11)
                    Text("Add")
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    isInCreationMode.toggle()
                }
                .sheet(isPresented: $isInCreationMode) {
                    ScheduleWorkoutSheet(
                        createOrEdit: .create(addWorkoutSchedule: addWorkoutSchedule)
                    )
                }
            }
        } header: {
            Text("Schedule Workout")
        } footer: {
            scheduledDates.count > 0 ?
            Text("You may receive a notification 5 minutes before the scheduled time.") :
            Text("You have not sheduled this workout for any day yet.")
        }
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
    
    func addWorkoutSchedule(newSchedule: WorkoutSchedule) {
        withAnimation(.easeInOut) {
            scheduledDates.append(newSchedule)
        }
    }
    
    func removeWorkoutSchedule(sheduleToRemoveID: UUID) {
        withAnimation(.easeInOut) {
            scheduledDates.removeAll(where: { $0.id == sheduleToRemoveID })
        }
    }
}

struct ScheduleWorkoutSection_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleWorkoutSection(
            scheduledDates: .constant([WorkoutSchedule]())
        )
    }
}
