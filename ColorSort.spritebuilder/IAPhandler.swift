//
//  IAPhandler.swift
//  ColorSort
//
//  Created by Ikey Benzaken on 8/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import StoreKit

protocol InAppPurchasesDelegate {
    func initializingIAP(IAPisInitializing: Bool)
    func IAPFinished(IAPFinishedInitializing: Bool, swipesWerePurchased: Bool)
}

class InAppPurchases: SKProductsRequest, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    var IAPdelegate: InAppPurchasesDelegate!
    
    func attemptPurchase(productName: String) {
        if (SKPaymentQueue.canMakePayments()) {
            var productID:NSSet = NSSet(object: productName)
            var productRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
            productRequest.delegate = self
            productRequest.start()
            IAPdelegate.initializingIAP(true)
        } else {
            let alert = UIAlertView()
            alert.title = "Purchase failed"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    // SKProductsRequestDelegate method
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var count: Int = response.products.count
        if (count > 0) {
            var validProducts = response.products
            var product = validProducts[0] as! SKProduct
            buyProduct(product)
        } else {
            //something went wrong with lookup, try again?
        }
    }
    
    //called after delegate method productRequest
    func buyProduct(product: SKProduct) {
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    //SKPaymentTransactionObserver method
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("recieved response")
        for transaction: AnyObject in transactions {
            if let tx: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch tx.transactionState {
                case .Purchased:
                    println("product purchased")
                    GameStateSingleton.sharedInstance.swipesLeft += 25
                    IAPdelegate.IAPFinished(true, swipesWerePurchased: true)
                    queue.finishTransaction(tx)
                case .Failed:
                    println("oops, purchase failed!")
                    IAPdelegate.IAPFinished(true, swipesWerePurchased: false)
                    queue.finishTransaction(tx)
                    let alert = UIAlertView()
                    alert.title = "Purchase failed"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                case .Purchasing, .Deferred:
                    println("waiting for completion...")
                case .Restored:
                    println("Product restored")
                }
            }
        }
    }
    
    class var sharedInstance : InAppPurchases {
        struct Static {
            static let instance : InAppPurchases = InAppPurchases()
        }
        return Static.instance
    }
    
}