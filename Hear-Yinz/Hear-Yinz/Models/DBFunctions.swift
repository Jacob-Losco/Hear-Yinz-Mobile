/*+===================================================================
File: DBFunctions.swift

Summary: Contains functions and vars for retrieving and formatting data for firestore for front end

Exported Data Structures: aoEventCache [EventModel] - a list of all the events to be displayed to the map
                        aoAnnouncementList [AnnouncementModel] - a list of all announcements to be displayed to the map

Exported Functions: fnInitSessionData - sets necessary variables to use other database functions
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
import FirebaseStorage

@MainActor class DBFunctions: ObservableObject {
    let oStorage = Storage.storage()
    let oDatabase = Firestore.firestore() //object representing the firestore database
    var sInstitutionId : String = "" //the id of the institution currently logged in
    var sAccountId : String = "" //the id of the account currently logged in
    var oInstitutionImage : UIImage? = nil
    @Published var aoEventCache : [EventModel] = [] //if on eventmap, all approved events in db occuring after Date.now(), sorted by timestamp
    @Published var aoAnnouncementList: [AnnouncementModel] = []
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnInitSessionData

      Summary: Used to initialize account and institution data for use in other db functions.

      Args: None

      Returns: None
    -------------------------------------------------------------------F*/
    func fnInitSessionData() async {
        sInstitutionId = await fnGetInstitution(sUserEmail: Auth.auth().currentUser?.email ?? "N/A")
        sAccountId = await fnGetUserAccount(sUserEmail: Auth.auth().currentUser?.email ?? "N/A")
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetInstitution

      Summary: Retrieves user Institution document id from the database. Returns failure message if retrieval fails

      Args: None

      Returns: String - the id of the institution this account is logged into, or an error message
    -------------------------------------------------------------------F*/
    private func fnGetInstitution(sUserEmail: String) async -> String {
        if(sUserEmail != "N/A"){
            let sUserHandle = "@" + sUserEmail.components(separatedBy: "@")[1]
            do {
                let snapshot = try await oDatabase.collection("Institutions").whereField("institution_handle", isEqualTo: sUserHandle).getDocuments()
                return snapshot.documents[0].documentID
            } catch {
                print(error)
                return "Error Retrieving Data"
            }
        } else {
            return "Error Not Signed In"
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetUserAccount

      Summary: Retrives user Account document id from the database. Returns failure message if retrieval fails

      Args: sInstitutionId - the document id of the user institution
        hCompletionHandler - the handler that holds async return value

      Returns: String - document id of the account associated with the authed user
    -------------------------------------------------------------------F*/
    private func fnGetUserAccount(sUserEmail: String) async -> String {
        if(sUserEmail != "N/A"){
            do {
                let snapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Accounts").whereField("account_email", isEqualTo: sUserEmail).getDocuments()
                return snapshot.documents[0].documentID
            } catch {
                print(error)
                return "Error Retrieving Data"
            }
        } else {
            return "Error Not Signed In"
        }
    }

    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetInstitutionEvents

      Summary: Updates aoEventCache with all event data.

      Args: None

      Returns: None
    -------------------------------------------------------------------F*/
    func fnGetInstitutionEvents() async -> Void {
        do {
            let snapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").getDocuments()
            for oOrganizationDocument in snapshot.documents {
                let oOrganizationData = oOrganizationDocument.data()
                await fnGetOrganizationEvents(oOrganization: oOrganizationDocument.reference, sOrganizationName: oOrganizationData["organization_name"] as! String, sOrganizationDescription: oOrganizationData["organization_description"] as! String)
            }
        } catch {
            print(error)
            return
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
    private func fnGetOrganizationEvents(oOrganization: DocumentReference, sOrganizationName: String, sOrganizationDescription: String) async -> Void {
        do {
            let snapshot = try await oOrganization.collection("Events").order(by: "event_timestamp").getDocuments()
            for oOrganizationEventDocument in snapshot.documents {
                let oEventData = oOrganizationEventDocument.data()
                do {
                    let locationSnapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Locations").document(oEventData["event_location"] as! String).getDocument()
                    guard let oLocationData = locationSnapshot.data() else {
                        continue
                    }
                    let bFollowed = await fnGetAccountIsFollowingOrganization(oOrganization: oOrganization)
                    aoEventCache.append(EventModel(sId: oOrganizationEventDocument.documentID, sName: oEventData["event_name"] as! String, sDescription: oEventData["event_description"] as! String, oLocationCoordinate: oLocationData["location_coordinate"] as! GeoPoint, sLocationName: oLocationData["location_name"] as! String, sHostId: oOrganization.documentID, sHostName: sOrganizationName, sHostDescription: sOrganizationDescription, iLikes: oEventData["event_likes"] as! Int, bFollowed: bFollowed, oDateEvent: oEventData["event_timestamp"] as! Timestamp, oImage: nil))
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnUpdateEventLikes
      
      Summary: Updates the database so that the event passed in has it's likes raised by one
        
      Args: sEvent - the event that has been liked
        
      Returns: None
    -------------------------------------------------------------------F*/
    func fnUpdateEventLikes(sEvent: EventModel) async -> Bool {
        do {
            let snapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).getDocument()
            guard var oEventData = snapshot.data() else {
                return false
            }
            sEvent.im_Likes += 1
            oEventData["event_likes"] = sEvent.im_Likes
            try await oDatabase.collection("Institutions").document(self.sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).updateData(oEventData)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnUpdateEventReports
         
      Summary: Updates the database so that the event passed in has it's reports raised by 1
         
      Args: sEvent - the event that has been liked
         
      Returns: None
    -------------------------------------------------------------------F*/
    func fnUpdateEventReports(sEvent: EventModel) async -> Bool {
        do {
            let snapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).getDocument()
            guard var oEventData = snapshot.data() else {
                return false
            }
            let iNumReports = oEventData["event_reports"] as! Int
            oEventData["event_reports"] = iNumReports + 1
            try await oDatabase.collection("Institutions").document(self.sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).updateData(oEventData)
            return true
        } catch {
            print(error)
            return false
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
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     Function: fnGetAccountIsFollowingOrganization
     
     Summary: Handler returns true if the logged in account is following the organization, false otherwise
     
     Args: oOrganization - the doc reference of the organization being queried
     hCompletionHandler - the handler that holds async return value
     
     Returns: None technically, but handler contains Bool
     -------------------------------------------------------------------F*/
    func fnGetAccountIsFollowingOrganization(oOrganization: DocumentReference) async -> Bool {
        do {
            let snapshot = try await oDatabase.collection("Institutions").document(sAccountId).collection("Relationships").whereField("relationship_org", isEqualTo: oOrganization).whereField("relationship_status", isEqualTo: 2).whereField("relationship_type", isEqualTo: 1).getDocuments()
            return snapshot.documents.count > 0
        } catch {
            print(error)
            return false
        }
    }
}
