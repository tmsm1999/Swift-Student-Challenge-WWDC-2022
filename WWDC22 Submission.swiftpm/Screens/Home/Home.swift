//
//  File.swift
//  WWDC22 Submission
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation

import SwiftUI

struct Article: Hashable {
    var title: String
    var text: String
    var imageTitle: String
}

struct Home: View {
    
    @Binding var name: String
    var articles: [Article] = [
        Article(title: "Jump for your life!", text: "Today, there are many people that remain unaware of the benefits of jumping rope. Apart from being on of the few sports that helps conquer most fitness goals - fat loss, endurance, strength and performance - it also improves cardiovascular health, coordination and has the power of improving overall well-being. Furthermore, it is fun and can be done as a social activity.\n\nResearch has shown that that jumping rope can help burn more than 1000 calories in an hour. Also, ten minutes of jumping rope has shown itself to be roughly the same as running an eight-minute mile. Also, jumping rope can be quite meditative, as to keep up for long periods of unbroken skips we must keep our mind in the present moment.\n\nNo doubt, jump rope must be one of the best kept secrets in fitness.", imageTitle: "jump_rope"),
        Article(title: "Exercise and Hapiness", text: "Studies has shown that people that are more physically active tend to be happier. This translates in better life satisfaction and higher self-esteem. It also reduces depression, anxiety, improves sleep quality and strengthens the immune system. It is said that exercise must be one of the most reliable happiness booster of all activities.\n\nBy exercising we feel better in control of our bodies which helps us feel calmer and in control of our circumstances.  It also distracts us form negative thoughts, reliving us from worrying and overthinking. And with regular exercise we witness the growth of our strength and stamina, which boosts our goal-achievement confidence that then goes over other areas of our lives.", imageTitle: "exercise"),
        Article(title: "How to avoid injury?", text: "Like in any sport, one of the key things to do to avoid injuries while jumping rope is to listen to the body and search for any kind of pain that seems to be abnormal. This is that kind of pain that makes it hard to move and perform any kind of day-to-day activity and does not go away.\n\nThat being said, one of the best ways to avoid injuries is ti start slow and build up so that the muscle can adjust to jumping. It is also recommended to try to jump on some kind of forgiving surface or use a mat and good shoes.\n\nBut most of all - listen to your body!", imageTitle: "injury")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: true) {
                ForEach(articles, id: \.self) { article in
                    ArticleCard(
                        articleTitle: article.title,
                        articleText: article.text,
                        imageTitle: article.imageTitle
                    )
                    .padding(.top, 10)
                    
                    Divider()
                        .padding([.top, .trailing, .leading], 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0))
            .navigationTitle(Text("Hello, \(name)!"))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(name: .constant("Tomás"))
    }
}

