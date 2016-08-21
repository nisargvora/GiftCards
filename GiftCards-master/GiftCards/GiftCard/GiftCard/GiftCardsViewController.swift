//
//  GiftCardsViewController.swift
//  GiftCard
//
//  Created by Nisarg Vora on 8/18/16.
//  Copyright © 2016 Nisarg Vora. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cardCell"

class GiftCardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var giftCardsData : [GiftCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(172,220)
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        
        refresh()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        getGiftCardData();
        refresh()
    }
    
    func getGiftCardData() {
        let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJTSEEyNTYifQ==.dWxoWjJUbjlybTZzT0hHWk83Q082dWR4YTZXVlEvVWJUbzdnMzNoQzJ0dEVhbFVtaFo3cHA5SmxPcVEwM0JIUVZqQk5COVVQNVpzV242T01NZFU5ZEgvRE1BK2IrNzJTckd5ZWVmMTFsZGVGSjZIK05ySEF5a09oSm9XOWtPdnc=.oE9jN2HT4WmtSKyCU5rdQNf1y/NXQvt3iN+3mEr1i9I="
        let url = NSURL(string: "https://testbedapp.giftbit.com/papi/v1/marketplace?limit=100")!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let response = response, data = data {
                print(response)
                self.giftCardsData = self.parseJsonData(data)
            } else {
                print(error)
            }
        }
        print(self.giftCardsData)
        task.resume()
    }
    
    func parseJsonData(data: NSData) -> [GiftCard] {
        var giftCardsArray : [GiftCard] = Array()
        var jsonObject : [String: AnyObject]!

        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject];
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }

        if let cardsArray = jsonObject["marketplace_gifts"] as? [[String: AnyObject]] {
            for card in cardsArray {
                let giftCard : GiftCard = GiftCard.init(dict: card)!
                giftCardsArray.append(giftCard)
            }
        }
        dispatch_async(dispatch_get_main_queue(), refresh)
        return giftCardsArray
    }
    
    func refresh()
    {
        self.collectionView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "giftCardSegue") {
            let indexPath = self.collectionView.indexPathsForSelectedItems()?.last
            let giftCardDetailsViewController = segue.destinationViewController as! GiftDetailsViewController
            giftCardDetailsViewController.giftCardDetails = giftCardsData[(indexPath?.item)!]
        }
    }

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.giftCardsData.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GiftCardCell
        if giftCardsData[indexPath.item].image_url != nil {
            loadCellImage(giftCardsData[indexPath.item].image_url!, cell: cell)
        }
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
    
        cell.cardName.text = giftCardsData[indexPath.item].name
        return cell
    }
    
    func loadCellImage(urlString:String, cell:GiftCardCell)
    {
        
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            guard let data = data where error == nil else { return }
            dispatch_async(dispatch_get_main_queue(), {
                cell.cardImageView.image = UIImage(data: data)
            })
        }).resume()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
