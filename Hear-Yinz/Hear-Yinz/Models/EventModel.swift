/*+===================================================================
File: EventModel

Summary: A model that contains all information needed for an event in the database

Exported Data Structures: EventModel - the model

Exported Functions: init - constructor

Contributors:
    Jacob Losco - 1/29/2022 - SP-349

===================================================================+*/

import Foundation
import FirebaseFirestore

class EventModel {
    let sId: String //document id of the event
    let sName: String //name of the event
    let sDescription: String //description of the event
    let oLocationCoordinate: GeoPoint //the coordinate of the location of the event
    let sLocationName: String //the name of the location of the event
    let sHostId: String //the document id of the organization that is hosting the event
    var sHostName: String = "" //the name of the organization that is hosting the event
    var sHostDescription: String = "" //the description of the organization that is hosting the event
    let iLikes: Int //the number of likes of the event
    let iReports: Int //the number of reports of the event
    let bFollowed: Bool //whether or not this event is followed by the user
    let oDateEvent: Date //the timestamp of the event
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: init

      Summary: constructor

      Args: sId - event id
        sName - event name
        sDescription - event description
        oLocationCoordinate - Geopoint for event location
        sLocationName - name for event location
        sHostId - id for event host
        sHostName - name for event host
        sHostDescription - description for event host
        iLikes - number of likes for event
        iReports - number of reports for event
        bFollowed - bool for whether or not event is followed by user
        oDateEvent - firebase timestamp for when the event occurs

      Returns: None
    -------------------------------------------------------------------F*/
    init(sId: String, sName: String, sDescription: String, oLocationCoordinate: GeoPoint, sLocationName: String, sHostId: String, sHostName: String, sHostDescription: String, iLikes: Int, iReports: Int, bFollowed: Bool, oDateEvent: Timestamp) {
        self.sId = sId
        self.sName = sName
        self.sDescription = sDescription
        self.oLocationCoordinate = oLocationCoordinate
        self.sLocationName = sLocationName
        self.sHostId = sHostId
        self.sHostName = sHostName
        self.sHostDescription = sHostDescription
        self.iLikes = iLikes
        self.iReports = iReports
        self.bFollowed = bFollowed
        self.oDateEvent = oDateEvent.dateValue()
    }
}
