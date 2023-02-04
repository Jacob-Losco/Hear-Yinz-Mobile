/*+===================================================================
File: AnnouncementsView

Summary: View for announcements screen

Exported Data Structures: None

Exported Functions: None

Contributors:
    Jacob Losco - 2/4/2022 - SP-220

===================================================================+*/

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
