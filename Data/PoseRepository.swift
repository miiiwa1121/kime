import Foundation

protocol PoseRepository {
    func loadAll() throws -> [Pose]
}
