import Foundation

final class Item {
    let name: String
    let price: Double
    let quantity: Int
    
    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}
