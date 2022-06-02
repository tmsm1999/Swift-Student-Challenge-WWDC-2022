//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI
import MessageUI
import StoreKit

struct Settings: View {
    
    @Binding var personalData: PersonalData
    @Binding var activity: [JumpSession]
    
    let saveAction: () -> Void
    
    @State private var height = 181
    @State private var showHeightPicker = false
    @State private var age = 23
    @State private var name = "Tomás"
    @State private var audioFeedback = true
    @State private var showEmailSheet: Bool = false
    @State private var showDeleteActivityAlert: Bool = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    
                    TextField("Your Name", text: $personalData.name)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color.accentColor)
                        Text("Height")
                            .foregroundColor(Color.accentColor)
                            .bold()
                        Spacer()
                        Text("\(height) cm")
                    }
                    .onTapGesture {
                        withAnimation {
                            showHeightPicker.toggle()
                        }
                    }
                    
                    if showHeightPicker {
                        Picker("Height", selection: $height) {
                            ForEach(120 ..< 221, id: \.self) {
                                Text("\($0) cm")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    
                    HStack {
                        Text("Rope Length")
                        Spacer()
                        Text("\(calculateRopeLength(height: $height)) cm")
                    }
                    
                }, header: {
                    Text("About you")
                }, footer: {
                    Text("The recomended lenght of the jump rope to use in your workouts depends on your height.")
                })
                
                Section(content: {
                    
                    Button(action: {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }) {
                        HStack {
                            Image(systemName: "location.fill")
                            Text("Location Settings").bold()
                            
                        }
                    }
                    
                    Toggle(isOn: $audioFeedback) {
                        Group {
                            Image(systemName: "speaker.wave.2.fill")
                            Text("Audio Feedback")
                        }
                    }
                    
                    HStack {
                        Text("Apple Watch status")
                        Spacer()
                        Text("Connected")
                            .foregroundColor(Color.gray)
                    }
                    
                    Button(action: {
                       showDeleteActivityAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Delete Activity data").bold()
                        }
                        .foregroundColor(Color.red)
                    }
                    
                }, header: {
                    Text("Workout Settings")
                }, footer: {
                    Text("Workout features, such as, heart rate and calories burned depend on the Apple Watch for availability.")
                })
                
                Section(content: {
                    
                    Button(action: {
//                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                            SKStoreReviewController.requestReview(in: scene)
//                        }
                    }) {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Rate & Review").bold()
                            
                        }
                    }
                    
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            showEmailSheet.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("Contact Developer").bold()
                        }
                    }
                    
                }, header: {
                    Text("About the App")
                })
            }
            .navigationTitle(Text("Settings"))
//            .sheet(isPresented: $showEmailSheet) {
//                EmailComposeView()
//            }
            .alert(isPresented: $showDeleteActivityAlert) {
                Alert(title: Text("Are you sure you want to delete all activity data?"), message: Text("This action can not be undone. You will lose all recorded data during your workouts."), primaryButton: .cancel(), secondaryButton: .destructive(Text("Yes"), action: { activity.removeAll(); saveAction() } ))
            }
            .onChange(of: scenePhase) { phase in
                saveAction()
            }
        }
    }
    
    private func calculateRopeLength(height: Binding<Int>) -> Int {
        if height.wrappedValue >= 120 && height.wrappedValue <= 145 { return 213 }
        else if height.wrappedValue >= 146 && height.wrappedValue <= 161 { return 244 }
        else if height.wrappedValue >= 162 && height.wrappedValue <= 180 { return 275 }
        else if height.wrappedValue >= 181 && height.wrappedValue <= 193 { return 305 }
        return 335
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(
            personalData: .constant(PersonalData(name: "", height: 165)),
            activity: .constant([]),
            saveAction: {}
        )
    }
}
