import Foundation
import SwiftData

@Model
final class Trip {
    @Attribute(.unique) var id: UUID
    var name: String
    var origin: String
    var destination: String

    // NEW fields:
    var travelType: TravelType
    var travelMode: TravelMode
    var currentPhase: TripPhase

    var departureDate: Date
    var returnDate: Date

    // You can add counts now or later
    var adultCount: Int
    var childCount: Int
    var infantCount: Int
    
    var weatherSummary: String?


    init(
        id: UUID = UUID(),
        name: String,
        origin: String,
        destination: String,
        travelType: TravelType = .leisure,
        travelMode: TravelMode = .air,
        currentPhase: TripPhase = .pre,
        departureDate: Date = .now,
        returnDate: Date = .now,
        adultCount: Int = 1,
        childCount: Int = 0,
        infantCount: Int = 0,
        weatherSummary: String? = nil      // NEW
    ) {
        self.id = id
        self.name = name
        self.origin = origin
        self.destination = destination
        self.travelType = travelType
        self.travelMode = travelMode
        self.currentPhase = currentPhase
        self.departureDate = departureDate
        self.returnDate = returnDate
        self.adultCount = adultCount
        self.childCount = childCount
        self.infantCount = infantCount
        self.weatherSummary = weatherSummary

    }
}
