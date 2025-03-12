//
//  ModifiedButtonView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 3/7/25.
//

import SwiftUI

struct ModifiedButtonView: View {
    let text : String
    var isEnabled : Bool
    var body: some View {
        HStack{
            Spacer()
            Text(text)
            Spacer()
        }
        .padding(.vertical)
        .background(isEnabled ? .blue : .gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
    }
}

#Preview {
    ModifiedButtonView(text: "저장하기",isEnabled: false)
}
