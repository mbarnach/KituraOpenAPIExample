import Foundation
import KituraContracts

struct Book: Codable, Identifier {
    let id: Int
    var value: String { "\(id)" }
    let title: String
    let price: Double
    let genre: String

    init(id: Int, title: String, price: Double, genre: String) {
        self.id = id
        self.title = title
        self.price = price
        self.genre = genre
    }
 
    public init(value: String) throws {
        if let id = Int(value) {
            self.id = id
        } else {
            throw IdentifierError.invalidValue
        }
        self.title = ""
        self.price = 0.0
        self.genre = ""
    }
}