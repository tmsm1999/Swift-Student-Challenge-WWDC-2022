//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct WorkoutStudio: View {
    
    var createOrEdit: CreateOrEdit
    
    @State private var showDeleteAlert = false
    @State private var showWorkoutCantBeSavedAlert = false
    
    @State private var workoutIsToBeDeleted = false
    @State private var workoutIsToBeAdded = false
    
    
    @State private var newWorkout = JumpPlan(
        id: UUID(),
        name: "",
        jumpSequence: [],
        numberOfRepetitions: 3,
        estimatedDuration: 0,
        isFavorite: false,
        workoutTheme: Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
        scheduledDates: []
    )
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) var editMode
    
    enum CreateOrEdit {
        case create((_ newWorkout: JumpPlan) -> Void)
        case edit(
            workout: Binding<JumpPlan>,
            removeWorkout: (_ workoutToRemove: UUID) -> Void
        )
    }
    
    var body: some View {
        NavigationView {
            switch createOrEdit {
            case let .create(addWorkout: addWorkout):
                Form {
                    EditWorkoutSections(workout: $newWorkout)
                    createWorkoutButton()
                }
                    .navigationTitle(Text("Workout Studio"))
                    .navigationBarItems(
                        trailing:
                            Button("Cancel") {
                                dismiss()
                            }
                    )
                    .onDisappear {
                        if workoutIsToBeAdded {
                            addWorkout(newWorkout)
                        }
                    }
            case let .edit(workout: workout, removeWorkout: removeWorkout):
                Form {
                    EditWorkoutSections(workout: workout)
                    if !workout.isFeatured.wrappedValue {
                        removeWorkoutButton()
                    }
                }
                    .navigationTitle(Text("Edit Workout"))
                    .navigationBarItems(
                        trailing:
                            Button(action: {
                                if canBeSavedOrCreated(workout: workout.wrappedValue) {
                                    dismiss()
                                }
                                else {
                                    showWorkoutCantBeSavedAlert.toggle()
                                }
                            }, label: {
                                Text("Save")
                            })
                            .alert(isPresented: $showWorkoutCantBeSavedAlert) {
                                Alert(
                                    title: Text("This Workout can't be saved."),
                                    message: Text("Be sure your Workout has been given a name and you include at leat one type of jump in your sequence."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                    )
                    .onDisappear {
                        if workoutIsToBeDeleted {
                            //withAnimation(.spring()) {
                                removeWorkout(workout.id)
                            //}
                        }
                    }
            }
        }
        .onAppear {
            editMode?.wrappedValue = .active
        }
    }
    
    func canBeSavedOrCreated(workout: JumpPlan) -> Bool {
        return workout.name != "" && workout.jumpSequence.count > 0
    }
    
    func createWorkoutButton() -> some View {
        
        Button(action: {
            // Because of Edit Mode this does not  work?
        }, label: {
            Text("Create Workout")
                .bold()
        })
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .foregroundColor(.white)
        .listRowBackground(canBeSavedOrCreated(workout: newWorkout) ? Color.accentColor : Color.gray)
        .disabled(!canBeSavedOrCreated(workout: newWorkout))
        .onTapGesture {
            workoutIsToBeAdded = true
            dismiss()
        }
    }
    
    func removeWorkoutButton() -> some View {
        Button(action: {
            showDeleteAlert.toggle()
        }, label: {
            Text("Delete Workout")
                .bold()
        })
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .foregroundColor(.white)
        .listRowBackground(Color.red)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this Workout?"),
                message: Text("You will no longer be able do this workout or edit iomt. It may also have an impact on the information available in your activity."),
                primaryButton:
                        .destructive(
                            Text("Delete"),
                            action: {
                                workoutIsToBeDeleted = true
                                dismiss()
                            }
                        ),
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .onTapGesture {
            showDeleteAlert.toggle()
        }
    }
}

private struct EditWorkoutSections: View {
    
    @Binding var workout: JumpPlan
    
    var body: some View {
        if !workout.isFeatured {
            WorkoutNameTextFiled(
                name: $workout.name
            )
        }
        
        JumpListAndDurationSection(
            jumpSequence: $workout.jumpSequence,
            numberOfRepetitions: $workout.numberOfRepetitions,
            estimatedDuration: $workout.estimatedDuration,
            workoutIsFeatured: workout.isFeatured
        )
        
        FavoriteAndThemeSection(
            isFavorite: $workout.isFavorite,
            workoutTheme: $workout.workoutTheme
        )
        
        ScheduleWorkoutSection(
            scheduledDates: $workout.scheduledDates
        )
    }
}

struct CreateWorkout_Previews: PreviewProvider {
    
    static var previews: some View {
        WorkoutStudio(createOrEdit: .create { workout in })
    }
}
