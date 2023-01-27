/*+===================================================================
File: DBFunctions

Summary: Contains functions and vars for retrieving and formatting data for firestore for front end

Exported Data Structures: aoEventList [EventModel] - a list of all the events to be displayed to the map based on user filtering

Exported Functions: fnInitEventMapData - sets necessary variables to display event information

Contributors:
    Jacob Losco - 1/27/2022 - SP-349

===================================================================+*/

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DBFunctions: ObservableObject {
    
    let oDatabase = Firestore.firestore()
    var sInstitutionId : String = "" //the id of the institution currently logged in
    var sAccountId : String = "" //the id of the account currently logged in
    var aoEventCache : [EventModel] = [] //if on eventmap, all approved events in db occuring after Date.now(), sorted by timestamp
    @Published var aoEventList : [EventModel] = [] //if on eventmap, all filtered events to be displayed to the map view
    
    func testGetEventData() {
        print(aoEventCache)
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnInitEventMapData

      Summary: used on init of the map view. Setups up variables necessary to get event data

      Args: None

      Returns: None
    -------------------------------------------------------------------F*/
    func fnInitEventMapData() {
        fnGetInstitution(hCompletionHandler: {(institution) -> Void in
            self.sInstitutionId = institution
            self.fnGetUserAccount(sInstitutionId: institution, hCompletionHandler: {(account) -> Void in
                self.sAccountId = account
                self.fnGetInstitutionEvents(sInstitutionId: institution, sAccountId: account)
            })
        })
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetInstitution

      Summary: Retrives user Institution document id from the database. Returns failure message if retrieval fails

      Args: hCompletionHandler - the handler that holds async return value

      Returns: None technically, but handler contains string return
    -------------------------------------------------------------------F*/
    private func fnGetInstitution(hCompletionHandler: @escaping (String) -> Void) {
        let sUserEmail = Auth.auth().currentUser?.email ?? "N/A"
        if(sUserEmail != "N/A") {
            let sUserHandle = "@" + sUserEmail.components(separatedBy: "@")[1]
            oDatabase.collection("Institutions").whereField("institution_handle", isEqualTo: sUserHandle).getDocuments { snapshot, error in
                guard let oDocuments = snapshot?.documents else {
                    hCompletionHandler("No Documents")
                    return
                }
                hCompletionHandler(oDocuments[0].documentID)
            }
        } else {
            hCompletionHandler("No Email")
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetUserAccount

      Summary: Retrives user Account document id from the database. Returns failure message if retrieval fails

      Args: sInstitutionId - the document id of the user institution
        hCompletionHandler - the handler that holds async return value

      Returns: None technically, but handler contains string containing document Id
    -------------------------------------------------------------------F*/
    private func fnGetUserAccount(sInstitutionId: String, hCompletionHandler: @escaping (String) -> Void) {
        let sUserEmail = Auth.auth().currentUser?.email ?? "N/A"
        if(sUserEmail != "N/A") {
            oDatabase.collection("Institutions").document(sInstitutionId).collection("Accounts").whereField("account_email", isEqualTo: sUserEmail).getDocuments { snapshot, error in
                guard let oDocuments = snapshot?.documents else {
                    hCompletionHandler("No Documents")
                    return
                }
                hCompletionHandler(oDocuments[0].documentID)
            }
        }
    }

    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetInstitutionEvents

      Summary: Retrives list of events sorted by timestamp occuring from the database

      Args: sInstitutionId - the document id of the user institution
        sAccountId - the document id of the user account
        hCompletionHandler - the handler that holds async return value

      Returns: None technically, but handler contains string containing document Id
    -------------------------------------------------------------------F*/
    private func fnGetInstitutionEvents(sInstitutionId: String, sAccountId: String) {
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").getDocuments { snapshot, error in
            guard let oOrganizationDocuments = snapshot?.documents else {
                return
            }
            for oOrganizationDocument in oOrganizationDocuments {
                self.fnGetOrganizationEvents(sInstituionId: sInstitutionId, sAccountId: sAccountId, sOrganizationId: oOrganizationDocument.documentID, hCompletionHandler: {(orgEventList) -> Void in
                    self.aoEventCache.append(contentsOf: orgEventList)
                })
            }
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetOrganizationevents

      Summary: Retrives list of all events after Date.now() for specific organization

      Args: sInstitutionId - the document id of the user institution
        sAccountId - the document id of the user account
        sOrganizationId - the document id of the organization
        hCompletionHandler - the handler that holds async return value

      Returns: None technically, but handler contains event list
    -------------------------------------------------------------------F*/
    private func fnGetOrganizationEvents(sInstituionId: String, sAccountId: String, sOrganizationId: String, hCompletionHandler: @escaping ([EventModel]) -> Void) {
        var aoOrganizationEventList: [EventModel] = []
        oDatabase.collection("Institutions").document(sInstituionId).collection("Organizations").document(sOrganizationId).collection("Events").order(by: "event_timestamp").getDocuments { snapshot, error in
            guard let oOrganizationEventsDocuments = snapshot?.documents else {
                hCompletionHandler(aoOrganizationEventList)
                return
            }
            for oOrganzationEventDocument in oOrganizationEventsDocuments {
                let eventData = oOrganzationEventDocument.data()
                let tempFollowed = false
                aoOrganizationEventList.append(EventModel(id: oOrganzationEventDocument.documentID, name: eventData["event_name"] as! String, description: eventData["event_description"] as! String, location: eventData["event_location"] as! String, likes: eventData["event_likes"] as! Int, reports: eventData["event_reports"] as! Int, status: eventData["event_status"] as! Int, followed: tempFollowed, dateEvent: eventData["event_timestamp"] as! Timestamp))
            }
            hCompletionHandler(aoOrganizationEventList)
        }
    }
}
