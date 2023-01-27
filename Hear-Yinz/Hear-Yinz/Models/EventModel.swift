//
//  EventModel.swift
//  Hear-Yinz
//
//  Created by Jacob Losco on 1/26/23.
//

import Foundation
import FirebaseFirestore

class EventModel {
    let id : String
    let name: String
    let description: String
    let location: String
    let likes: Int
    let reports: Int
    let status: Int
    let followed: Bool
    let dateEvent: Timestamp
    
    init(id: String, name: String, description: String, location: String, likes: Int, reports: Int, status: Int, followed: Bool, dateEvent: Timestamp) {
        self.id = id
        self.name = name
        self.description = description
        self.location = location
        self.likes = likes
        self.reports = reports
        self.status = status
        self.followed = followed
        self.dateEvent = dateEvent
    }
}
