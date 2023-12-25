//
//  Extensions.swift
//  Slot Machine
//
//  Created by Drashti on 22/12/23.
//

import SwiftUI

extension Text {
    func scoreLabelStyle() -> Text{
        self
            .foregroundStyle(.white)
            .font(.system(size: 10, weight: .bold, design: .rounded))
    }
    
    func scoreNumberStyle() -> Text{
        self
            .foregroundStyle(.white)
            .font(.system(.title, design: .rounded))
            .fontWeight(.heavy)
    }
}
