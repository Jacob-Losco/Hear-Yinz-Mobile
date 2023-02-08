/*+===================================================================
File: DBFunctions.swift

Summary: Contains functions and vars for retrieving and formatting data for firestore for front end

Exported Data Structures: aoEventCache [EventModel] - a list of all the events to be displayed to the map
                        aoAnnouncementList [AnnouncementModel] - a list of all announcements to be displayed to the map

Exported Functions: fnInitSessionData - sets necessary variables to display use other database functions
                    fnGetInstitutionEvents - updates aoEventCache with all event data
                    fnGetInstitutionAnnouncements - updates aoAnnouncementList with all announcement data
                    fnUpdateEventLikes - increases an events likes by 1 in database
                    fnUpdateEventReports - increase an events reports by 1 in database

Contributors:
    Jacob Losco - 1/29/2023 - SP-349

===================================================================+*/

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DBFunctions: ObservableObject {
    let oDatabase = Firestore.firestore() //object representing the firestore database
    var sInstitutionId : String = "" //the id of the institution currently logged in
    var sAccountId : String = "" //the id of the account currently logged in
    @Published var aoEventCache : [EventModel] = [] //if on eventmap, all approved events in db occuring after Date.now(), sorted by timestamp
    @Published var aoAnnouncementList: [AnnouncementModel] = []
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnInitSessionData

      Summary: used on init of the map view. Setups up variables necessary to get event data

      Args: hCompletionHandler - completion handler that runs after asynchronous functions are completed

      Returns: None
    -------------------------------------------------------------------F*/
    func fnInitSessionData(hCompletionHandler: @escaping () -> Void) {
        fnGetInstitution(sUserEmail: Auth.auth().currentUser?.email ?? "N/A", hCompletionHandler: {(sInstitution) -> Void in
            self.sInstitutionId = sInstitution
            self.fnGetUserAccount(sUserEmail: Auth.auth().currentUser?.email ?? "N/A", hCompletionHandler: {(sAccount) -> Void in
                self.sAccountId = sAccount
                hCompletionHandler()
            })
        })
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetInstitution

      Summary: Retrieves user Institution document id from the database. Returns failure message if retrieval fails

      Args: hCompletionHandler - completion handler that runs after asynchronous functions are completed

      Returns: None technically, but handler contains string return
    -------------------------------------------------------------------F*/
    private func fnGetInstitution(sUserEmail: String, hCompletionHandler: @escaping (String) -> Void) {
        if(sUserEmail != "N/A"){
            let sUserHandle = "@" + sUserEmail.components(separatedBy: "@")[1]
            oDatabase.collection("Institutions").whereField("institution_handle", isEqualTo: sUserHandle).getDocuments { snapshot, error in
                guard let oDocuments = snapshot?.documents else {
                    hCompletionHandler("No Documents")
                    return
                }
                hCompletionHandler(oDocuments[0].documentID)
            }
        } else {
            hCompletionHandler("Error: No logged in user")
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetUserAccount

      Summary: Retrives user Account document id from the database. Returns failure message if retrieval fails

      Args: sInstitutionId - the document id of the user institution
        hCompletionHandler - the handler that holds async return value

      Returns: None technically, but handler contains string containing document Id
    -------------------------------------------------------------------F*/
    private func fnGetUserAccount(sUserEmail: String, hCompletionHandler: @escaping (String) -> Void) {
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

      Summary: Updates aoEventCache with all event data.

      Args: None

      Returns: None
    -------------------------------------------------------------------F*/
    func fnGetInstitutionEvents() {
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

      Summary: Retrives list of all events for a specific organization sorted by timestamp

      Args: oOrganization - the document reference in the database for this organization
        sOrganizationName - the name of the organization
        sOrganizationDescription - the description of the organization
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
      Function: fnUpdateEventLikes
      
      Summary: Updates the database so that the event passed in has it's likes raised by one
        
      Args: sEvent - the event that has been liked
        
      Returns: None
    -------------------------------------------------------------------F*/
    func fnUpdateEventLikes(sEvent: EventModel) {
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).getDocument { snapshot, error in
            guard var oEventData = snapshot?.data() else {
                return
            }
            sEvent.im_Likes += 1
            oEventData["event_likes"] = sEvent.im_Likes
            self.oDatabase.collection("Institutions").document(self.sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).updateData(oEventData)
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnUpdateEventReports
         
      Summary: Updates the database so that the event passed in has it's reports raised by 1
         
      Args: sEvent - the event that has been liked
         
      Returns: None
    -------------------------------------------------------------------F*/
    func fnUpdateEventReports(sEvent: EventModel) {
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).getDocument { snapshot, error in
            guard var oEventData = snapshot?.data() else {
                return
            }
            let iNumReports = oEventData["event_reports"] as! Int
            oEventData["event_reports"] = iNumReports + 1
            self.oDatabase.collection("Institutions").document(self.sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).updateData(oEventData)
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         Function: fnGetInstitutionAnnouncements
         
         Summary: Updates aoAnnouncementList with all announcements in an institution
         
         Args: None
         
         Returns: None
     -------------------------------------------------------------------F*/
    func fnGetInstitutionAnnouncements() {
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").getDocuments { snapshot, error in
            guard let oOrganizationDocuments = snapshot?.documents else {
                return
            }
            for oOrganizationDocument in oOrganizationDocuments {
                let oOrganizationData = oOrganizationDocument.data()
                self.fnGetOrganizationAnnouncements(oOrganization: oOrganizationDocument.reference, sOrganizationName: oOrganizationData["organization_name"] as! String, sOrganizationDescription: oOrganizationData["organization_description"] as! String, hCompletionHandler: {(aoOrgAnnouncementList) -> Void in
                    self.aoAnnouncementList.append(contentsOf: aoOrgAnnouncementList)
                })
            }
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     Function: fnGetOrganizationAnnouncements
     
     Summary: Retrieves list of announcements sorted by date ascending for a specific organizaiton
     
     Args: oOrganization - reference to the document of the host organization
     sOrganizationName - the name of the host organization
     sOrganizationDescription - the description of the host organization
     hCompletionHandler - the handler that holds async return value
     
     Returns: None technically, but handler contains announcement list
     -------------------------------------------------------------------F*/
    func fnGetOrganizationAnnouncements(oOrganization: DocumentReference, sOrganizationName: String, sOrganizationDescription: String, hCompletionHandler: @escaping ([AnnouncementModel]) -> Void) {
        var aoOrganizationAnnouncementList: [AnnouncementModel] = []
        oOrganization.collection("Announcements").order(by: "announcement_timestamp").getDocuments { snapshot, error in
            guard let oOrganizationAnnouncementDocuments = snapshot?.documents else {
                hCompletionHandler(aoOrganizationAnnouncementList)
                return
            }
            for oOrganizationAnnouncementDocument in oOrganizationAnnouncementDocuments {
                let oAnnouncementData = oOrganizationAnnouncementDocument.data()
                aoOrganizationAnnouncementList.append(AnnouncementModel(sId: oOrganizationAnnouncementDocument.documentID, sDescription: oAnnouncementData["announcement_message"] as! String, sHostId: oOrganization.documentID, sHostName: sOrganizationName, sHostDescription: sOrganizationDescription, bFollowed: false, oDateEvent: oAnnouncementData["announcement_timestamp"] as! Timestamp))
            }
            hCompletionHandler(aoOrganizationAnnouncementList)
        }
    }
}
