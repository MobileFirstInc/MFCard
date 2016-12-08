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
    var myCard : MFCardView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnAddCardAction(_ sender: Any) {
        myCard  = MFCardView(withViewController: self)
        myCard?.delegate = self
        //myCard?.autoDismiss = true
        myCard?.toast = true
        myCard?.showCard()
        
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

