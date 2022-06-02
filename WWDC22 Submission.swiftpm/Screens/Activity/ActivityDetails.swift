//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI
import MapKit
import simd

struct ActivityDetails: View {
    
    let jumpSession: JumpSession
    @State private var showDeleteAlert = false
    @State private var activityIsToBeDeleted = false
    
    let removeActivity: (UUID) -> Void
    var enableDoneButton: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(jumpSession.startDate)
                                .opacity(0.7)
                            .padding(.bottom, 5)
                            .offset(x: 0, y: enableDoneButton ? 20 : 0)
                            
                            Spacer()
                            
                            if enableDoneButton {
                                Button("Done") {
                                    dismiss()
                                }
                                .font(.system(size: 18))
                            }
                        }
                        
                        Text(jumpSession.workout.name)
                            .font(.system(size: 45, weight: .heavy))
                            .italic()
                        Text("Workout")
                            .opacity(0.70)
                    }
                    
                    Spacer()
                }
                .padding()
                
                Divider()
                    .padding([.leading, .trailing])
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(jumpSession.duration)
                            .font(.system(size: 40, weight: .heavy))
                        Text("Duration")
                            .opacity(0.70)
                    }
                    
                    Spacer()
                }
                .padding()
                
                Divider()
                    .padding([.leading, .trailing])
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(jumpSession.caloriesBurned != nil ? String("\(jumpSession.caloriesBurned!)") : "-")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        Text("Calories")
                            .opacity(0.7)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text(jumpSession.averageHeartRate != nil ? String("\(jumpSession.averageHeartRate!)") : "-")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        Text("Avg. HR")
                            .opacity(0.7)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text(jumpSession.highestHeartRate != nil ? String("\(jumpSession.highestHeartRate!)") : "-")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        Text("Highest HR")
                            .opacity(0.7)
                    }
                }
                .padding()
                
                Divider()
                    .padding([.leading, .trailing])
                
                Map(
                    coordinateRegion: .constant(
                        MKCoordinateRegion(
                            center: jumpSession.location != nil ?
                                CLLocationCoordinate2D(
                                    latitude: jumpSession.location!.latitude,
                                    longitude: jumpSession.location!.longitude
                                ) : CLLocationCoordinate2D(latitude: 37.334900, longitude: -122.009020),
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.005,
                                longitudeDelta: 0.005
                            )
                        )
                    ),
                    annotationItems: [jumpSession]
                ) { jumpSession in
                    MapMarker(
                        coordinate: jumpSession.location != nil ? CLLocationCoordinate2D(
                            latitude: jumpSession.location!.latitude,
                            longitude: jumpSession.location!.longitude
                        ) : CLLocationCoordinate2D(),
                        tint: Color.accentColor)
                }
                    .frame(height: screenHight / 4)
                    .padding()
                
                Button(action: {
                    showDeleteAlert.toggle()
                }, label: {
                    Text("Delete Activity")
                        .foregroundColor(Color.white)
                        .bold()
                })
                    .frame(maxWidth: .infinity, idealHeight: 45)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("Are you sure you want to delete this Workout?"),
                            message: Text("You will no longer be able do this workout or edit it. It may also have an impact on the information available in your activity."),
                            primaryButton:
                                    .destructive(
                                        Text("Delete"),
                                        action: {
                                            activityIsToBeDeleted = true
                                            dismiss()
                                        }
                                    ),
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                
                Divider()
                    .padding([.leading, .trailing])
                
                HStack {
                    Text("Note: Some metrics depend on the Apple Watch and location data.")
                        .font(.callout)
                        .opacity(0.5)
                }
                .padding()
            }
            .padding([.bottom, .top], enableDoneButton ? 21 : 0)
        }
        //.frame(width: screenWidth, height: screenHight)
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if activityIsToBeDeleted {
                removeActivity(jumpSession.id)
            }
        }
    }
    
    private let screenHight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
}

struct ActivityDetails_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetails(jumpSession: UserData.jumpSessionsData[1], removeActivity: {_ in }, enableDoneButton: true)
    }
}

