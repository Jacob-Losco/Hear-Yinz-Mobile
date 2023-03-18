/*+===================================================================
File: DBFunctions.swift

Summary: Contains functions and vars for retrieving and formatting data for firestore for front end

Exported Data Structures: aoAnnouncementList [AnnouncementModel] - a list of all announcements to be displayed to the map
                        aoEventCache [EventModel] - a list of all the events to be displayed to the map
                        aoOrganizationList [OrganizationModel] - a list of all organizations to be displayed in the blocked organizations list

Exported Functions: fnCreateRelationshipOrganziation - creates a relationship between the user and an organization
                    fnDeleteRelationshipOrganization - deletes a relationship between the user and an organization
                    fnGetBlockedOrganizations - returns all organizations blocked by user
                    fnGetImageDictionary - sets a dictionary with images for all organizations in institution
                    fnGetInstitutionAnnouncements - updates aoAnnouncementList with all announcement data
                    fnGetInstitutionEvents - updates aoEventCache with all event data
                    fnInitSessionData - sets necessary variables to use other database functions
                    fnUpdateEventLikes - increases an events likes by 1 in database
                    fnUpdateEventReports - increase an events reports by 1 in database
                    
Contributors:
    Jacob Losco - 3/18/2023 - SP-488

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
    var oInstitutionImageDictionary : [StorageReference : UIImage] = [:]
    @Published var aoEventCache : [EventModel] = [] //if on eventmap, all approved events in db occuring after Date.now(), sorted by timestamp
    @Published var aoAnnouncementList: [AnnouncementModel] = []
    @Published var aoOrganizationList: [OrganizationModel] = []
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     Function: fnCreateRelationshipOrganization
     
     Summary: creates relationship for account that links it to an organization based on a parameter
     
     Args: sOrganizationId - the doc id of the organization being followed
        iRelationshipType - the type of relationship
            1 - following
            2 - blocking
     
     Returns: Completion Handler Bool - true if the creation in the db was successful, false otherwise
     -------------------------------------------------------------------F*/
    func fnCreateRelationshipOrganization(sOrganizationId: String, iRelationshipType: Int, hCompletionHandler: @escaping (Bool) -> Void) {
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").document(sOrganizationId).getDocument { oOrganizationSnapshot, oOrganizationError in
            guard let oOrganizationReference = oOrganizationSnapshot?.reference else {
                hCompletionHandler(false)
                return
            }
            self.oDatabase.collection("Institutions").document(self.sInstitutionId).collection("Accounts").document(self.sAccountId).collection("Relationships").addDocument(data: ["relationship_org": oOrganizationReference, "relationship_status": 2, "relationship_type": iRelationshipType]) { oAddError in
                if oAddError != nil {
                    hCompletionHandler(false)
                    return
                }
                hCompletionHandler(true)
                return
            }
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     Function: fnDeleteRelationshipOrganization
     
     Summary: deletes relationship from account that makes them a follower of this organization
     also deletes the organization from aoorganizationlist
     
     Args: sOrganizationId - the doc id of the organization being unfollowed
     iRelationshipType - the type of relationship
         1 - unfollowing
         2 - unblocking
     
     Returns: Completion Handler Bool - true if the deletion in the db was successful, false otherwise
     -------------------------------------------------------------------F*/
    func fnDeleteRelationshipOrganization(sOrganizationId: String, iRelationshipType: Int, hCompletionHandler: @escaping (Bool) -> Void) {
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").document(sOrganizationId).getDocument { oOrganizationSnapshot, oOrganizationError in
            guard let oOrganizationReference = oOrganizationSnapshot?.reference else {
                hCompletionHandler(false)
                return
            }
            self.oDatabase.collection("Institutions").document(self.sInstitutionId).collection("Accounts").document(self.sAccountId).collection("Relationships").whereField("relationship_org", isEqualTo: oOrganizationReference).whereField("relationship_type", isEqualTo: iRelationshipType).getDocuments { oRelationshipSnapshot, oRelationshipError in
                guard let oRelationshipReference = oRelationshipSnapshot?.documents[0].reference else {
                    hCompletionHandler(false)
                    return
                }
                oRelationshipReference.delete() { oRelationshipError in
                    if oRelationshipError != nil {
                        hCompletionHandler(false)
                        return
                    } else {
                        hCompletionHandler(true)
                    }
                }
            }
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     Function: fnGetAccountIsFollowingOrganization
     
     Summary: returns true if the logged in account is following the organization, false otherwise
     
     Args: oOrganization - the doc reference of the organization being queried
     
     Returns: Bool - true if the user follows the organization, false otherwise
     -------------------------------------------------------------------F*/
    private func fnGetAccountIsFollowingOrganization(oOrganization: DocumentReference) async -> Bool {
        do {
            let oRelationshipSnapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Accounts").document(sAccountId).collection("Relationships").whereField("relationship_org", isEqualTo: oOrganization).whereField("relationship_status", isEqualTo: 2).whereField("relationship_type", isEqualTo: 1).getDocuments()
            return oRelationshipSnapshot.documents.count > 0
        } catch {
            print(error)
            return false
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     Function: fnGetBlockedOrganizations
     
     Summary: returns a list of organizations that have been blocked by the user
     
     Args: None
     
     Returns: [OrganizationModel] - a list of blocked organizations
     -------------------------------------------------------------------F*/
    func fnGetBlockedOrganizations() async -> Void {
        do {
            aoOrganizationList = []
            let oRelationshipSnapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Accounts").document(sAccountId).collection("Relationships").whereField("relationship_type", isEqualTo: 2).getDocuments()
            for oRelationshipDocument in oRelationshipSnapshot.documents {
                let oRelationshipData = oRelationshipDocument.data()
                let oOrganizationRef = oRelationshipData["relationship_org"] as! DocumentReference
                do {
                    let oOrganizationSnapshot = try await oOrganizationRef.getDocument()
                    let oOrganizationData = oOrganizationSnapshot.data()
                    aoOrganizationList.append(OrganizationModel(sId: oOrganizationSnapshot.documentID, sName: oOrganizationData?["organization_name"] as! String))
                } catch {
                    print(error)
                    return
                }
            }
        } catch {
            print(error)
            return
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     Function: fnGetImageDictionary
     
     Summary: updates accounts dark mode setting in database
     
     Args: None
     
     Returns: Completion Handler Bool - true if the update in the db was successful, false otherwise
     -------------------------------------------------------------------F*/
    func fnGetImageDictionary(hCompletionHandler: @escaping ([StorageReference : UIImage]) -> Void) async {
        var aoImageDictionary : [StorageReference : UIImage] = [:]
        let oStorageReference = oStorage.reference().child("images/" + sInstitutionId + "/")
        do {
            let aoInstitutionResult = try await oStorageReference.listAll()
            let oInstitutionImage = aoInstitutionResult.items
                oInstitutionImage[0].getData(maxSize: 5 * 1024 * 1024) { oInstitutionImageData, oInstitutionImageError in
                    if oInstitutionImageData == nil && oInstitutionImageError != nil {
                        hCompletionHandler(aoImageDictionary)
                        return
                    }
                    aoImageDictionary[oStorageReference] = UIImage(data: oInstitutionImageData!)
                    let aoInstitutionPrefixes = aoInstitutionResult.prefixes
                    for oPrefix in aoInstitutionPrefixes {
                        oPrefix.listAll { oPrefixResult, oPrefixError in
                            guard let oOrganizationImage = oPrefixResult?.items else {
                                return
                            }
                            if(!oOrganizationImage.isEmpty) {
                                oOrganizationImage[0].getData(maxSize: 5 * 1024 * 1024) { oOrganizationImageData, oOrganizationImageError in
                                    if oOrganizationImageData != nil && oOrganizationImageError == nil {
                                        aoImageDictionary[oPrefix] = UIImage(data: oOrganizationImageData!)
                                        return
                                    }
                                    else {
                                        return
                                    }
                                }
                            }
                        }
                    }
                    hCompletionHandler(aoImageDictionary)
                }
            } catch {
                hCompletionHandler(aoImageDictionary)
            }
        }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetInstitution

      Summary: Retrieves user Institution document id from the database. Returns failure message if retrieval fails

      Args: sUserEmail - the email of the authenticated user

      Returns: String - the id of the institution this account is logged into, or an error message
    -------------------------------------------------------------------F*/
    private func fnGetInstitution(sUserEmail: String) async -> String {
        if(sUserEmail != "N/A"){
            let sUserHandle = "@" + sUserEmail.components(separatedBy: "@")[1]
            do {
                let oInstitutionSnapshot = try await oDatabase.collection("Institutions").whereField("institution_handle", isEqualTo: sUserHandle).getDocuments()
                return oInstitutionSnapshot.documents[0].documentID
            } catch {
                print(error)
                return "Error"
            }
        } else {
            return "Error"
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         Function: fnGetInstitutionAnnouncements
         
         Summary: Driver function for adding all institution announcements in aoAnnouncementList
         
         Args: None
         
         Returns: None
     -------------------------------------------------------------------F*/
    func fnGetInstitutionAnnouncements() async -> Void {
        do {
            let oOrganizationSnapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").getDocuments()
            for oOrganizationDocument in oOrganizationSnapshot.documents {
                let oOrganizationData = oOrganizationDocument.data()
                await fnGetOrganizationAnnouncements(oOrganization: oOrganizationDocument.reference, sOrganizationName: oOrganizationData["organization_name"] as! String, sOrganizationDescription: oOrganizationData["organization_description"] as! String)
            }
        } catch {
            print(error)
            return
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetInstitutionCoordinate

      Summary: Returns the coordinates associated with the map region of this institution

      Args: None

      Returns: GeoPoint - the coordinate associated with the map region of this institution
    -------------------------------------------------------------------F*/
    public func fnGetInstitutionCoordinate() async -> GeoPoint {
        do {
            let oInstitutionSnapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).getDocument()
            let oInstitutionData = oInstitutionSnapshot.data()
            return oInstitutionData?["institution_location"] as! GeoPoint
        } catch {
            print(error)
            return GeoPoint(latitude: 0, longitude: 0)
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
            let oOrganizationSnapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").getDocuments()
            for oOrganizationDocument in oOrganizationSnapshot.documents {
                let oRelationshipSnapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Accounts").document(sAccountId).collection("Relationships").whereField("relationship_org", isEqualTo: oOrganizationDocument.reference).whereField("relationship_type", isEqualTo: 2).getDocuments()
                if(oRelationshipSnapshot.documents.count == 0) {
                    let oOrganizationData = oOrganizationDocument.data()
                    await self.fnGetOrganizationEvents(oOrganization: oOrganizationDocument.reference, sOrganizationName: oOrganizationData["organization_name"] as! String, sOrganizationDescription: oOrganizationData["organization_description"] as! String)
                }
            }
            aoEventCache = aoEventCache.sorted(by: { $0.om_DateEvent.compare($1.om_DateEvent) == .orderedAscending })
        } catch {
            print(error)
            return
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     Function: fnGetOrganizationAnnouncements
     
     Summary: update aoAnnouncementList to append all announcements for this organization
     
     Args: oOrganization - reference to the document of the host organization
     sOrganizationName - the name of the host organization
     sOrganizationDescription - the description of the host organization
     
     Returns: None
     -------------------------------------------------------------------F*/
    private func fnGetOrganizationAnnouncements(oOrganization: DocumentReference, sOrganizationName: String, sOrganizationDescription: String) async -> Void {
        var oDateComponent = DateComponents()
        oDateComponent.month = -1
        let oExpireDate: Date = Calendar.current.date(byAdding: oDateComponent, to: Date()) ?? Date.now
        do {
            let oAnnouncementSnapshot = try await oOrganization.collection("Announcements").whereField("announcement_timestamp", isGreaterThan: Timestamp(date: oExpireDate)).order(by: "announcement_timestamp").getDocuments()
            let sInstitutionReference = oStorage.reference().child("images/" + sInstitutionId + "/")
            let sOrganizationReference = oStorage.reference().child("images/" + sInstitutionId + "/" + oOrganization.documentID + "/")
            var oOrganizationImage = oInstitutionImageDictionary[sOrganizationReference]
            if oOrganizationImage == nil {
                oOrganizationImage = oInstitutionImageDictionary[sInstitutionReference]
            }
            for oOrganizationAnnouncementDocument in oAnnouncementSnapshot.documents {
                let oAnnouncementData = oOrganizationAnnouncementDocument.data()
                let bFollowed = await fnGetAccountIsFollowingOrganization(oOrganization: oOrganization)
                aoAnnouncementList.append(AnnouncementModel(sId: oOrganizationAnnouncementDocument.documentID, sDescription: oAnnouncementData["announcement_message"] as! String, sHostId: oOrganization.documentID, sHostName: sOrganizationName, sHostDescription: sOrganizationDescription, bFollowed: bFollowed, oDateEvent: oAnnouncementData["announcement_timestamp"] as! Timestamp, oImage: oOrganizationImage))
            }
        } catch {
            print(error)
            return
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetOrganizationEvents

      Summary: appends all events in this organization to aoEventCache

      Args: oOrganization - the document reference in the database for this organization
        sOrganizationName - the name of the organization
        sOrganizationDescription - the description of the organization

      Returns: None
    -------------------------------------------------------------------F*/
    private func fnGetOrganizationEvents(oOrganization: DocumentReference, sOrganizationName: String, sOrganizationDescription: String) async -> Void {
        do {
            let oEventSnapshot = try await oOrganization.collection("Events").whereField("event_timestamp", isGreaterThan: Timestamp(date: Date())).order(by: "event_timestamp").getDocuments()
            let sInstitutionReference = oStorage.reference().child("images/" + sInstitutionId + "/")
            let oInstitutionImage = oInstitutionImageDictionary[sInstitutionReference]
            let sOrganizationReference = oStorage.reference().child("images/" + sInstitutionId + "/" + oOrganization.documentID + "/")
            var oOrganizationImage = oInstitutionImageDictionary[sOrganizationReference]
            if oOrganizationImage == nil {
                oOrganizationImage = oInstitutionImage
            }
            if oOrganizationImage == nil {
                oOrganizationImage = UIImage(named: "Default")
            }
            for oOrganizationEventDocument in oEventSnapshot.documents {
                let oEventData = oOrganizationEventDocument.data()
                do {
                    
                    let oLocationSnapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Locations").document(oEventData["event_location"] as! String).getDocument()
                    guard let oLocationData = oLocationSnapshot.data() else {
                        continue
                    }
                    let bFollowed = await fnGetAccountIsFollowingOrganization(oOrganization: oOrganization)
                    aoEventCache.append(EventModel(sId: oOrganizationEventDocument.documentID, sName: oEventData["event_name"] as! String, sDescription: oEventData["event_description"] as! String, oLocationCoordinate: oLocationData["location_coordinate"] as! GeoPoint, sLocationName: oLocationData["location_name"] as! String, sHostId: oOrganization.documentID, sHostName: sOrganizationName, sHostDescription: sOrganizationDescription, iLikes: oEventData["event_likes"] as! Int, bFollowed: bFollowed, oDateEvent: oEventData["event_timestamp"] as! Timestamp, oImage: oOrganizationImage))
                } catch {
                    print(error)
                    return
                }
            }
        } catch {
            print(error)
            return
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnGetUserAccount

      Summary: Retrieves user Account document id from the database. Returns failure message if retrieval fails

      Args: sUserEmail - the email of the authenticated user

      Returns: String - document id of the account associated with the authed user
    -------------------------------------------------------------------F*/
    private func fnGetUserAccount(sUserEmail: String) async -> String {
        if(sUserEmail != "N/A"){
            do {
                let oAccountSnapshot = try await oDatabase.collection("Institutions").document(sInstitutionId).collection("Accounts").whereField("account_email", isEqualTo: sUserEmail).getDocuments()
                return oAccountSnapshot.documents[0].documentID
            } catch {
                print(error)
                return "Error"
            }
        } else {
            return "Error"
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnInitSessionData

      Summary: Used to initialize account and institution data for use in other db functions.

      Args: None

      Returns: None
    -------------------------------------------------------------------F*/
    func fnInitSessionData() async {
        sInstitutionId = await fnGetInstitution(sUserEmail: Auth.auth().currentUser?.email ?? "N/A")
        sAccountId = await fnGetUserAccount(sUserEmail: Auth.auth().currentUser?.email ?? "N/A")
        await fnGetImageDictionary(hCompletionHandler: {(imageDictionary) -> Void in
            if(self.sAccountId != "Error") {
                self.oInstitutionImageDictionary = imageDictionary
            }
        })
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnUpdateEventLikes
      
      Summary: Updates the database so that the event passed in has it's likes raised by one
        
      Args: sEvent - the event that has been liked
        
      Returns: Competion Handler Bool - true if the update of the database was successful, false otherwise
    -------------------------------------------------------------------F*/
    func fnUpdateEventLikes(sEvent: EventModel, hCompletionHandler: @escaping (Bool) -> Void){
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).getDocument { oEventSnapshot, oEventError in
                guard var oEventData = oEventSnapshot?.data() else {
                    hCompletionHandler(false)
                    return
                }
                sEvent.im_Likes += 1
                oEventData["event_likes"] = sEvent.im_Likes
                self.oDatabase.collection("Institutions").document(self.sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).updateData(oEventData)
                hCompletionHandler(true)
            }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnUpdateEventReports
         
      Summary: Updates the database so that the event passed in has it's reports raised by 1
         
      Args: sEvent - the event that has been liked
         
      Returns: Completion Handler Bool - true if the update of the databse was successful, false otherwise
    -------------------------------------------------------------------F*/
    func fnUpdateEventReports(sEvent: EventModel, hCompletionHandler: @escaping (Bool) -> Void) {
        oDatabase.collection("Institutions").document(sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).getDocument { oEventSnapshot, oEventError in
            guard var oEventData = oEventSnapshot?.data() else {
                hCompletionHandler(false)
                return
            }
            let iNumReports = oEventData["event_reports"] as! Int
            oEventData["event_reports"] = iNumReports + 1
            self.oDatabase.collection("Institutions").document(self.sInstitutionId).collection("Organizations").document(sEvent.sm_HostId).collection("Events").document(sEvent.sm_Id).updateData(oEventData)
            hCompletionHandler(true)
        }
    }
}
