//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct ScheduleWorkoutSheet: View {
    
    @State private var scheduleIsToBeAdded = false
    @State private var scheduleIsToBeDeleted = false
    
    @State private var newWorkoutSchedule = WorkoutSchedule()
    @State private var showDeleteScheduleAlert = false
    
    var createOrEdit: CreateOrEditSchedule
    
    @Environment(\.dismiss) private var dismiss
    
    enum CreateOrEditSchedule {
        case create(addWorkoutSchedule: (WorkoutSchedule) -> Void)
        case edit(
            schedule: Binding<WorkoutSchedule>,
            removeWorkoutSchedule: (_ removeWorkoutSchedule: UUID) -> Void
        )
    }
    
    var body: some View {
        NavigationView {
            switch createOrEdit {
            case let .create(addWorkoutSchedule: addWorkoutSchedule):
                Form {
                    EditScheduleSction(workoutSchedule: $newWorkoutSchedule)
                    addToScheduleButton()
                }
                    .navigationTitle(Text("Schedule Workout"))
                    .navigationBarItems(trailing:
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Cancel")
                        })
                    )
                    .onDisappear {
                        if scheduleIsToBeAdded {
                            addWorkoutSchedule(newWorkoutSchedule)
                        }
                    }
            case let .edit(schedule: workoutSchedule, removeWorkoutSchedule: removeWorkoutSchedule):
                Form {
                    EditScheduleSction(workoutSchedule: workoutSchedule)
                    removeFromScheduleButton()
                }
                    .navigationTitle(Text("Edit Schedule"))
                    .navigationBarItems(trailing:
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Save")
                        })
                    )
                    .onDisappear {
                        if scheduleIsToBeDeleted {
                            removeWorkoutSchedule(workoutSchedule.id)
                        }
                    }
            }
        }
    }
    
    func addToScheduleButton() -> some View {
        Button {
            scheduleIsToBeAdded = true
            dismiss()
        } label: {
            Text("Schedule Workout")
                .bold()
        }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .listRowBackground(Color.accentColor)
    }
    
    func removeFromScheduleButton() -> some View {
        Button {
            scheduleIsToBeDeleted = true
            dismiss()
        } label: {
            Text("Remove Schedule")
                .bold()
        }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .listRowBackground(Color.red)
//            .alert(isPresented: $showDeleteScheduleAlert) {
//                Alert(
//                    title: Text("Delete from Schedule"),
//                    message: Text("Are you sure you want to delete this workout from the schedule?"),
//                    primaryButton:
//                            .default(Text("Yes"),
//                             action: {
//                                 scheduleIsToBeDeleted = true
//                                 dismiss()
//                             }),
//                    secondaryButton: .cancel()
//                )
//            }
    }
}

private struct EditScheduleSction: View {
    
    @Binding var workoutSchedule: WorkoutSchedule
    
    var body: some View {
        Section {
            DatePicker("Schedule Workout", selection: $workoutSchedule.date)
                .datePickerStyle(.graphical)
        }
        
        Section {
            Picker("Repeat", selection: $workoutSchedule.typeOfRepetition) {
                ForEach(TypeofRepetition.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
        }
    }
}

struct ScheduleWorkoutSheet_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleWorkoutSheet(createOrEdit: .create { date in })
    }
}
