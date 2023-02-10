/*+===================================================================
 File: AnnouncementModel.swift
 
 Summary: A model that contains all information needed for an announcement in the database
 
 Exported Data Structures: AnnouncementModel - the model
 
 Exported Functions: init - constructor
 
 Contributors:
    Jacob Losco - 1/29/2022 - SP-349
===================================================================+*/

import Foundation
import FirebaseFirestore

class AnnouncementModel {
    let sm_Id: String //document id of the announcement
    let sm_Description: String //description of the announcement
    let sm_HostId: String //the document id of the organization that sent the announcement
    var sm_HostName: String = "" //the name of the organization that sent the announcement
    var sm_HostDescription: String = "" //the description of the organization that sent the announcement
    let bm_Followed: Bool //whether or not this organization is followed by the user
    let om_DateEvent: Date //the timestamp of the announcement
    let om_Image: UIImage? //the image of the organization posting the announcement
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: init
      Summary: constructor
      Args: sId - announcement id
        sDescription - announcement description
        sHostId - id for announcement organization
        sHostName - name for announcement organization
        sHostDescription - description for announcement organization
        bFollowed - bool for whether or not organization is followed by user
        oDateEvent - firebase timestamp for when the announcement was posted
      Returns: None
    -------------------------------------------------------------------F*/
    init(sId: String, sDescription: String, sHostId: String, sHostName: String, sHostDescription: String, bFollowed: Bool, oDateEvent: Timestamp, oImage: UIImage?) {
        self.sm_Id = sId
        self.sm_Description = sDescription
        self.sm_HostId = sHostId
        self.sm_HostName = sHostName
        self.sm_HostDescription = sHostDescription
        self.bm_Followed = bFollowed
        self.om_DateEvent = oDateEvent.dateValue()
        self.om_Image = oImage
    }
}
