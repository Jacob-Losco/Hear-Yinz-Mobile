/*+===================================================================
File: FirebaseDisplayView

Summary: A Mobile view containing buttons that test the various queries to and from firestore

Exported Data Structures: FirebaseDisplayView - View containing buttons and calls to various data connections

Exported Functions: None

Contributors:
    Jacob Losco - 1/22/2022 - SP-316

===================================================================+*/

import SwiftUI

struct FirebaseDisplayView: View {
    
    @ObservedObject var oConnectionTestModel = FirebaseConnectTestViewModel()
    
    var body: some View {
        Button("Test Connection", action: {
            print(oConnectionTestModel.asm_List[0])
        })
    }
    
    init() {
        oConnectionTestModel.fnGetData()
    }
}

