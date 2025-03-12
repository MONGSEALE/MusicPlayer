//
//  Test.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/9/25.
//
import SwiftUI


struct ContentView: View {
    //MARK: - Properties
  
    
    //MARK: - Body
    var body: some View {
        VStack{
            Spacer()
            MarqueeText(
                text: "달속에 그대가 있나요 그대안엔 달이 있는데에에에에에에",
                font: UIFont.preferredFont(forTextStyle: .title2),
                leftFade: 16,
                rightFade: 16,
                startDelay: 3,
                fontWeight: .semibold,
                foregroundStyle: .black
            )
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


