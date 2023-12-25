//
//  ReelView.swift
//  Slot Machine
//
//  Created by Drashti on 22/12/23.
//

import SwiftUI

struct ReelView: View {
    var body: some View {
        Image("gfx-reel")
            .resizable()
            .modifier(ImageModifier())
    }
}

#Preview {
    ReelView()
}
