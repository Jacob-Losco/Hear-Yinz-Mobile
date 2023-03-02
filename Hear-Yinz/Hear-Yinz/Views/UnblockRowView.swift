/*+===================================================================
File: UnblockRowView


Summary: View for listing blocked organizations in settings screen


Exported Data Structures: UnblockRowView - the view itself


Exported Functions: None


Contributors:
    Sarah Kudrick - 3/2/23 - SP-256
    Jacob Losco - 2/4/2023 - SP-220


===================================================================+*/


import SwiftUI


struct UnblockRowView: View {
    @ObservedObject var oDBFunctions = DBFunctions() //contains login functions
    var oOrganization: OrganizationModel
    @State private var cTapped = Color("button")
    @State private var bTapped = false
    var body: some View {
        HStack{
            Text(oOrganization.sm_Id)
                .font(.custom("DMSans-Regular", size: 18))
                .multilineTextAlignment(.center)
                .padding()
            Button{
                //cTapped=Color.gray
                oDBFunctions.fnDeleteRelationshipOrganization(sOrganizationId: oOrganization.sm_Id, iRelationshipType: 2, hCompletionHandler: {(success)->Void in
                    if success {
                        cTapped=Color.gray
                        bTapped=false
                        //self.hidden()
                    } else {
                        print("Error at fnDeleteRelationshipOrganization in UnblockRowView")
                    }
                    })//{(result) in}
                //await oDBFunctions.fnDeleteRelationshipOrganization(sOrganizationId: oOrganization.sm_Id, iRelationshipType: 2){(result) in}
                //how do i do the bool -> void part
                //adding {(result) in} is a solution stolen from the internet
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(cTapped)
                        .frame(height: 40)
                        .padding(.trailing)
                    Text("Unblock")
                        .font(.custom("DMSans-Regular", size: 18))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .frame(height: 40, alignment: .center)
                        
                }
            }.disabled(bTapped)
        }.task{
            await oDBFunctions.fnInitSessionData()
            //await oDBFunctions.fnGetBlockedOrganizations()
            //aoBlockedList = oDBFunctions.aoOrganizationList
            }
    }
    init(oOrganization: OrganizationModel, id: String, name: String) {
        self.oOrganization = OrganizationModel(sId: id, sName: name)
    }


}


struct UnblockRowView_Previews: PreviewProvider {
    static var previews: some View {
        UnblockRowView(oOrganization: OrganizationModel(sId: "test", sName: "test"), id: "test", name: "test")
    }
}
