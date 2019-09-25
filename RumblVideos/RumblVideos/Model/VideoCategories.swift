import Foundation

struct VideoCategories: Decodable {
    let title: String
    let nodes: [Nodes]
}

struct Nodes: Decodable {
    let video: [String: String]
}
