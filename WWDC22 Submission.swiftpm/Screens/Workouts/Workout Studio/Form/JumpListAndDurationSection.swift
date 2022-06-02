//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct JumpListAndDurationSection: View {
    
    @Binding var jumpSequence: [JumpTimePair]
    @Binding var numberOfRepetitions: Int
    @Binding var estimatedDuration: Int
    
    @State private var showJumpDetailsSheet = false
    @State private var showCreateNewJumpSheet = false
    @State private var indexToShow = 0
    
    @State private var showEditAlert = false
    
    var workoutIsFeatured: Bool
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Section(content: {
            List {
                ForEach($jumpSequence) { $jump in
                    VStack(alignment: .leading) {
                        Text(jump.jumpType.rawValue)
                            .font(.headline)
                        Text("\(jump.duration) seconds")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        for index in 0 ..< jumpSequence.count {
                            if jumpSequence[index].id == jump.id {
                                indexToShow = index
                                showJumpDetailsSheet.toggle()
                                break
                            }
                        }
                    }
                    .sheet(isPresented: $showJumpDetailsSheet) {
                        JumpDetailsSheet(
                            createOrEdit: .edit(
                                jump: $jumpSequence[indexToShow],
                                removeJump: removeJump
                            )
                        )
                    }
                }
                .onMove { from, to in
                    jumpSequence.move(fromOffsets: from, toOffset: to)
                }
                .onDelete { indices in
                    jumpSequence.remove(atOffsets: indices)
                }
                .onChange(of: jumpSequence) { newValue in
                    var duration = 0
                    for jump in newValue {
                        duration += jump.duration
                    }
                    estimatedDuration = Int((Double((duration * numberOfRepetitions)) / 60.0).rounded(.up))
                }
                
                if !workoutIsFeatured {
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
                        showCreateNewJumpSheet.toggle()
                    }
                    .sheet(isPresented: $showCreateNewJumpSheet) {
                        JumpDetailsSheet(
                            createOrEdit: .create(addJump: addJump)
                        )
                    }
                }
            }
            .disabled(workoutIsFeatured ? true : false)
            .onTapGesture {
                if workoutIsFeatured {
                    showEditAlert.toggle()
                }
            }
        }, header: {
            Text("Jump Sequence")
        })
        .onChange(of: editMode?.wrappedValue) { _ in
            editMode?.wrappedValue = .active
        }
        .alert(Text("You can't edit the jump sequence of a featured workout."), isPresented: $showEditAlert) {
            
        }
        
        Section(content: {
            Stepper(value: $numberOfRepetitions, in: 1...10, step: 1) {
                HStack {
                    Image(systemName: "repeat")
                    numberOfRepetitions != 1 ?
                    Text("\(numberOfRepetitions) repetitions") :
                    Text("\(numberOfRepetitions) repetition")
                }
            }
            .onChange(of: numberOfRepetitions) { newValue in
                var duration = 0
                for jump in jumpSequence {
                    duration += jump.duration
                }
                estimatedDuration = Int((Double((duration * numberOfRepetitions)) / 60.0).rounded(.up))
            }
            
            HStack {
                Image(systemName: "clock")
                estimatedDuration != 1 ?
                    Text("Workout Duration: ~ \(estimatedDuration) minutes") :
                    Text("Workout Duration: ~ \(estimatedDuration) minute")
            }
        }, header: {
            Text("Number of repetitions")
        }, footer: {
            Text("The number of repetitions represents how many times the jump sequence will repeat.")
        })
    }
    
    func addJump(newJump: JumpTimePair) {
        withAnimation(.easeInOut) {
            jumpSequence.append(newJump)
        }
    }
    
    func removeJump(jumpToRemoveID: UUID) {
        withAnimation(.easeInOut) {
            jumpSequence.removeAll(where: { $0.id == jumpToRemoveID })
        }
    }
}


struct JumpListSection_Previews: PreviewProvider {
    static var previews: some View {
        JumpListAndDurationSection(
            jumpSequence: .constant(
                [
                    JumpTimePair(jumpType: .basic, duration: 20),
                    JumpTimePair(jumpType: .rest, duration: 30)
                ]
            ),
            numberOfRepetitions: .constant(3),
            estimatedDuration: .constant(5),
            workoutIsFeatured: false
        )
    }
}
