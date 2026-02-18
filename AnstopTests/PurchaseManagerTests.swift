import XCTest
@testable import Anstop

final class PurchaseManagerTests: XCTestCase {
    func test_isPremium_falseWhenNoPurchasedProducts() async {
        await MainActor.run {
            let manager = PurchaseManager(autoStart: false)
            manager.purchasedProductIDs = []

            XCTAssertFalse(manager.isPremium)
        }
    }

    func test_isPremium_trueWhenAtLeastOneProductPurchased() async {
        await MainActor.run {
            let manager = PurchaseManager(autoStart: false)
            manager.purchasedProductIDs = ["premium.monthly"]

            XCTAssertTrue(manager.isPremium)
        }
    }

    func test_autoStartFalse_doesNotSetLoadingOrProductsByDefault() async {
        await MainActor.run {
            let manager = PurchaseManager(autoStart: false)

            XCTAssertFalse(manager.isLoading)
            XCTAssertTrue(manager.products.isEmpty)
        }
    }
}
