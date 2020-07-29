//
//  MFCardCollection.swift
//  MFCardDemo
//
//  Created by MobileFirst Applications on 17/05/17.
//  Copyright © 2017 MobileFirst Applications. All rights reserved.
//

import UIKit

public class MFCardCollection: UIView {

    public enum CardAnimation{
        case ZoomInOut
        case LinearCard
    }
    
    weak fileprivate var rootViewController: UIViewController!
    fileprivate var blurEffectView:UIVisualEffectView!
    fileprivate let reuseIdentifier = "MFCardCollectionCell"
    fileprivate var cardCollection :[Card] = []
    fileprivate var mfBundel :Bundle? = Bundle()
    fileprivate var isEditing = false
    
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var collection:UICollectionView?
    public var closeButton:UIButton = UIButton()
    public var topDistance = 200
    public var animationStyle:CardAnimation = CardAnimation.LinearCard
    fileprivate var isiPhone5WithZoomAnimation = false
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    // MARK:-
    // MARK: initialization
    // MARK:-
    
    open override func draw(_ rect: CGRect) {
        // Drawing code
        //UIApplication.topViewController()?.view.frame
    }
    
    public init(withViewController:UIViewController) {
        super.init(frame: withViewController.view.frame)
        rootViewController = withViewController
        setUp()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:-
    // MARK: SetUP Methods
    // MARK:-
    func setUp(){
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5 // blur effect alpha
        blurEffectView.frame = rootViewController.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootViewController.view.addSubview(blurEffectView)
        switch animationStyle {
        case .LinearCard:
            animator =  (LinearCardAttributesAnimator(), false, 1, 1)
            break
        case .ZoomInOut:
            animator =  (ZoomInOutAttributesAnimator(), false, 1, 1)
            break
            
        }
        let direction: UICollectionView.ScrollDirection = .horizontal
        collection?.isPagingEnabled = true
        
        let layout =  AnimatedCollectionViewLayout()
        layout.scrollDirection = direction
        layout.animator = animator?.0
        
        collection = UICollectionView(frame: CGRect(x: 10, y: topDistance, width: Int(self.frame.size.width), height: 320), collectionViewLayout: layout)
        
        // center layer horizontally in self.view
        self.addConstraint(NSLayoutConstraint(item: collection!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0));
        
        // center layer vertically in self.view
        self.addConstraint(NSLayoutConstraint(item: collection!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0.0));
        
        collection?.register(UINib(nibName:"MFCardCollectionCell", bundle: getBundle()), forCellWithReuseIdentifier: reuseIdentifier)
        collection?.delegate = self
        collection?.dataSource = self
        self.addSubview(collection!)
        collection?.backgroundColor = UIColor.clear
        collection?.reloadData()
        closeButton.frame = CGRect(x: self.frame.width-70, y: 32, width: 35, height: 35)
        self.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        // align layer from the right
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-\(20)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": closeButton]));
        
        // align layer from the top
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(closeButton.frame.origin.y)-[view]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": closeButton]));
        
        // width constraint
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==\(closeButton.frame.height))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": closeButton]));
        
        // height constraint
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==\(closeButton.frame.width))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": closeButton]));
        closeButton.addTarget(self, action:#selector(closeCollection(sender:)), for: .touchUpInside)
        closeButton.setTitle("X", for: .normal)
        closeButton.backgroundColor = UIColor.red
        closeButton.bringSubviewToFront(collection!)
        self.layoutIfNeeded()
        //collection?.isPagingEnabled = true
        collection?.showsVerticalScrollIndicator = false
        collection?.showsHorizontalScrollIndicator = false
        if self.frame.width<330 && animationStyle == CardAnimation.ZoomInOut {
            isiPhone5WithZoomAnimation = true
        }
        
        // Add LongPressGesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        collection?.addGestureRecognizer(longPress)

    }
    
    fileprivate func getBundle() -> Bundle {
        mfBundel = MFBundel.getBundle()
        return mfBundel!
    }
    
    // MARK:-
    // MARK: Helping Methods
    // MARK:-
    
    public func presentCollection(for cards:[Card]){
        cardCollection = cards
        rootViewController.view.addSubview(self)
        collection?.reloadData()
        animateCard()
    }
    
    
    fileprivate func animateCard() {
        collection?.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            self.collection?.alpha = 1
        }, completion: nil)
    }
    
    // MARK:-
    // MARK: IBAction
    // MARK:-
    
    @objc func closeCollection(sender:UIButton){
        collection?.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.collection?.alpha = 0
        }, completion: { finished in
            self.removeFromSuperview()
            if self.blurEffectView != nil{
                self.blurEffectView.removeFromSuperview()
            }
        })
    }

    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: collection)
            if (collection?.indexPathForItem(at: touchPoint)) != nil {
                isEditing = true
                collection?.reloadData()
            }
        }
    }
    
}

// MARK:-
// MARK: UICollectionViewDelegate Methods
// MARK:-

extension MFCardCollection : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    // MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    public  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cardCollection.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MFCardCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MFCardCollectionCell
        
        // Configure the cell
        if isiPhone5WithZoomAnimation {
            cell.widthConstraints?.constant = 250
            cell.heightConstraints.constant = 171
            cell.layoutIfNeeded()
        }
        cell.txtHolderName.text = cardCollection[indexPath.item].name
        if isEditing {
            RCAnimation.vibrateAnimation(cell)
            cell.btnLeft.isHidden = false
            cell.btnRight.isHidden = false
        }else{
            cell.btnLeft.isHidden = true
            cell.btnRight.isHidden = true
        }
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing {
            isEditing = false
            collection?.reloadData()
        }
        
//        if let cell:MFCardCollectionCell = collectionView.cellForItem(at: indexPath) as? MFCardCollectionCell{
//            RCAnimation.pushAnimation(cell)
//        }
    }
   public  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
    
   public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if isiPhone5WithZoomAnimation{
            return UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 20)
        }else{
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
   public  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isiPhone5WithZoomAnimation{
            return -30
        }else{
            return 20
        }
    }
    
   public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

}
