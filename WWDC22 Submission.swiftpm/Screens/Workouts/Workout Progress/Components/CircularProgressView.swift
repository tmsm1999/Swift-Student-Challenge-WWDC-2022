//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct CircularProgressView: View {
    
    var jumpDuration: CGFloat
    var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.35)
                .foregroundColor(Color.black)
            
            Circle()
                .trim(from: 0,
                      to: min(progress / jumpDuration, 1)
                )
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: CGLineCap.square, lineJoin: CGLineJoin.round))
                .foregroundColor(.black)
                .rotationEffect(Angle(degrees: 270))
                .animation(Animation.linear, value: progress)
            
            Image(systemName: "pause.fill")
                .font(.title3)
                .foregroundColor(.black)
        }
        //.frame(width: 40, height: 40)
    }
}

struct CircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(
            jumpDuration: 5.0,
            progress: 2.0
        )
    }
}
