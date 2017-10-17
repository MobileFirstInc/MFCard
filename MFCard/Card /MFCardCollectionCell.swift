//
//  MFCardCollectionCell.swift
//  MFCardDemo
//
//  Created by MobileFirst Applications on 17/05/17.
//  Copyright © 2017 MobileFirst Applications. All rights reserved.
//

import UIKit

class MFCardCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var chromeView: UIView!
    
    @IBOutlet weak var txtHolderName: UITextField!
    @IBOutlet weak var txtCardNoP1: UITextField!
    @IBOutlet weak var txtCardNoP2: UITextField!
    @IBOutlet weak var txtCardNoP3: UITextField!
    @IBOutlet weak var txtCardNoP4: UITextField!
    
    @IBOutlet weak var widthConstraints: NSLayoutConstraint!
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
        
    @IBOutlet fileprivate var cardLabels: [UILabel]!
    @IBOutlet weak var imgCardType: UIImageView!
    
    @IBOutlet weak fileprivate var viewExpiryMonth: LBZSpinner!
    @IBOutlet weak fileprivate var viewExpiryYear: LBZSpinner!
 
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    


}
