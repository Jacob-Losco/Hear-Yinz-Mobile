/*+===================================================================
File: DBFunctions

Summary: Contains functions and vars for retrieving and formatting data for firestore for front end

Exported Data Structures: aoEventList [EventModel] - a list of all the events to be displayed to the map based on user filtering

Exported Functions: fnInitEventMapData - sets necessary variables to display event information
                    fnGetEventList - sets the users viewable events to be filtered by a selected date

Contributors:
    Jacob Losco - 1/29/2022 - SP-349

===================================================================+*/

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DBFunctions: ObservableObject {
    let oDatabase = Firestore.firestore() //object representing the firestore database
    var sInstitutionId : String = "" //the id of the institution currently logged in
    var sAccountId : String = "" //the id of the account currently logged in
    var aoEventCache : [EventModel] = [] //if on eventmap, all approved events in db occuring after Date.now(), sorted by timestamp
    @Published var aoEventList : ArraySlice<EventModel> = ArraySlice<EventModel>() //if on eventmap, all filtered events to be displayed to the map view
    
    //test function for verifying it works. Will be phased out after approval
    func testGetEventData() {
        print(aoEventCache)
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnInitEventMapData

      Summary: used on init of the map view. Setups up variables necessary to get event data

      Args: None

      Returns: None
    -------------------------------------------------------------------F*/
    func fnInitEventMapData(hCompletionHandler: @escaping () -> Void) {
        fnGetInstitution(hCompletionHandler: {(sInstitution) -> Void in
            self.sInstitutionId = sInstitution
            self.fnGetUserAccount(hCompletionHandler: {(sAccount) -> Void in
                self.sAccountId = sAccount
                self.fnGetInstitutionEvents()
                hCompletionHandler()
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
        let sUserHandle = "@" + sUserEmail.components(separatedBy: "@")[1]
        oDatabase.collection("Institutions").whereField("institution_handle", isEqualTo: sUserHandle).getDocuments { snapshot, error in
            guard let oDocuments = snapshot?.documents else {
                hCompletionHandler("No Documents")
                return
            }
            hCompletionHandler(oDocuments[0].documentID)
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetUserAccount

      Summary: Retrives user Account document id from the database. Returns failure message if retrieval fails

      Args: sInstitutionId - the document id of the user institution
        hCompletionHandler - the handler that holds async return value

      Returns: None technically, but handler contains string containing document Id
    -------------------------------------------------------------------F*/
    private func fnGetUserAccount(hCompletionHandler: @escaping (String) -> Void) {
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
    private func fnGetInstitutionEvents() {
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").getDocuments { snapshot, error in
            guard let oOrganizationDocuments = snapshot?.documents else {
                return
            }
            for oOrganizationDocument in oOrganizationDocuments {
                let oOrganizationData = oOrganizationDocument.data()
                self.fnGetOrganizationEvents(oOrganization: oOrganizationDocument.reference, sOrganizationName: oOrganizationData["organization_name"] as! String, sOrganizationDescription: oOrganizationData["organization_description"] as! String, hCompletionHandler: {(aoOrgEventList) -> Void in
                    self.aoEventCache.append(contentsOf: aoOrgEventList)
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
    private func fnGetOrganizationEvents(oOrganization: DocumentReference, sOrganizationName: String, sOrganizationDescription: String, hCompletionHandler: @escaping ([EventModel]) -> Void) {
        var aoOrganizationEventList: [EventModel] = []
        oOrganization.collection("Events").order(by: "event_timestamp").getDocuments { snapshot, error in
            guard let oOrganizationEventsDocuments = snapshot?.documents else {
                hCompletionHandler(aoOrganizationEventList)
                return
            }
            self.fnGetLocationData(hCompletionHandler: {(aoLocationDictionary) -> Void in
                for oOrganizationEventDocument in oOrganizationEventsDocuments {
                    let oEventData = oOrganizationEventDocument.data()
                    let oLocationData = aoLocationDictionary[oEventData["event_location"] as! DocumentReference]
                    aoOrganizationEventList.append(EventModel(sId: oOrganizationEventDocument.documentID, sName: oEventData["event_name"] as! String, sDescription: oEventData["event_description"] as! String, oLocationCoordinate: oLocationData!["location_coordinate"] as! GeoPoint, sLocationName: oLocationData!["location_name"] as! String, sHostId: oOrganization.documentID, sHostName: sOrganizationName, sHostDescription: sOrganizationDescription, iLikes: oEventData["event_likes"] as! Int, bFollowed: false, oDateEvent: oEventData["event_timestamp"] as! Timestamp))
                }
                hCompletionHandler(aoOrganizationEventList)
            })
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetLocationData

      Summary: returns a dictionary that links a location reference to the data associated with that location

      Args: hCompletionHander - the handler that holds async return value

      Returns: None technically, but event handler contains dictionary
    -------------------------------------------------------------------F*/
    private func fnGetLocationData(hCompletionHandler: @escaping ([DocumentReference : [String : Any]]) -> Void) {
        var aoLocationDictionary: [DocumentReference : [String : Any]] = [DocumentReference : [String : Any]]()
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Locations").getDocuments { snapshot, error in
            guard let oLocationDocuments = snapshot?.documents else {
                hCompletionHandler(aoLocationDictionary)
                return
            }
            for oLocationDocument in oLocationDocuments {
                let oLocationData = oLocationDocument.data()
                aoLocationDictionary[oLocationDocument.reference] = oLocationData
            }
            hCompletionHandler(aoLocationDictionary)
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetEventList

      Summary: Sets the aoEventList variable to contain all the events the user should see given the date slider filter

      Args: endDate

      Returns: None technically, but event handler contains dictionary
    -------------------------------------------------------------------F*/
    func fnGetEventList(oEndTime: Date) {
        aoEventCache.indices.forEach { i in
            print(oEndTime.compare(aoEventCache[i].oDateEvent))
            if(oEndTime.compare(aoEventCache[i].oDateEvent) == .orderedAscending) {
                aoEventList = aoEventCache[0...i]
            }
        }
    }
}
