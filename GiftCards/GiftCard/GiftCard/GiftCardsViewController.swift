//
//  GiftCardsViewController.swift
//  GiftCard
//
//  Created by Nisarg Vora on 8/16/16.
//  Copyright © 2016 Nisarg Vora. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GiftCardsViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        getGiftCardData();

        // Do any additional setup after loading the view.
    }
    
    func getGiftCardData() {
        var giftCardsData : [GiftCard]?
        let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJTSEEyNTYifQ==.dWxoWjJUbjlybTZzT0hHWk83Q082dWR4YTZXVlEvVWJUbzdnMzNoQzJ0dEVhbFVtaFo3cHA5SmxPcVEwM0JIUVZqQk5COVVQNVpzV242T01NZFU5ZEgvRE1BK2IrNzJTckd5ZWVmMTFsZGVGSjZIK05ySEF5a09oSm9XOWtPdnc=.oE9jN2HT4WmtSKyCU5rdQNf1y/NXQvt3iN+3mEr1i9I="
        let url = NSURL(string: "https://testbedapp.giftbit.com/papi/v1/marketplace?limit=100")!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let response = response, data = data {
                print(response)
                giftCardsData = self.parseJsonData(data)
                //print(giftCardsData)
            } else {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func parseJsonData(data: NSData) -> [GiftCard] {
        var giftCardsArray : [GiftCard]?
        var giftCard : GiftCard?
        let jsonObject : [String: AnyObject]

        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject];
            if let cardsArray = jsonObject["marketplace_gifts"] as? NSArray {
                for cardObj in cardsArray {
                    let card = cardObj as AnyObject
                    if let cardImageURL  = card["image_url"] as? String {
                        giftCard?.vendorName = cardImageURL
                    }
                    if let cardName  = card["name"] as? String {
                        giftCard?.vendorName = cardName
                    }
                    print(card)
                    giftCardsArray?.append(giftCard!)
                    print(giftCardsArray)
                }
                
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }


        return giftCardsArray!
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
