//
//  ConfirmationViewController.swift
//  GiftCard
//
//  Created by Nisarg Vora on 8/19/16.
//  Copyright © 2016 Nisarg Vora. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    var purchaseConfirmationInfo : PurchaseInfo?
    
    @IBOutlet weak var balanceValue: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var walletIconView: UIImageView!
    @IBOutlet weak var addToWalletLabel: UIButton!
    @IBOutlet weak var rewardsValueLabel: UILabel!
    @IBOutlet weak var detailBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.detailBackgroundView.layer.borderWidth = 1
        self.detailBackgroundView.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
        
        setupGiftCardImage((self.purchaseConfirmationInfo?.giftCardDetails?.image_url)!)
        self.cardImage.layer.cornerRadius = 5
        self.cardImage.clipsToBounds = true
        self.cardImage.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
        self.cardImage.layer.borderWidth = 1
        
        self.balanceValue.text = "\((self.purchaseConfirmationInfo?.giftCardAmount)!).00"
        if (self.purchaseConfirmationInfo?.rewardsAmount)! != "" {
            self.rewardsValueLabel.text = "\((self.purchaseConfirmationInfo?.rewardsAmount)!) points spent"
        }
    }
    
    func setupGiftCardImage(urlString : String) {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            guard let data = data where error == nil else { return }
            dispatch_async(dispatch_get_main_queue(), {
                self.cardImage.image = UIImage(data: data)
            })
        }).resume()
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func addToWalletAction() {
        self.addToWalletLabel.titleLabel!.textColor = UIColor(red:0.29, green:0.95, blue:0.63, alpha:1)
        self.addToWalletLabel.setTitle("Added!!!", forState: UIControlState.Normal)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
