//
//  TripMapping.swift
//  TravelReady
//
//  Created by Mariswaran Balasubramanian on 11/19/25.
//


import Foundation

extension TripPhase {
    static func fromAPI(_ value: String) -> TripPhase {
        switch value.uppercased() {
        case "PRE_TRAVEL": return .pre
        case "IN_TRAVEL": return .inTravel
        case "END_TRAVEL": return .end
        case "POST_TRAVEL": return .post
        default: return .pre
        }
    }
}

extension Trip {
    static func from(dto: TripDTO) -> Trip {
        Trip(
            name: dto.name,
            origin: dto.origin,
            destination: dto.destination,
            travelType: TravelType(rawValue: dto.travelType) ?? .leisure,
            travelMode: .air, // TODO: map when API sends mode
            currentPhase: TripPhase.fromAPI(dto.phase),
            departureDate: dto.startDate,
            returnDate: dto.endDate,
            adultCount: dto.travelerCount,
            childCount: 0,
            infantCount: 0,
            weatherSummary: nil,
            apiId: dto.id
        )
    }
}
