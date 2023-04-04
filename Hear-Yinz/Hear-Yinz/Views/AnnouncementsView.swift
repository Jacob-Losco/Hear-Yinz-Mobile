/*+===================================================================
File: AnnouncementsView

Summary: View for announcements screen

Exported Data Structures: Announcements View

Exported Functions: None

Contributors:
    Jacob Losco - 2/4/2023 - SP-220
    Keaton Hollobaugh - 3/08/2023 - SP-246/247

===================================================================+*/

import SwiftUI

struct AnnouncementsView: View {
    
    @State var aoAnnouncementList: [AnnouncementModel] = []
    @State var oisGeneralSelected = true
    @StateObject var oDBFunctions = DBFunctions()
    @State var ofollowedAnnouncements: [AnnouncementModel] = []
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text("Announcements")
                .font(.custom("DMSans-Regular", size: 18))
            Spacer()
            
            HStack {
                Button(action: {
                    oisGeneralSelected = true
                    if aoAnnouncementList.isEmpty {
                        Task {
                            await oDBFunctions.fnInitSessionData()
                            await oDBFunctions.fnGetInstitutionAnnouncements()
                            aoAnnouncementList = oDBFunctions.aoAnnouncementList
                            ofollowedAnnouncements = aoAnnouncementList.filter { $0.bm_Followed }
                        }
                    }
                }) {
                    Text("General")
                        .font(.custom("DMSans-Regular", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(oisGeneralSelected ? .black : .gray)
                }
                Spacer().frame(width: 20)
                Button(action: {
                    oisGeneralSelected = false
                    ofollowedAnnouncements = aoAnnouncementList.filter { $0.bm_Followed }
                }) {
                    Text("Following")
                        .font(.custom("DMSans-Regular", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(oisGeneralSelected ? .gray : .black)
                }
            }
            
            Spacer()
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(oisGeneralSelected ? aoAnnouncementList : ofollowedAnnouncements, id: \.sm_Id) { oAnnouncement in
                        AnnouncementView(oAnnouncement: oAnnouncement, dateFormatter: dateFormatter)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .onAppear {
            if aoAnnouncementList.isEmpty {
                Task {
                    await oDBFunctions.fnInitSessionData()
                    await oDBFunctions.fnGetInstitutionAnnouncements()
                    aoAnnouncementList = oDBFunctions.aoAnnouncementList
                    ofollowedAnnouncements = aoAnnouncementList.filter { $0.bm_Followed }
                }
            }
        }
    }
    
    struct AnnouncementView: View {
            
        let oAnnouncement: AnnouncementModel
        let dateFormatter: DateFormatter
        
        @State private var isExpanded = false
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color("highlight"))
                    .frame(maxWidth: .infinity, maxHeight: isExpanded ? nil : 150)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .accessibilityIdentifier("AnnouncementCell")
                    .accessibilityIdentifier("AnnouncementView_\(oAnnouncement.sm_Id)")
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 10) {
                        if let oImage = oAnnouncement.om_Image {
                            Image(uiImage: oImage)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(oAnnouncement.sm_HostName)
                                    .font(.custom("DMSans-Regular", size: 18))
                                Spacer()
                                Text(dateFormatter.string(from: oAnnouncement.om_DateEvent))
                                    .font(.footnote)
                            }
                            Text(oAnnouncement.sm_Description)
                                .font(.custom("DMSans-Regular", size: 18))
                                .lineLimit(isExpanded ? nil : 2)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
                    .background(Color.clear)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
            }
        }
    }
}
