//
//  AnnouncementsView.swift
//  Hear-Yinz
//
//  Created by Sarah Kudrick on 2/4/23.
//

import SwiftUI

struct AnnouncementsView: View {
    var body: some View {
        VStack{
            Text("Announcements Page")
            Spacer()
            Rectangle() //Adds custom color background to tab bar.
                .fill(Color.clear)
                .frame(height: 10)
                .background(Color("highlight"))
        }
    }
}

struct AnnouncementsView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsView()
    }
}
