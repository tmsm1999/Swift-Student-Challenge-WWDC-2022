//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI
import AVKit

struct JumpText: View {
    
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Text("Jump!")
                .font(.system(size: screenHeight * 0.13, weight: .bold, design: .default))
            .italic()
        }
        .frame(width: screenWidth, height: screenHeight * 0.20, alignment: .center)
    }
}

struct JumpVideoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        JumpText()
    }
}
