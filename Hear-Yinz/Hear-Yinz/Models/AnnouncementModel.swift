/*+===================================================================
File: AnnouncementModel

Summary: A model that contains all information needed for an announcement in the database

Exported Data Structures: AnnouncementModel - the model

Exported Functions: init - constructor

Contributors:
    Jacob Losco - 1/29/2022 - SP-349

===================================================================+*/

import Foundation
import FirebaseFirestore

class AnnouncementModel {
    let sId: String //document id of the announcement
    let sDescription: String //description of the announcement
    let sHostId: String //the document id of the organization that sent the announcement
    var sHostName: String = "" //the name of the organization that sent the announcement
    var sHostDescription: String = "" //the description of the organization that sent the announcement
    let bFollowed: Bool //whether or not this organization is followed by the user
    let oDateEvent: Date //the timestamp of the announcement
    
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
    init(sId: String, sDescription: String, sHostId: String, sHostName: String, sHostDescription: String, bFollowed: Bool, oDateEvent: Timestamp) {
        self.sId = sId
        self.sDescription = sDescription
        self.sHostId = sHostId
        self.sHostName = sHostName
        self.sHostDescription = sHostDescription
        self.bFollowed = bFollowed
        self.oDateEvent = oDateEvent.dateValue()
    }
}
