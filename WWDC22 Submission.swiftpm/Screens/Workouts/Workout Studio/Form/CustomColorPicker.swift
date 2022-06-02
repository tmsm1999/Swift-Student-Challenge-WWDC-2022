//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct CustomColorPicker: View {
    
    @State private var colors = [
        Color.init(red: 224 / 255, green: 101 / 255, blue: 101 / 255),
        Color.init(red: 239 / 255, green: 133 / 255, blue: 104 / 255),
        Color.init(red: 235 / 255, green: 166 / 255, blue: 91 / 255),
        Color.init(red: 229 / 255, green: 195 / 255, blue: 66 / 255),
        Color.init(red: 103 / 255, green: 195 / 255, blue: 100 / 255),
        Color.init(red: 93 / 255, green: 201 / 255, blue: 170 / 255),
        Color.init(red: 90 / 255, green: 196 / 255, blue: 217 / 255),
        Color.init(red: 79 / 255, green: 173 / 255, blue: 240 / 255),
        Color.init(red: 72 / 255, green: 96 / 255, blue: 189 / 255),
        Color.init(red: 123 / 255, green: 81 / 255, blue: 185 / 255),
        Color.init(red: 173 / 255, green: 119 / 255, blue: 220 / 255),
        Color.init(red: 230 / 255, green: 139 / 255, blue: 207 / 255),
        Color.init(red: 131 / 255, green: 140 / 255, blue: 149 / 255),
        Color.init(red: 145 / 255, green: 155 / 255, blue: 145 / 255),
        Color.init(red: 150 / 255, green: 139 / 255, blue: 135 / 255)
    ]
    
    @Binding var currentColor: Color
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .frame(width: screenWidth / 4.4, height: screenWidth / 4.4)
                            .overlay(
                                Circle()
                                    .stroke(currentColor.description == color.description ? Color.accentColor : color, lineWidth: 5)
                            )
                            .foregroundColor(color)
                            .padding()
                            .onTapGesture {
                                currentColor = color
                            }
                            .onAppear {
                                print(color)
                            }
                    }
                }
                .padding()
            }
            .navigationBarTitle(Text("Edit Workout Theme"))
            .navigationBarItems(trailing: Button("Save") {
                dismiss()
            })
            .onAppear {
                print(currentColor)
            }
        }
    }
    
    private let screenWidth = UIScreen.main.bounds.width
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPicker(currentColor: .constant(Color.red))
    }
}
