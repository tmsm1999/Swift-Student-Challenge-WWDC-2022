//
//  File.swift
//  WWDC22 Submission
//
//  Created by Tomás Mamede on 19/04/2022.
//

import SwiftUI

struct ArticleCard: View {
    
    var articleTitle: String
    var articleText: String
    var imageTitle: String
    
    var textSplit: [String] {
        let paragraphs = articleText.components(separatedBy: "\n\n")
        let splitLength = paragraphs.count / 2
        let firstPart = paragraphs[0 ..< splitLength].joined(separator: "\n\n")
        let secondPart = paragraphs[splitLength ..< paragraphs.count].joined(separator: "\n\n")
        
        return [firstPart, secondPart]
    }
    
    @State private var showArticle = false
    
    var body: some View {
        ZStack {
            Image(imageTitle)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Text(articleTitle)
                        .foregroundColor(.white)
                        .bold()
                        .font(.title3)
                    
                    Spacer()

                    Button(action: {
                        showArticle.toggle()
                    }, label: {
                        VStack {
                            Text("READ")
                                .foregroundColor(.black)
                                .bold()
                        }
                        .frame(width: 90, height: 30)
                        .background(.white)
                        .cornerRadius(50)
                    })
                }
                
                .padding([.leading, .trailing], 20)
                .padding([.top, .bottom], 15)
                .frame(width: screenWidth * 0.92, alignment: .center)
                //.padding([.leading, .trailing], 30)
                .background(.black)
            }
        }
        .frame(width: screenWidth * 0.92, height: screenHeight * 0.30, alignment: .center)
        .cornerRadius(20)
        .fullScreenCover(isPresented: $showArticle) {
            ArticleView(title: articleTitle,
                        textPartOne: textSplit[0],
                        textPartTwo: textSplit[1],
                        image: imageTitle
            )
        }
    }
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
}

struct ArticleCard_Previews: PreviewProvider {
    static var previews: some View {
        ArticleCard(
            articleTitle: "The importance of Jumping Rope",
            articleText: "",
            imageTitle: "jump_rope"
        )
    }
}

