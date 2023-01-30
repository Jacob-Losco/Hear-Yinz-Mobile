/*+===================================================================
File: FirebaseDisplayView

Summary: A Mobile view containing buttons that test the various queries to and from firestore

Exported Data Structures: FirebaseDisplayView - View containing buttons and calls to various data connections

Exported Functions: None

Contributors:
    Jacob Losco - 1/26/2022 - SP-365

===================================================================+*/

import SwiftUI
import FirebaseAuth

struct FirebaseDisplayView: View {
    @ObservedObject var oLoginFunctions = LoginFunctions()
    @ObservedObject var oDBFunctions = DBFunctions()
    
    var body: some View {
        VStack (spacing: 50){
            Button("Login") {
                oLoginFunctions.fnLogin(sEmail: "test@stvincent.edu", sPassword: "test123"
                )}
            Button ("Logout") {
                oLoginFunctions.logout()
            }
            Button("Get Events") {
                print(oDBFunctions.testGetEventData())
            }
            Button("Like Chess Meeting Event") {
                print(oDBFunctions.testUpdateEventLikes())
            }
            Button("Report Chess Meeting Event") {
                print(oDBFunctions.testUpdateEventReports())
            }
        }
    }
    
    init() {
        oDBFunctions.fnInitEventMapData(hCompletionHandler: {() -> Void in
            
        })
    }
}

struct FirebaseDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseDisplayView()
    }
}
