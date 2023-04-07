/*+===================================================================
File: ContentView.swift

Summary: landing view after login is completed. includes TabView to facilitate switching of views.

Exported Data Structures: ContentView - the view itself.

Exported Functions: None

Contributors:
    Sarah Kudrick - 2/2/23 - SP-220
    Jacob Losco - 2/4/2023 - SP-220

===================================================================+*/

import SwiftUI

struct ContentView: View {
    @ObservedObject var oLoginFunctions = LoginFunctions() //contains login functions
    @Environment(\.scenePhase) var scenePhase
    @State var iCurrentTab: Int = 1
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
//            .onChange(of: scenePhase) { newPhase in
//                            if newPhase == .background {
//                                //destroy authentication token
//                                oLoginFunctions.fnLogout()
//                                //NSApplication.shared.terminate(self)
//                            }
//                        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
