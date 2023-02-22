/*+===================================================================
File: MapViewModel.swift

Summary: Viewmodel used to set data that needs to be viewed on the map view

Exported Data Structures: oLocationRegion - the MkCoordinateRegion for the map

Exported Functions: fnFilterEventsList - returns the list of events to display to the map filtered by date

Contributors:
    Jacob Losco - 2/22/2023 - SP-220
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

      Args: toDate - the latest date to display on the map

      Returns: [EventModel] - the list of events to display on the map
    -------------------------------------------------------------------F*/
    func fnFilterEventsList(toDate: Date) -> [EventModel] {
        var aoEventList: [EventModel] = []
        let oCache = oDBFunctions.aoEventCache
        print(oCache.count)
        for oEvent in oCache {
            print(oEvent.om_DateEvent)
            if(!(oEvent.om_DateEvent < toDate)) {
                break
            }
            else {
                aoEventList.append(oEvent)
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
