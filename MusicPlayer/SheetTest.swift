//
//  SheetTest.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 4/30/24.
//

import SwiftUI

struct SheetTest: View {
    @State private var isDragging = false
    @State private var offset = CGFloat.zero
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AView() // 메인 뷰
            
            BView() // 하단에 부분적으로 보이는 뷰
                .frame(height: isDragging ? UIScreen.main.bounds.height : 200) // 드래그 상태에 따라 높이 변경
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
             //   .offset(y: isDragging ? 0 : UIScreen.main.bounds.height - 100)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let verticalMovement = gesture.translation.height
                            self.offset = verticalMovement
                            if verticalMovement < 0 { // 위로 드래그하는 경우
                                isDragging = true
                            }
                        }
                        .onEnded { _ in
                            if self.offset > 50 { // 다시 내려가는 드래그가 일정 이상일 경우
                                isDragging = false // 뷰를 다시 하단으로 숨김
                            }
                            self.offset = 0
                        }
                )
                .animation(.spring(), value: isDragging) // 드래그 상태 변경에 따른 애니메이션 적용
        }
     //   .edgesIgnoringSafeArea(.all)
    }
}

struct AView: View {
    var body: some View {
        Color.blue
    }
}

struct BView: View {
    var body: some View {
        VStack {
            Color.green
        }
    }
}

#Preview {
    SheetTest()
}
