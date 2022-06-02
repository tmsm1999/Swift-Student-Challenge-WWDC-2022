//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct JumpDetailsSheet: View {
    
    @State private var jumpIsToBeAdded = false
    @State private var jumpIsToBeDeleted = false
    
    var createOrEdit: CreateOrEditJump
    @State private var newJump = JumpTimePair(jumpType: .rest, duration: 10)
    
    enum CreateOrEditJump {
        case create(addJump: (_ newJump: JumpTimePair) -> Void)
        case edit(
            jump: Binding<JumpTimePair>,
            removeJump: (_ jumpToRemove: UUID) -> Void
        )
    }
    
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        NavigationView {
            switch createOrEdit {
            case let .create(addJump: addJump):
                Form {
                    EditJumpSections(jump: $newJump)
                    addJumpButton()
                }
                .navigationTitle(Text("Create Jump"))
                .navigationBarItems(trailing:
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                )
                .onDisappear {
                    print("Jump Added")
                    if jumpIsToBeAdded {
                        addJump(newJump)
                    }
                }
            case let .edit(jump: jump, removeJump: removeJump):
                Form {
                    EditJumpSections(jump: jump)
                    removeJumpButton()
                }
                .navigationTitle(Text("Edit Jump"))
                .navigationBarItems(trailing:
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Save")
                    })
                )
                .onDisappear {
                    if jumpIsToBeDeleted {
                        print("Jump Deleted")
                        removeJump(jump.id)
                    }
                }
                
            }
        }
    }
    
    func addJumpButton() -> some View {
        Button {
            jumpIsToBeAdded = true
            dismiss()
        } label: {
            Text("Add Jump")
                .bold()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .listRowBackground(Color.accentColor)
    }
    
    func removeJumpButton() -> some View {
        Button {
            jumpIsToBeDeleted = true
            dismiss()
        } label: {
            Text("Remove Jump")
                .bold()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .listRowBackground(Color.red)
    }
}

private struct EditJumpSections: View {
    
    @Binding var jump: JumpTimePair
    
    var body: some View {
        Section(content: {
            Stepper(value: $jump.duration, in: 10...120, step: 10) {
                Text("\(jump.duration) seconds")
            }
            .pickerStyle(WheelPickerStyle())
            .id(jump.duration)
        }, header: {
            Text("Jump Duration")
        }, footer: {
            Text("This amount of time can be repeated depending on how many series you perform during a jumping session. ")
        })
        
        Section(content: {
            Picker("Type of Jump", selection: $jump.jumpType) {
                ForEach(JumpType.allCases, id: \.self) { jump in
                    Text(jump.rawValue)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }, header: {
            Text("Type of Jump")
        })
    }
}

struct JumpDetailsSheet_Previews: PreviewProvider {
    static var previews: some View {
        JumpDetailsSheet(createOrEdit: .create { newJump in })
    }
}
