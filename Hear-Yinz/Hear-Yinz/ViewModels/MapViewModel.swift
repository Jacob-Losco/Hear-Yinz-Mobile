/*+===================================================================
File: MapViewModel.swift

Summary: Viewmodel used to set data that needs to be viewed on the map view

Exported Data Structures: oLocationRegion - the MkCoordinateRegion for the map

Exported Functions: fnFilterEventsList - returns the list of events to display to the map filtered by date

Contributors:
    Jacob Losco - 3/16/2023 - SP-220
===================================================================+*/

import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: ObservableObject {
    @ObservedObject var oDBFunctions = DBFunctions()
    @Published var oLocationRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnFilterEventsList

      Summary: returns a subset of the aoEventCache array for the events that need to be displayed to map based on date

      Args: oToDate - the latest date to display on the map
            bJustDate - true if user only wants events from a specific date, false otherwise

      Returns: [EventModel] - the list of events to display on the map
    -------------------------------------------------------------------F*/
    func fnFilterEventsList(oToDate: Date, bJustDate: Bool) -> [EventModel] {
        var aoEventList: [EventModel] = []
        let oToDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: oToDate)
        let oToDateDay = oToDateComponents.day ?? 0
        let oToDateMonth = oToDateComponents.month ?? 0
        let oToDateYear = oToDateComponents.year ?? 0
        let oCache = oDBFunctions.aoEventCache
        for oEvent in oCache {
            let oEventDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: oEvent.om_DateEvent)
            let oEventDateDay = oEventDateComponents.day ?? 0
            let oEventDateMonth = oEventDateComponents.month ?? 0
            let oEventDateYear = oEventDateComponents.year ?? 0
            if(bJustDate ? (oEventDateDay == oToDateDay && oEventDateMonth == oToDateMonth && oEventDateYear == oToDateYear) : oEvent.om_DateEvent < oToDate) {
                aoEventList.append(oEvent)
            }
            else if (!bJustDate){
                break
            }
        }
        return aoEventList
    }
    
    init() {
        Task {
            await oDBFunctions.fnInitSessionData()
            let oLocation = await oDBFunctions.fnGetInstitutionCoordinate()
            oLocationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: oLocation.latitude, longitude: oLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            await oDBFunctions.fnGetInstitutionEvents()
        }
    }
}
