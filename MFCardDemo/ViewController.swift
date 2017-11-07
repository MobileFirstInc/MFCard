//
//  ViewController.swift
//  MFCardDemo
//
//  Created by MobileFirst Applications on 07/12/16.
//  Copyright © 2016 MobileFirst Applications. All rights reserved.
//

import UIKit
import MFCard
class ViewController: UIViewController,MFCardDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnShowCardWithDetails(_ sender: UIButton) {
        var myCard : MFCardView
        myCard  = MFCardView(withViewController: self)
        myCard.delegate = self
        myCard.autoDismiss = true
        myCard.toast = true
        myCard.blurStyle  = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let demoCard :Card? = Card(holderName: "Rahul Chandnani", number: "6552552665526625", month: Month.Dec, year: "2019", cvc: "234", paymentType: Card.PaymentType.bank, cardType: CardType.Discover, userId: 0)
        myCard.showCardWithCardDetails(card: demoCard!)
    }

    @IBAction func btnAddCardAction(_ sender: Any) {
        var myCard : MFCardView
        myCard  = MFCardView(withViewController: self)
        myCard.delegate = self
        myCard.autoDismiss = true
        myCard.toast = true
        myCard.blurStyle  = UIBlurEffect(style: UIBlurEffectStyle.light)
        myCard.showCard()
    }
    
    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        if error == nil{
            print(card!)
        }else{
            print(error!)
        }
    }
    
    func cardTypeDidIdentify(_ cardType: String) {
        print(cardType)
        
        // Notes - 
        
        // You can change Card background and other parameters once Card Type is identified 
        // e.g - myCard?.cardImage  will help set Card Image
    }
    
   

}

