//
//  InfoView.swift
//  Slot Machine
//
//  Created by Drashti on 22/12/23.
//

import SwiftUI

struct InfoView: View {
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            LogoView()
            
            Spacer()
            
            Form{
                Section {
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "PlatForms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Pratik")
                    FormRowView(firstItem: "Music", secondItem: "Pandya")
                    FormRowView(firstItem: "Designer", secondItem: "Pratik Pandya")
                    FormRowView(firstItem: "Website", secondItem: "google.co.in")
                    FormRowView(firstItem: "Copyright", secondItem: "© 2023 All rights reserved.")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                } header: {
                    Text("About the application")
                }

            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top, 40)
        .overlay(alignment: .topTrailing, content: {
            Button(action: {
                audioPlayer?.stop()
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            })
            .padding(.top, 30)
            .padding(.trailing, 20)
            .tint(.secondary)
        })
        .onAppear(perform: {
            playSound(sound: "background-music", type: "mp3")
        })
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    var body: some View {
        HStack{
            Text(firstItem).foregroundStyle(.gray)
            Spacer()
            Text(secondItem)
        }
    }
}

#Preview {
    InfoView()
}


