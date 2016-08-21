//
//  GiftDetailsViewController.swift
//  GiftCard
//
//  Created by Nisarg Vora on 8/18/16.
//  Copyright © 2016 Nisarg Vora. All rights reserved.
//

import UIKit

class GiftDetailsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var giftCardImage: UIImageView!
    @IBOutlet weak var giftCardImageBackgroundView: UIView!
    @IBOutlet weak var useRewardsCheck: UIButton!
    @IBOutlet weak var amountChooser: UISegmentedControl!
    @IBOutlet weak var rewardsAmountField: UITextField!
    @IBOutlet weak var sendByEmailCheck: UIButton!
    @IBOutlet weak var giftCardDetailsBackgroundView: UIView!
    @IBOutlet weak var recipientNameField: UITextField!
    @IBOutlet weak var recipientEmailField: UITextField!
    @IBOutlet weak var purchaseButton: UIButton!
    
    var giftCardDetails : GiftCard?
    @IBOutlet weak var hiddenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGiftCardImage(giftCardDetails!.image_url!)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setupInputFields(self.recipientNameField)
        setupInputFields(self.recipientEmailField)
        setupInputFields(self.rewardsAmountField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGiftCardImage(urlString : String) {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            guard let data = data where error == nil else { return }
            dispatch_async(dispatch_get_main_queue(), {
                self.giftCardImage.image = UIImage(data: data)
            })
        }).resume()
    }
    
    func setupUI() {
        self.giftCardDetailsBackgroundView.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
        self.giftCardDetailsBackgroundView.layer.borderWidth = 1
        
        self.purchaseButton.layer.backgroundColor = UIColor(red:0.16, green:0.7, blue:0.9, alpha:1).CGColor
        self.purchaseButton.layer.borderWidth = 1
        self.purchaseButton.layer.borderColor = UIColor(red:0, green:0.62, blue:0.87, alpha:1).CGColor
        
        applyLineEffect(giftCardDetailsBackgroundView)
        
    }
    
    func setupInputFields(textField: UITextField) {
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.None
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func applyLineEffect(givenView: UIView) {
        let width = givenView.frame.size.width
        let height = givenView.frame.size.height
        
        let lineWidth = CGFloat(7)
        let lineHeight = CGFloat(-5)
        let yInitial = height-lineHeight 
        
        let zigZagPath = UIBezierPath()
        zigZagPath.moveToPoint(CGPointMake(0, 0))
        zigZagPath.addLineToPoint(CGPointMake(0, yInitial))
        
        var slope = -1
        var x = CGFloat(0)
        var i = 0
        while x < width {
            x = lineWidth * CGFloat(i)
            let p = lineHeight * CGFloat(slope)
            let y = yInitial + p
            let point = CGPointMake(x, y)
            zigZagPath.addLineToPoint(point)
            slope = slope*(-1)
            i += 1
        }
        zigZagPath.addLineToPoint(CGPointMake(width, 0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = zigZagPath.CGPath
        givenView.layer.mask = shapeLayer
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let purchaseInfo = PurchaseInfo()
        purchaseInfo.emailSelected = self.sendByEmailCheck.selected
        purchaseInfo.rewardsSelected = self.useRewardsCheck.selected
        purchaseInfo.giftCardDetails = self.giftCardDetails
        purchaseInfo.rewardsAmount = self.rewardsAmountField.text
        if self.amountChooser.selectedSegmentIndex != -1 {
            purchaseInfo.giftCardAmount = self.amountChooser.titleForSegmentAtIndex(self.amountChooser.selectedSegmentIndex)
        }
        let confirmationViewController = segue.destinationViewController as! ConfirmationViewController
        confirmationViewController.purchaseConfirmationInfo = purchaseInfo
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if self.amountChooser.selectedSegmentIndex == -1 {
            self.amountChooser.tintColor = UIColor.redColor()
            return false
        }
        self.amountChooser.tintColor = UIColor(red:0.16, green:0.61, blue:0.85, alpha:1)
        return true
    }
    
    @IBAction func useRewardsToggle(sender: AnyObject) {
        self.useRewardsCheck.selected = !self.useRewardsCheck.selected
        if self.useRewardsCheck.selected {
            self.rewardsAmountField.hidden = false
        } else {
            self.rewardsAmountField.hidden = true
        }
    }
    
    @IBAction func checkSentByEmailToggle(sender: AnyObject) {
        self.sendByEmailCheck.selected = !self.sendByEmailCheck.selected
        if self.sendByEmailCheck.selected {
            self.hiddenView.hidden = false
        } else {
            self.hiddenView.hidden = true
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
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
