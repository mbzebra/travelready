//
//  TravelReadyAPIService.swift
//  TravelReady
//
//  Created by Mariswaran Balasubramanian on 11/19/25.
//

import Foundation

enum TravelReadyAPIError: Error {
    case invalidURL
    case badStatusCode(Int)
}

final class TravelReadyAPIService {
    static let shared = TravelReadyAPIService()

    // TODO: set this to your real base URL
    // e.g. "http://127.0.0.1:8080" if running on your Mac
    private let baseURL = URL(string: "https://empty-times-march.loca.lt")!

    private let decoder: JSONDecoder

    private init() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        df.timeZone = TimeZone(secondsFromGMT: 0)

        let dfWithMicros = DateFormatter()
        dfWithMicros.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dfWithMicros.timeZone = TimeZone(secondsFromGMT: 0)

        decoder = JSONDecoder()
        // Try the microsecond format first, fall back to seconds-only
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            if let date = dfWithMicros.date(from: string) ?? df.date(from: string) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid date format: \(string)"
                )
            }
        }
    }

    func fetchTrips(limit: Int = 20, offset: Int = 0) async throws -> [TripDTO] {
        var components = URLComponents(url: baseURL.appendingPathComponent("trips"),
                                       resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]

        guard let url = components?.url else {
            throw TravelReadyAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let apiToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyXzEyMyIsImVtYWlsIjoidXNlckBleGFtcGxlLmNvbSIsImV4cCI6MTc2MzY5MTcyOX0.KSifTYuuYZk2WBOcbQfILaWuKyNXwCOh0olBCHgQIow"


        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse,
           !(200..<300).contains(http.statusCode) {
            throw TravelReadyAPIError.badStatusCode(http.statusCode)
        }

        let decoded = try decoder.decode(TripsResponseDTO.self, from: data)
        return decoded.items
    }
}
