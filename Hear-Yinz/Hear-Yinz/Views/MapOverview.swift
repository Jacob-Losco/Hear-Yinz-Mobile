/*+===================================================================
File: MapOverview.swift

Summary: Opens a Apple Maps overview of Saint Vincent College.

Exported Data Structures: MapView - the view itself

Exported Functions: none

Contributors:
    Keaton Hollobaugh - 2/26/2023 - SP-229/230
    Sarah Kudrick - 3/10/23 - SP-450
    Jacob Losco - 3/16/2023 - SP-489
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
    @State private var sSliderDateLabel: String = ""
    @State private var dFromDateValue: Double = Double(Date.now.timeIntervalSinceNow)
    @State private var dToDateValue: Double = 0
    @State private var dMaxToDateValue: Double = 0;
    @State private var bSliderTypeIsDay: Bool = false
    @State private var selectedEvent: EventModel? = nil
    @State private var bShowPopUp = false
    @State private var bIsFollowing: Bool = true
    //@State var sFollowing: String
    let dateFormatter = DateFormatter()
    
    var body: some View {
        Group{
            ZStack {
                Map(coordinateRegion: $oMapData.oLocationRegion, annotationItems: aoEventList, annotationContent: { event in
                    MapAnnotation(coordinate: event.om_LocationCoordinate) {
                        MapMarkerView(id: event.sm_Id, mapText: event.sm_Name, eventModel: event)
                            .accessibilityIdentifier(event.sm_Id)
                            .onTapGesture {
                                selectedEvent = event
                                bIsFollowing = event.bm_Followed
                            }
                    }
                    })
                .edgesIgnoringSafeArea(.all)
                
                if let event = selectedEvent {
                    EventDetailsView(event: event, bShowPopUp: $bShowPopUp, bIsFollowing: $bIsFollowing)
                    .frame(width: 300, height: UIScreen.main.bounds.height)
                    .background(Color("highlight"))
                    .offset(x: UIScreen.main.bounds.width / 2 - 150)
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut)
                    .font(.custom("DMSans-Regular", size: 18))
                }
                
                VStack{
                    Spacer()
                    VStack {
                        HStack{
                            Spacer()
                            if bSliderTypeIsDay {
                                Text("Day")
                                    .offset(x: -10)
                                    .font(.custom("DMSans-Regular", size: 16))
                                    .foregroundColor(Color("button1"))
                                Text("Range")
                                    .offset(x: -10)
                                    .font(.custom("DMSans-Regular", size: 14))
                                    
                            } else {
                                Text("Day")
                                    .offset(x: -10)
                                    .font(.custom("DMSans-Regular", size: 16))
                                Text("Range")
                                    .offset(x: -10)
                                    .font(.custom("DMSans-Regular", size: 14))
                                    .foregroundColor(Color("button1"))
                            }
                                
                        }
                        Text("\(bSliderTypeIsDay ? sToDateLabel : sFromDateLabel + " - " + sToDateLabel)")
                            .font(.custom("DMSans-Regular", size: 18))
                        Slider(value: $dToDateValue, in: dFromDateValue...dMaxToDateValue)
                            .accessibility(identifier: "map_slider")
                            .frame(width: 300, height: 5)
                            .onChange(of: dToDateValue) { value in
                                oToDate = Date(timeIntervalSinceNow: TimeInterval(dToDateValue))
                                aoEventList = oMapData.fnFilterEventsList(oToDate: oToDate, bJustDate: bSliderTypeIsDay)
                                sToDateLabel = dateFormatter.string(from: oToDate)
                            }
                            .colorInvert()
                            .tint(Color.white)
                    }
                    .frame(width: 350, height: 80)
                    .background(Color("highlight").opacity(0.75))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 1)
                    )
                    .onTapGesture {
                        bSliderTypeIsDay = !bSliderTypeIsDay
                        aoEventList = oMapData.fnFilterEventsList(oToDate: oToDate, bJustDate: bSliderTypeIsDay)
                        sToDateLabel = dateFormatter.string(from: oToDate)
                    }
                    Rectangle() //Adds custom color background to tab bar.
                        .fill(Color.clear)
                        .frame(height: 10)
                        .background(Color("highlight"))
                }
                if bShowPopUp {
                    OrganizationPopUp(event: selectedEvent!, bShowPopUp: $bShowPopUp, bIsFollowing: $bIsFollowing)
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
                dateFormatter.dateFormat = "MM/dd/yyyy"
                aoEventList = oMapData.fnFilterEventsList(oToDate: Date.now, bJustDate: true)
                sFromDateLabel = dateFormatter.string(from: oFromDate)
                sToDateLabel = dateFormatter.string(from: oToDate)
                var oDateComponent = DateComponents()
                oDateComponent.month = 5
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
