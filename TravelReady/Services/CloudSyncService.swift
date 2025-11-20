import Foundation
import CloudKit
import Combine
import SwiftData

protocol CloudSyncing {
    func syncTrips(_ trips: [Trip]) async throws
    func fetchTrips() async throws -> [Trip]
}

final class CloudSyncService: CloudSyncing {
    static let shared = CloudSyncService()

    private let privateDB = CKContainer.default().privateCloudDatabase

    private init() {}

    func syncTrips(_ trips: [Trip]) async throws {
        // TODO: Map Trip/ChecklistItem/ChecklistCategory to CKRecord
        // For now this is a stub for architectural wiring.
    }

    func fetchTrips() async throws -> [Trip] {
        // TODO: Implement CloudKit query → SwiftData mapping
        return []
    }
}
