//
//  InitialViewController.swift
//  Mr Market
//
//  Created by Carlos Rogelio Villanueva Ousset on 8/20/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit
import StoreKit

// Global but private (Works like a static variable in objective-c). To avoid a "wall of sound" or many copies of the same music
private var backgroundMusicPlayer: AVAudioPlayer!

class InitialViewController: UIViewController, GKGameCenterControllerDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate
{
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var removeAdsButton: UIButton!
    
    // Game Center
    var isGameCenterEnabled = false
    
    // iAd

    
    // In-App Purchases
    var product: SKProduct?
    var waitingForProduct = false
    
    // Background music
    private var musicOn: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.MusicOn)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: UserDefaultsKey.MusicOn)
            if newValue {
                if !backgroundMusicPlayer.playing { backgroundMusicPlayer.play() }
            } else {
                if backgroundMusicPlayer.playing { backgroundMusicPlayer.stop() }
            }
        }
    }
    
    private var showAds: Bool {
        get { return NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.ShowAds) }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: UserDefaultsKey.ShowAds)
            if !newValue {
                removeAdsButton.hidden = true
                canDisplayBannerAds = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        interstitialPresentationPolicy = .Manual
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // game center
        authenticatePlayer()
        
        // ad banner
        canDisplayBannerAds = showAds
        
        // in-app purchases
        removeAdsButton.hidden = !showAds
        
        if showAds {
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
            getProductInfo()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        audioSetup()
        updateUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if showAds {
            requestInterstitialAdPresentation()
        }
    }
    
    // MARK: Setup
    
    private func updateUI()
    {
        // Music On/Off Button
        let musicOn = NSUserDefaults.standardUserDefaults().boolForKey(UserDefaultsKey.MusicOn)
        let musicOnImage = UIImage(named: musicOn ? Filename.MusicOn : Filename.MusicOff)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        musicOnButton.setImage(UIImage(named: musicOn ? Filename.MusicOn : Filename.MusicOff), forState: UIControlState.Normal)
    }
    
    @IBOutlet weak var musicOnButton: UIButton!
    @IBAction func musicOnButtonPressed(sender: AnyObject) {
        musicOn = !musicOn
        updateUI()
    }
    
    private func audioSetup()
    {
        // setup background music
        if backgroundMusicPlayer == nil {
            if let backgroundMusicURL = NSBundle.mainBundle().URLForResource(Filename.BackgroundMusicInitial, withExtension: nil) {
                backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: nil)
                backgroundMusicPlayer.numberOfLoops = -1
            }
        }
        if !backgroundMusicPlayer.playing && musicOn {
            backgroundMusicPlayer.play()
        }
    }
    
    
    // MARK: Navigation
    @IBAction func unwindToInitialViewController(segue: UIStoryboardSegue)
    {
        if let segueName = segue.identifier {
            switch segueName {
            case SegueId.RemoveAds:
                removeAds()
            default:
                break
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueId = segue.identifier {
            switch segueId {
            case SegueId.StartGame:
                backgroundMusicPlayer.stop()
                backgroundMusicPlayer = nil
            default:
                break
            }
        }
    }
    
    // MARK: Game Center
    
    func authenticatePlayer()
    {
        if let localPlayer = GKLocalPlayer.localPlayer() {
            // Assigning a block to the localPlayer's
            // authenticateHandler kicks off the process
            // of authenticating the user with Game Center.
            localPlayer.authenticateHandler = { (viewController, error) in
                
                if viewController != nil {
                    // We need to present a view controller
                    // to finish the authentication process
                    self.presentViewController(viewController, animated: true, completion: nil)
                    
                } else if localPlayer.authenticated {
                    // We're authenticated, and can now use Game Center features
                    println("Authenticated")
                    self.isGameCenterEnabled = true
                    
                } else if let theError = error {
                    // We're not authenticated.
                    println("Error! \(theError)")
                    self.isGameCenterEnabled = false
                }
                
            }
        }
    }
    
    @IBAction func leaderboardButtonPressed(sender: AnyObject)
    {
        var gameCenterViewController: GKGameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        gameCenterViewController.leaderboardIdentifier = GameCenter.LeaderboardId
        self.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: In-App Purchases
    
    @IBAction func removeAdsButtonPressed(sender: AnyObject) {
        
        var alertMessage: String?
        if product != nil{
            let numberFormatter = NSNumberFormatter()
            numberFormatter.locale = product!.priceLocale
            numberFormatter.numberStyle = .CurrencyStyle
            alertMessage = numberFormatter.stringFromNumber(NSNumber(double: Double(product!.price)))
        }
        
        let removeAdsActionSheet = UIAlertController(title: Text.RemoveAds, message: alertMessage, preferredStyle: .ActionSheet)
        
        let purchaseAction = UIAlertAction(title: Text.Purchase, style: .Default) { (action:UIAlertAction!) in
            self.removeAds()
        }
        let restorePurchaseAction = UIAlertAction(title: Text.Restore, style: .Default) { (action: UIAlertAction!) in
            self.restorePurchases()
        }
        let cancelAction = UIAlertAction(title: Text.Cancel, style: .Cancel, handler: nil)
        removeAdsActionSheet.addAction(purchaseAction)
        removeAdsActionSheet.addAction(restorePurchaseAction)
        removeAdsActionSheet.addAction(cancelAction)
        presentViewController(removeAdsActionSheet, animated: true, completion: nil)
    }
    
    private func removeAds()
    {
        if !showAds { return }
        
        if product != nil {
            let payment = SKPayment(product: product)
            SKPaymentQueue.defaultQueue().addPayment(payment)
        } else {
            waitingForProduct = true
            getProductInfo()
        }
    }
    
    private func restorePurchases() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    func getProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: InAppPurchase.RemoveAdsProductId) as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            println("Please enable In App Purchase in Settings")
        }
    }
    
    // SKProduct request delegate
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var products = response.products
        if (products.count > 0) {
            product = products[0] as? SKProduct
            if waitingForProduct {
                waitingForProduct = false
                removeAds()
            }
        }
        
        for product in response.invalidProductIdentifiers {
            println("Product not found: \(product)")
        }
    }
    
    // SKPayment transaction delegate
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction in transactions as! [SKPaymentTransaction] {
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
            case SKPaymentTransactionState.Restored:
                fallthrough
                
            case SKPaymentTransactionState.Purchased:
                showAds = false
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
            default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        //called when the user successfully restores a purchase
        var itemsRestored = false
        for transaction in queue.transactions {
            if transaction.transactionState == SKPaymentTransactionState.Restored {
                itemsRestored = true
            }
        }
        let restoredTitle = itemsRestored ? Text.PurchasesRestored : Text.NoPreviousPurchases
        let restoredAlertController = UIAlertController(title: restoredTitle, message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: Text.Ok, style: .Default, handler: nil)
    }

    
    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) {
        let failToRestoreAlert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: Text.Ok, style: .Default, handler: nil)
        failToRestoreAlert.addAction(okAction)
        presentViewController(failToRestoreAlert, animated: true, completion: nil)
    }



    
    
    
    
    
    
    
}
