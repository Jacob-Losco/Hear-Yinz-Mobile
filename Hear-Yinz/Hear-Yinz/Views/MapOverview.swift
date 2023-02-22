/*+===================================================================
File: MapOverview.swift

Summary: Opens a Apple Maps overview of Saint Vincent College.

Exported Data Structures: MapView - the view itself

Exported Functions: none

Contributors:
    Sarah Kudrick - 2/13/23 - SP-456 (i commented out a line around line 55 to test my code. You can delete this once this line is uncommented.)
    Keaton Hollobaugh - 02/02/2023 - SP-216
    Jacob Losco - 2/4/2023 - SP-220
    Keaton Hollobaugh - 02/08/2023 - SP-227
===================================================================+*/

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var oMapData = MapViewModel()
    @State private var aoEventList: [EventModel] = []
    @State private var oFromDate: Date = Date.now
    @State private var sFromDateLabel: String = ""
    @State private var oToDate: Date = Date.now;
    @State private var sToDateLabel: String = ""
    @State private var dFromDateValue: Double = Double(Date.now.timeIntervalSinceNow)
    @State private var dToDateValue: Double = 0
    @State private var dMaxToDateValue: Double = 0;
    
    
    var body: some View {
        Group{
            ZStack {
                Map(coordinateRegion: $oMapData.oLocationRegion, annotationItems: aoEventList, annotationContent: { event in
                    MapAnnotation(coordinate: event.om_LocationCoordinate) {
                        MapMarkerView(id: event.sm_Id, mapText: event.sm_Name, image: event.om_Image)
                    }
                })
                .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Spacer()
                    VStack {
                        Text("\(sFromDateLabel) - \(sToDateLabel)")
                        Slider(value: $dToDateValue, in: dFromDateValue...dMaxToDateValue)
                            .frame(width: 300, height: 20)
                            .onChange(of: dToDateValue) { value in
                                oToDate = Date(timeIntervalSinceNow: TimeInterval(dToDateValue))
                                aoEventList = oMapData.fnFilterEventsList(toDate: oToDate)
                                sToDateLabel = oToDate.formatted(.dateTime.day().month().year())
                            }
                    }
                    .cornerRadius(15)
                    Rectangle() //Adds custom color background to tab bar.
                        .fill(Color.clear)
                        .frame(height: 10)
                        .background(Color("highlight"))
                }
            }.onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
                
            }
            .onDisappear {
                DispatchQueue.main.async {
                    AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
                }
            }
            .task {
                aoEventList = oMapData.fnFilterEventsList(toDate: Date.now)
                sFromDateLabel = oFromDate.formatted(.dateTime.day().month().year())
                sToDateLabel = oToDate.formatted(.dateTime.day().month().year())
                var oDateComponent = DateComponents()
                oDateComponent.year = 1
                let oMaxToDate = Calendar.current.date(byAdding: oDateComponent, to: oFromDate) ?? Date.now
                dMaxToDateValue = oMaxToDate.timeIntervalSinceNow
            }
        }
    }
    
    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView()
        }
    }
}
