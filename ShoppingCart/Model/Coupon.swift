import Foundation

final class Coupon {
    let code: String
    let discountPercentage: Double
    let maxDiscount: Double
    var usageLimit: Int
    private(set) var usageCount: Int = 0

    init(code: String, discountPercentage: Double, maxDiscount: Double, usageLimit: Int) {
        self.code = code
        self.discountPercentage = discountPercentage
        self.maxDiscount = maxDiscount
        self.usageLimit = usageLimit
    }

    func apply(to total: Double) -> Double? {
        guard canBeApplied() else { return nil }
        if(total < maxDiscount){
            return 0
        }
        let discount = min(total * (discountPercentage / 100), maxDiscount)
        return discount > 0 ? discount : nil
    }

    func canBeApplied() -> Bool {
        usageCount < usageLimit
    }

    func incrementUsage() {
        usageCount += 1
    }
}




