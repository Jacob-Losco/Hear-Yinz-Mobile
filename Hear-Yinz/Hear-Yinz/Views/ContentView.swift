/*+===================================================================
File: contentview.swift

Summary: landing view after login is completed. includes TabView to facilitate switching of views.

Exported Data Structures: ContentView- the view struct
 MapView, SettingsView, AnnouncementsView- accessed through tabview

Exported Functions: None

Contributors:
    Name - Date Last Edited - Task Number Worked on
    Sarah Kudrick - 2/2/23 - SP-220
    ...

===================================================================+*/

import SwiftUI

struct ContentView: View {
    @State var iCurrentTab: Int = 1
    //sets default view to the map screen so the map will open upon login
    var body: some View {
        /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          Function: TabView (built in SwiftUI feature)

          Summary: TabView creates a navigation bar that overlays all views and allows user to switch between views by clicking a button.

          Args: Views with a .tabItem modifier
                 Each view will be displayed fully and by itself when its corresponding button on the tab bar is tapped.
                .tag(int) modifiers
                Each tab can be referenced or selected with its tag, an int.
                $iCurrentTab
                Allows a tab to be selected and displayed when iCurrentTab is set to that tab's tag.
                 Description.

          Returns: View
                    formats a tab bar above all tabs in the view.

          Tests: testNavToAnnouncements, testNavToSettings, testNavToMap
        -------------------------------------------------------------------F*/

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
