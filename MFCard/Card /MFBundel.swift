//
//  MFBundel.swift
//  MFCard
//
//  Created by Rahul Chandnani on 17/10/17.
//  Copyright © 2017 MobileFirst Applications. All rights reserved.
//

import Foundation
class MFBundel: NSObject {
    class func getBundle() -> Bundle {
        let mfBundel:Bundle?
        let podBundle = Bundle(for: MFCardView.self)
        let bundleURL = podBundle.url(forResource: "MFCard", withExtension: "bundle")
        if bundleURL == nil{
            mfBundel = podBundle
        }else{
            mfBundel = Bundle(url: bundleURL!)!
        }
        return mfBundel!
    }
}
