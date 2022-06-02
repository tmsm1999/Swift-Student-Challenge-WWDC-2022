//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct FavoriteAndThemeSection: View {
    
    @Binding var isFavorite: Bool
    @Binding var workoutTheme: Color
    
    @Environment(\.editMode) var editMode
    
    @State private var showColorPicker = false
    
    var body: some View {
        Section {
            Toggle(isOn: $isFavorite, label: {
                HStack {
                    if isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.yellow)
                    }
                    else {
                        Image(systemName: "star")
                            .foregroundColor(Color.yellow)
                    }
                    
                    Text("Favorite")
                }
            })
            
            HStack {
                Image(systemName: "paintpalette")
                Text("Workout Theme")
                
                Spacer()
                
                Circle()
                    .foregroundColor(workoutTheme)
                    .frame(width: 23, height: 23)
            }
            .onTapGesture {
                showColorPicker = true
            }
            .sheet(isPresented: $showColorPicker) {
                CustomColorPicker(
                    currentColor: $workoutTheme
                )
            }
        }
    }
}

struct FavoriteAndThemeSection_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteAndThemeSection(isFavorite: .constant(false), workoutTheme: .constant(Color.red))
    }
}
