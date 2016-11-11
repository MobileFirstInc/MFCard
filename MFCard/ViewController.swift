//
//  ViewController.swift
//  MFCard
//
//  Created by MobileFirst Applications on 03/11/16.
//  Copyright © 2016 MobileFirst Applications. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MFCardDelegate{
    
    @IBOutlet weak var viewCreaditCard: MFCardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewCreaditCard.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func cardDoneButtonClicked(card: Card?, error: String?) {
        print(card!)
        print(error!)
    }

}

//
