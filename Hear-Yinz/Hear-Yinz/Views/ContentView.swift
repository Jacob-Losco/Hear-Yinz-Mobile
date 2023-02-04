/*+===================================================================
File: contentview.swift

Summary: landing view after login is completed. includes TabView to facilitate switching of views.

Exported Data Structures: ContentView- the view struct
 MapView, SettingsView, AnnouncementsView- accessed through tabview

Exported Functions: None

Contributors:
    Sarah Kudrick - 2/2/23 - SP-220
    Jacob Losco - 2/4/2022 - SP-220

===================================================================+*/

import SwiftUI

struct ContentView: View {
    @State var iCurrentTab: Int = 1
    //sets default view to the map screen so the map will open upon login
    var body: some View {
            TabView(selection: $iCurrentTab){
                AnnouncementsView()
                    .tabItem {
                        Image(systemName: "megaphone.fill")
                    }
                    .tag(0)
                MapView()
                    .tabItem {
                        Image(systemName: "mappin.circle.fill")
                    }
                    .tag(1)
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                    }
                    .tag(2)
            }
            .accentColor(Color("iconColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
