// To parse the JSON, add this file to your project and do:
//
//   let concertInfo = try? newJSONDecoder().decode(ConcertInfo.self, from: jsonData)

import Foundation

typealias ConcertInfo = [ConcertInfoElement]

struct ConcertInfoElement: Codable {
    let title, tag: String
    let link: String
    let imageURL: String
    let startDate, endDate: String
    
    enum CodingKeys: String, CodingKey {
        case title, tag, link
        case imageURL = "image url"
        case startDate = "start date"
        case endDate = "end date"
    }
}
