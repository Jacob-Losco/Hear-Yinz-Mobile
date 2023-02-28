/*+===================================================================
File: EventModel.swift

Summary: A model that contains all information needed for an event in the database

Exported Data Structures: EventModel - the model

Exported Functions: init - constructor

Contributors:
    Jacob Losco - 1/29/2022 - SP-349

===================================================================+*/

import Foundation
import FirebaseFirestore
import CoreLocation

class EventModel: Identifiable {
    let sm_Id: String //document id of the event
    let sm_Name: String //name of the event
    let sm_Description: String //description of the event
    let om_LocationCoordinate: CLLocationCoordinate2D //the coordinate of the location of the event
    let sm_LocationName: String //the name of the location of the event
    let sm_HostId: String //the document id of the organization that is hosting the event
    var sm_HostName: String = "" //the name of the organization that is hosting the event
    var sm_HostDescription: String = "" //the description of the organization that is hosting the event
    var im_Likes: Int //the number of likes of the event
    let bm_Followed: Bool //whether or not this event is followed by the user
    let om_DateEvent: Date //the timestamp of the event
    let om_Image: UIImage? //the image of the organization hosting the event
    
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
    init(sId: String, sName: String, sDescription: String, oLocationCoordinate: GeoPoint, sLocationName: String, sHostId: String, sHostName: String, sHostDescription: String, iLikes: Int, bFollowed: Bool, oDateEvent: Timestamp, oImage: UIImage?) {
        self.sm_Id = sId
        self.sm_Name = sName
        self.sm_Description = sDescription
        self.om_LocationCoordinate = CLLocationCoordinate2D(latitude: (oLocationCoordinate.latitude + Double.random(in: -0.0004 ..< 0.0004)), longitude: (oLocationCoordinate.longitude + Double.random(in: -0.0004 ..< 0.0004)))
        self.sm_LocationName = sLocationName
        self.sm_HostId = sHostId
        self.sm_HostName = sHostName
        self.sm_HostDescription = sHostDescription
        self.im_Likes = iLikes
        self.bm_Followed = bFollowed
        self.om_DateEvent = oDateEvent.dateValue()
        self.om_Image = oImage
    }
}
