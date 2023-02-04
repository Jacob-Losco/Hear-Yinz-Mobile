//
//  SettingsView.swift
//  Hear-Yinz
//
//  empty file added to support setup of tab view.
//  Add header upon beginning work on this file.
//
//  Created by Sarah Kudrick on 2/3/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack{
            Text("Settings Page")
            Spacer()
            Rectangle() //Adds custom color background to tab bar.
                .fill(Color.clear)
                .frame(height: 10)
                .background(Color("highlight"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
