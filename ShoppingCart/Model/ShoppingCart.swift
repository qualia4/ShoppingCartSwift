import Foundation

final class ShoppingCart {
    private(set) var items: [Item] = []
    private var appliedCoupons: [Coupon] = []

    func addItem(_ item: Item) {
        items.append(item)
    }

    func removeItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.name == item.name && $0.price == item.price }) {
            items.remove(at: index)
        }
    }

    func calculateTotalPrice() -> Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    @discardableResult
    func applyCoupon(_ coupon: Coupon) -> Bool {
        if appliedCoupons.contains(where: { $0.code == coupon.code }) || !coupon.canBeApplied() {
            return false
        }
        appliedCoupons.append(coupon)
        return true
    }

    func calculateFinalPrice() -> Double {
        let totalPrice = calculateTotalPrice()
        var remainingPrice = totalPrice

        for coupon in appliedCoupons {
            if let discount = coupon.apply(to: remainingPrice) {
                remainingPrice -= discount
                coupon.incrementUsage()
            }
        }

        return max(remainingPrice, 0)
    }
}
