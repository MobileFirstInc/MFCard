//
//  CardDemoVc.swift
//  MFCardDemo
//
//  Created by MobileFirst Applications on 08/12/16.
//  Copyright © 2016 MobileFirst Applications. All rights reserved.
//

import UIKit
import MFCard
class CardDemoVc: UIViewController,MFCardDelegate {

    @IBOutlet weak var creditCard: MFCardView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // creditCard.flipOnDone = true
        creditCard.autoDismiss = true
        creditCard.toast = false
        creditCard.delegate = self
        creditCard.controlButtonsRadius = 5
        creditCard.cardRadius = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        if error == nil{
            print(card!)
            let cardNumber = card?.number!
                self.view.makeToast("\(cardNumber!) Card added")
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
    func cardDidClose() {
        print("Card Close")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
