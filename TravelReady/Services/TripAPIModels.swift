//
//  TripAPIModels.swift
//  TravelReady
//
//  Created by Mariswaran Balasubramanian on 11/19/25.
//

import Foundation

struct TripsResponseDTO: Decodable {
    let items: [TripDTO]
    let limit: Int
    let offset: Int
    let total: Int
}

struct TripDTO: Decodable {
    let id: String
    let name: String
    let origin: String
    let destination: String
    let travelType: String
    let travelerCount: Int
    let startDate: Date
    let endDate: Date
    let tags: [String]
    let phase: String
    let status: String
    let timezone: String
    let createdAt: Date
    let updatedAt: Date
}
