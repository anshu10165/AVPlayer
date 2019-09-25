import Foundation

class CatgoriesRequest {
    var videoCategories: [VideoCategories] {
        if let url = Bundle.main.url(forResource: "VideoDataSource", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([VideoCategories].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
}
