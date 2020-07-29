//
//  MFCardView.swift
//  MFCard
//
//  Created by MobileFirst Applications on 03/11/16.
//  Copyright © 2016 MobileFirst Applications. All rights reserved.
//

import UIKit

// MARK: - MFCard Protocol
// MARK:-
public protocol MFCardDelegate {
    func cardDoneButtonClicked(_ card:Card?, error:String?)
    func cardTypeDidIdentify(_ cardType :String)
}

extension MFCardDelegate{
    func cardTypeDidIdentify(_ cardType :String){
    }
}

// MARK
// MARK: - MFCardView
// MARK:-
@IBDesignable public class MFCardView: UIView {
    
    public var delegate :MFCardDelegate?
    fileprivate var addedCardType: CardType?
    fileprivate var error :String? = String()
    fileprivate var mfBundel :Bundle? = Bundle()
    fileprivate var containerView = UIView()
    fileprivate var topConstraints:[NSLayoutConstraint]?
    
    @IBOutlet fileprivate var view: UIView!
    @IBOutlet weak fileprivate var cardBackView: UIView!
    @IBOutlet weak fileprivate var cardFrontView: UIView!
    @IBOutlet weak fileprivate var backChromeView: UIView!
    @IBOutlet weak fileprivate var magneticTapeView: UIView!
    @IBOutlet weak fileprivate var frontChromeView: UIView!
    
    @IBOutlet weak fileprivate var txtCvc: UITextField!
    @IBOutlet weak fileprivate var txtCardName: UITextField!
    @IBOutlet weak fileprivate var txtCardNoP1: UITextField!
    @IBOutlet weak fileprivate var txtCardNoP2: UITextField!
    @IBOutlet weak fileprivate var txtCardNoP3: UITextField!
    @IBOutlet weak fileprivate var txtCardNoP4: UITextField!
    
    @IBOutlet weak fileprivate var frontCardImage: UIImageView!
    @IBOutlet weak fileprivate var cardTypeImage: UIImageView!
    
    @IBOutlet weak fileprivate var viewExpiryMonth: LBZSpinner!
    @IBOutlet weak fileprivate var viewExpiryYear: LBZSpinner!
    
    
    @IBOutlet weak fileprivate var btnCvc: UIButton!
    @IBOutlet weak fileprivate var btnDone: UIButton!
    
    @IBOutlet weak fileprivate var controlView: UIView!
    @IBOutlet weak fileprivate var viewFrontContainer: UIView!
    @IBOutlet weak fileprivate var viewBackContainer: UIView!
    
    @IBOutlet fileprivate var cardLabels: [UILabel]!
    fileprivate var cardTextFields:[UITextField]!

    weak fileprivate var rootViewController: UIViewController!
    fileprivate var blurEffectView:UIVisualEffectView!

    fileprivate var nibName: String = "MFCardView"
    public var autoDismiss = false
    public var flipOnDone = false
    public var toast = true
    public var topDistance = 100
    
    // MARK:-
    // MARK: initialization
    // MARK:-
    public init(withViewController:UIViewController) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 240))
        rootViewController = withViewController
        setup()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupUI()
    }
    
    // MARK:-
    // MARK: Setup
    // MARK:-
    fileprivate func setup() {
        // 1. load a nib
        view = loadViewFromNib()
        // 2. add as subview

        self.addSubview(self.view)
                // 3. allow for autolayout
        self.view.translatesAutoresizingMaskIntoConstraints = false
        // 4. add constraints to span entire view
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": self.view!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": self.view!]))
        //Orientation Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)

        self.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
        generalSetup()
        
    }
    
    fileprivate func generalSetup(){
        //Other SetUps...
        cardTextFields = [txtCardNoP4,txtCardNoP3,txtCardNoP2,txtCardNoP1,txtCardName,txtCvc];
       btnDone.setTitle("Close", for: .normal)
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: Date())
        let year = components.year
        let expiryMonth = Month.allValues
        var expiryYear :[String] = [String]()
        var i = year! - 1
        while i <= year! + 20 {
            i = i + 1
            let yearString = String(i)
            expiryYear.append(yearString)
        }
        
        viewExpiryMonth.updateList(expiryMonth)
        viewExpiryYear.updateList(expiryYear)
        
        // LBZSpinner Delegate Bind
        viewExpiryMonth.delegate = self
        viewExpiryYear.delegate = self
        
        // Text Field Delegates
        txtCardNoP1.delegate = self
        txtCardNoP2.delegate = self
        txtCardNoP3.delegate = self
        txtCardNoP4.delegate = self
        txtCvc.delegate = self
        
        txtCardNoP1.addTarget(self, action: #selector(MFCardView.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        txtCardNoP2.addTarget(self, action: #selector(MFCardView.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        txtCardNoP3.addTarget(self, action: #selector(MFCardView.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        txtCardNoP4.addTarget(self, action: #selector(MFCardView.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        txtCvc.addTarget(self, action: #selector(MFCardView.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.flip))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.flip))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    fileprivate func setupUI(){
        self.layoutIfNeeded()
        self.backgroundColor = self.backColor
        self.btnCvc.layer.cornerRadius = self.controlButtonsRadius
        self.btnDone.layer.cornerRadius = self.controlButtonsRadius
        setCardRadius()
        self.frontChromeColor = UIColor.black
        changeFont(UIColor.white)
        changeTextFieldTextColor(UIColor.black)
        changeTextFieldColor(UIColor.white)
        if cardImageRequire == true{
            cardImage = UIImage(named: "bg", in: mfBundel!,compatibleWith: nil)
        }
        
    }
    
    public func showCard(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5 // blur effect alpha
        blurEffectView.frame = rootViewController.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootViewController.view.addSubview(blurEffectView)
        rootViewController.view.addSubview(view)
        
        // center view horizontally in rootViewController.view
        rootViewController.view.addConstraint(NSLayoutConstraint(item: view!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: rootViewController.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0));
        
        // align view from the top
        topConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(topDistance)-[view]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view!])
        rootViewController.view.addConstraints(topConstraints!);
        
        // width constraint
        rootViewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==300)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view!]));
        
        // height constraint
        rootViewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==240)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view!]));
        animateCard()
        // Animate it in
        
    }
    
    public func showCardWithCardDetails(card:Card){
        //1 Show Normal Card
        showCard()
        //2 Fill The Details
        fillTextFieldFromCard(card: card)
        //3 Change Button Title to DONE
        unHideDoneButton()
        
    }
    
    internal func fillTextFieldFromCard(card:Card){
           
           //inner Function
           func setTextField(textFileld:UITextField,value:String){
               if (textFileld.text?.count)! < 4{
                   textFileld.text = textFileld.text! + value
               }
           }
           
           // 1 set card number
           if (card.number?.count)!<6 && toast{
               UIApplication.topViewController()?.view.makeToast("Wrong card number")
           }else{
               var currenttextFileld :UITextField
               var index = 0;
               let divider = 4;
               for chara:Character in (card.number)! {
                   if index<divider {
                       currenttextFileld = txtCardNoP1
                   }else if index<divider*2{
                       currenttextFileld = txtCardNoP2
                   }else if index<divider*3{
                       currenttextFileld = txtCardNoP3
                   }else{
                       currenttextFileld = txtCardNoP4
                   }
                   setTextField(textFileld: currenttextFileld, value: "\(chara)")
                   index = index + 1
               }
           }
           // 2 set image
           addedCardType = card.cardType
           setImage((addedCardType?.rawValue)!)
           // 3 set name , month , year , cvc
           txtCardName.text = card.name
           viewExpiryMonth.text = (card.month?.rawValue)!
           viewExpiryYear.text = card.year!
           txtCvc.text = card.cvc

       }
    
    public func dismissCard() {
        let sz = screenSize()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.view.center.y = self.view.center.y + sz.height
        }, completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                self.view.alpha = 0
            }, completion: { finished in
                self.view.removeFromSuperview()
                if self.blurEffectView != nil{
                    self.blurEffectView.removeFromSuperview()

                }
            })
        })
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK:-
    // MARK: Helping Methods
    // MARK:-
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = getBundle()
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    fileprivate func getBundle() -> Bundle {
        mfBundel = MFBundel.getBundle()
        return mfBundel!
    }
    
    fileprivate func screenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return screenSize
    }
    
    fileprivate func changeFont(_ color :UIColor){
        btnDone.setTitleColor(color, for: .normal)
        btnCvc.setTitleColor(color, for: .normal)
        viewExpiryMonth.lineColor   = color
        viewExpiryYear.lineColor    = color
        for labelItem: UILabel in cardLabels{
            labelItem.textColor = color
        }
    }
    
    fileprivate func changeTextFieldColor(_ color:UIColor){
        for cardTextField: UITextField in cardTextFields{
            cardTextField.backgroundColor = color
        }
        
    }
    
    fileprivate func changeTextFieldTextColor(_ color:UIColor){
        for cardTextField: UITextField in cardTextFields{
            cardTextField.textColor = color
        }
    }
    
    fileprivate func setCardRadius(){
        
        self.cardBackView.layer.cornerRadius    = self.cardRadius
        self.backChromeView.layer.cornerRadius = self.cardRadius
        self.viewBackContainer.layer.cornerRadius = self.cardRadius
        self.viewFrontContainer.layer.cornerRadius = self.cardRadius
        self.frontChromeView.layer.cornerRadius = self.cardRadius
        self.frontCardImage.layer.cornerRadius = self.cardRadius
        self.cardFrontView.layer.cornerRadius   = self.cardRadius
    }
    
    fileprivate func setPlaceholder(_ allow:Bool){
        if allow{
            txtCvc.placeholder      = "###"
            txtCardName.placeholder = "Enter Name"
            txtCardNoP1.placeholder = "####"
            txtCardNoP2.placeholder = "####"
            txtCardNoP3.placeholder = "####"
            txtCardNoP4.placeholder = "####"
            
            //Add more Placeholder
            
        }else{
            for cardTextField: UITextField in cardTextFields{
                cardTextField.placeholder = ""
            }
        }
    }
    
    fileprivate func changeCvvTFStyle(_ secure:Bool){
        if secure{
            txtCvc.isSecureTextEntry = true
        }else{
            txtCvc.isSecureTextEntry = false
        }
    }
    
    fileprivate func imageRequire(_ require:Bool){
        if require{
            cardImage = self.frontCardImage.image
            self.frontChromeAlpha = 0.81
        }else{
            self.frontChromeAlpha = 1
            cardImage = UIImage()
        }
    }
    
    fileprivate func animateCard() {
        self.view.center.x = 0
        self.view.center.y = -500
        
        UIView.animate(withDuration: 0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.view.center = CGPoint(x: 0, y: 25)
        }, completion: { finished in
            
        })
    }
    
    @objc fileprivate func orientationDidChange(){
        if UIDevice.current.orientation.isLandscape {
            if (topConstraints != nil){
                topConstraints?[0].constant = 10
            }
            
        }
        
        if UIDevice.current.orientation.isPortrait {
            if (topConstraints != nil){
                topConstraints?[0].constant = CGFloat(topDistance)
            }
        }
    }

    // MARK:-
    // MARK: IBAction
    // MARK:-
    
    @IBAction func btnCVCAction(_ sender: AnyObject) {
        
        flip(nil)
    }
    
    @IBAction func btnDoneAction(_ sender: AnyObject) {
        if (btnDone.title(for: .normal) == "Close"){
            dismissCard()
        }else{
            error = nil
            var card :Card?
            let cardNumber :String = getCardNumber()
            if cardNumber.count <= 13 {
                error = "Please enter valid card number"
            }else if viewExpiryMonth.labelValue.text! == "MM" {
                error = "Please Select Expiry Month"
            }else if viewExpiryYear.labelValue.text! == "YYYY" {
                error = "Please Select Expiry Year"
            }else if (txtCvc.text?.count)! < 3 {
                error = "Please enter valid Cvv"
            }
            
            
            if (error == "" || error == nil) {
                card = Card(holderName: txtCardName.text, number: cardNumber, month: Month(rawValue: viewExpiryMonth!.labelValue.text!)!, year: viewExpiryYear!.labelValue.text!, cvc: txtCvc.text!, paymentType: Card.PaymentType.card, cardType:addedCardType!, userId: 1)
            }
            
            if error != nil && toast == true{
                UIApplication.topViewController()?.view.makeToast(error!)
            }
            if self.delegate != nil{
                self.delegate?.cardDoneButtonClicked(card, error: error)
            }
        }
        if flipOnDone == true{
            flip(nil)
        }
        if autoDismiss == true && (error == "" || error == nil){
            dismissCard()
        }
        
    }
    
    // MARK:-
    // MARK: Card Management
    // MARK:-
    
    
    fileprivate func hideDoneButton(){
        UIView.animate(withDuration: 1, animations: {
            self.btnDone.setTitle("Close", for: .normal)
        })
    }
    
    fileprivate func unHideDoneButton(){
        UIView.animate(withDuration: 1, animations: {
            self.btnDone.setTitle("Done", for: .normal)
        })
    }
    
    fileprivate func getCardNumber ()->String{
        return txtCardNoP1.text! + txtCardNoP2.text! + txtCardNoP3.text! + txtCardNoP4.text!
    }
    
    @objc fileprivate func flip(_ sender:UISwipeGestureRecognizer?) {
        
        if sender?.direction == .left && cardFrontView.isHidden == true{
            print("left")
            return
        }
        if sender?.direction == .right && cardFrontView.isHidden == false{
            print("right")
            return
        }
        
        if (cardFrontView.isHidden == false) {
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            btnCvc.setTitle("CARD", for: UIControl.State())
            UIView.transition(with: cardFrontView, duration: 1.0, options: transitionOptions, animations: {
                self.cardFrontView.isHidden = true
            }, completion: nil)
            
            UIView.transition(with: cardBackView, duration: 1.0, options: transitionOptions, animations: {
                self.cardBackView.isHidden = false
                self.txtCvc.becomeFirstResponder()
            }, completion: nil)
        }
        else {
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            btnCvc.setTitle("CVC", for: UIControl.State())
            UIView.transition(with: cardBackView, duration: 1.0, options: transitionOptions, animations: {
                self.cardBackView.isHidden = true
            }, completion: nil)
            
            UIView.transition(with: cardFrontView, duration: 1.0, options: transitionOptions, animations: {
                self.cardFrontView.isHidden = false
                self.txtCvc.resignFirstResponder()
            }, completion: nil)
            
        }
    }
    
    fileprivate func setImage(_ card : String) {
        
                func setImageWithAnnimation(_ image:UIImage?,cardType:CardType){
                    addedCardType = cardType
                    UIView.animate(withDuration: 1, animations: {
                        self.cardTypeImage.image = image
                    })
                }
        
                switch card {
        
                case CardType.Visa.rawValue:
                    setImageWithAnnimation(UIImage(named: "Visa", in: mfBundel!,compatibleWith: nil),cardType: CardType.Visa)
                    break
        
                case CardType.MasterCard.rawValue:
                    setImageWithAnnimation(UIImage(named: "MasterCard", in: mfBundel!,compatibleWith: nil),cardType: CardType.MasterCard)
                    break
        
                case CardType.Amex.rawValue:
                    setImageWithAnnimation(UIImage(named: "Amex", in: mfBundel!,compatibleWith: nil),cardType: CardType.MasterCard)
                    break
                
                case CardType.JCB.rawValue:
                    setImageWithAnnimation(UIImage(named: "JCB", in: mfBundel!,compatibleWith: nil),cardType: CardType.JCB)
                    break
        
                case CardType.Discover.rawValue:
                    setImageWithAnnimation(UIImage(named: "Discover", in: mfBundel!,compatibleWith: nil),cardType: CardType.Discover)
                    break
        
                case CardType.Diners.rawValue:
                    setImageWithAnnimation(UIImage(named: "DinersClub", in: mfBundel!,compatibleWith: nil),cardType: CardType.Diners)
        
                case CardType.Maestro.rawValue:
                    setImageWithAnnimation(UIImage(named: "Maestro", in: mfBundel!,compatibleWith: nil),cardType: CardType.Maestro)
                    
                case CardType.Electron.rawValue:
                    setImageWithAnnimation(UIImage(named: "Electron", in: mfBundel!,compatibleWith: nil),cardType: CardType.Electron)
                
                case CardType.Dankort.rawValue:
                    setImageWithAnnimation(UIImage(named: "Dankort", in: mfBundel!,compatibleWith: nil),cardType: CardType.Dankort)
                    
                case CardType.UnionPay.rawValue:
                    setImageWithAnnimation(UIImage(named: "UnionPay", in: mfBundel!,compatibleWith: nil),cardType: CardType.UnionPay)
                    
                case CardType.RuPay.rawValue:
                    setImageWithAnnimation(UIImage(named: "RuPay", in: mfBundel!,compatibleWith: nil), cardType: CardType.RuPay)
                    
                case CardType.Unknown.rawValue:
                    cardTypeImage.image = nil
                    addedCardType = CardType.Unknown
                default:
                    cardTypeImage.image = nil
                    addedCardType = CardType.Visa
        
                    break
                }
    }
    
    // MARK:-
    // MARK: @IBInspectable
    // MARK:-
    
    @IBInspectable public var cardImage :UIImage?  {
        didSet{
                frontCardImage.image = cardImage
        }
        
    }
    
    @IBInspectable public var cardImageRequire: Bool = true {
        didSet{
            self.imageRequire(cardImageRequire)
        }
    }
    
    @IBInspectable public var backColor: UIColor? = UIColor.clear{
        didSet {
            if oldValue != backgroundColor {
                self.backgroundColor = self.backColor
            }
        }
    }
    
    @IBInspectable public var frontChromeColor :UIColor? = UIColor.clear {
        didSet{
            
            if oldValue != frontChromeColor {
                viewExpiryYear.dDLColor  = frontChromeColor!
                viewExpiryMonth.dDLColor = frontChromeColor!
                viewExpiryYear.dDLStrokeColor = frontChromeColor!
                viewExpiryMonth.dDLStrokeColor = frontChromeColor!
                btnCvc.backgroundColor          = frontChromeColor
                btnDone.backgroundColor         = frontChromeColor
                frontChromeView.backgroundColor = frontChromeColor
            }
        }
        
    }
    
    @IBInspectable public var frontChromeAlpha :CGFloat = 0.8 {
        didSet{
            if oldValue != frontChromeAlpha {
                frontChromeView.alpha = frontChromeAlpha
            }
        }
        
    }
    
    @IBInspectable public var backChromeColor :UIColor? = UIColor.clear {
        didSet{
            if oldValue != backChromeColor {
                backChromeView.backgroundColor = backChromeColor
            }
        }
        
    }
    
    @IBInspectable public var backChromeAlpha :CGFloat = 0.8 {
        didSet{
            if oldValue != backChromeAlpha {
                backChromeView.alpha = backChromeAlpha
            }
        }
        
    }
    
    @IBInspectable public var backTape :UIColor = UIColor.black  {
        didSet{
            magneticTapeView.backgroundColor = backTape
        }
        
    }
    
    
    @IBInspectable public var labelColor: UIColor? = UIColor.white{
        didSet {
            if oldValue != labelColor {
                changeFont(labelColor!)
            }
        }
    }
    
    @IBInspectable public var MMYYTextColor: UIColor? = UIColor.white{
        didSet {
            if oldValue != MMYYTextColor {
                viewExpiryMonth.textColor = MMYYTextColor!
                viewExpiryYear.textColor = MMYYTextColor!
                viewExpiryMonth.dDLTextColor = MMYYTextColor!
                viewExpiryYear.dDLTextColor = MMYYTextColor!
            }
        }
    }
    
    @IBInspectable public var TF_Color: UIColor? = UIColor.white{
        didSet {
            if oldValue != TF_Color {
                changeTextFieldColor(TF_Color!)
                
            }
        }
    }
    
    @IBInspectable public var TF_TextColor: UIColor? = UIColor.black{
        didSet {
            if oldValue != TF_TextColor {
                changeTextFieldTextColor(TF_TextColor!)
            }
        }
    }
    
    @IBInspectable public var controlButtonsRadius: CGFloat = 5 {
        didSet {
            if oldValue != controlButtonsRadius {
                self.layoutIfNeeded()
                self.btnCvc.layer.cornerRadius  = self.controlButtonsRadius
                self.btnDone.layer.cornerRadius = self.controlButtonsRadius
            }
        }
    }
    
    @IBInspectable public var cardRadius: CGFloat = 15 {
        didSet {
            if oldValue != cardRadius {
                self.layoutIfNeeded()
                setCardRadius()
            }
        }
    }
    
    @IBInspectable public var placeholder: Bool = true {
        didSet{
            if oldValue != placeholder {
                setPlaceholder(placeholder)
            }
            
        }
    }
    
    @IBInspectable public var cvvPasswordType: Bool = true {
        didSet{
            if oldValue != cvvPasswordType {
                changeCvvTFStyle(cvvPasswordType)
            }
            
        }
    }
    
    
}

// MARK:-
// MARK: UITextFieldDelegate Methods
// MARK:-

extension MFCardView: UITextFieldDelegate{
    
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if textField != txtCvc{
            changeTextFieldLessThan0(textField)
            changeTextFieldMoreThan4(textField)
            changeCardType()
        }
        if textField == txtCvc {
            if (textField.text?.count)! >= 3 {
                self.unHideDoneButton()
                textField.resignFirstResponder()
            }else{
                self.hideDoneButton()
            }
        }
        
    }
    
    // GET THE NAME OF THE CARD AND SET THE IMAGE IN THE IMAGEVIEW
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtCvc {
            if (textField.text?.count)! >= 3 {
                self.unHideDoneButton()
            }else{
                self.hideDoneButton()
            }
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField != txtCvc{
            let charLimit = 4
            let currentLength = (textField.text?.count)! + string.count - range.length
            let newLength = charLimit - currentLength
            if newLength < 0 {
                changeTextFieldMoreThan4(textField)
                return false
            }else{
                
                return true
            }
        }else{
            let charLimit = 3
            let currentLength = (textField.text?.count)! + string.count - range.length
            let newLength = charLimit - currentLength
            if newLength < 0 {
                textField.resignFirstResponder()
                return false
            }else{
                return true
                
            }
        }
        
    }
    
    //MARK: Helper Methods
    func changeCardType(){
        let number = getCardNumber()
        if number.count <= 4 || number.count >= 7{
            
            let validator = CreditCardValidator()
            if let type = validator.typeFromString(number) {
                print(type.name)
                if addedCardType?.rawValue != type.name{
                    delegate?.cardTypeDidIdentify(type.name)
                }
                if type.name == "" || type.name.count<0{
                    setImage("Unknown")
                }else{
                    setImage(type.name)
                }
            }
            else {
               // error = "Can not detect card."
                print("Can not detect card.")
                setImage("Unknown")
            }
        }
    }
    func changeTextFieldMoreThan4(_ textField: UITextField){
        let text = textField.text
        if text?.count == 4 {
            switch textField{
            case txtCardNoP1:
                txtCardNoP2.becomeFirstResponder()
            case txtCardNoP2:
                txtCardNoP3.becomeFirstResponder()
            case txtCardNoP3:
                txtCardNoP4.becomeFirstResponder()
            case txtCardNoP4:
                txtCardNoP4.resignFirstResponder()
            default:
                break
            }
        }
    }
    func changeTextFieldLessThan0(_ textField: UITextField){
        let text = textField.text
        if (text?.count)! <= 0 {
            switch textField{
            case txtCardNoP1:
                txtCardNoP1.becomeFirstResponder()
            case txtCardNoP2:
                txtCardNoP1.becomeFirstResponder()
            case txtCardNoP3:
                txtCardNoP2.becomeFirstResponder()
            case txtCardNoP4:
                txtCardNoP3.becomeFirstResponder()
            default:
                break
            }
        }
        
    }
}

// MARK:-
// MARK: LBZSpinnerDelegate Methods
// MARK:-

extension MFCardView :LBZSpinnerDelegate{
    // LBZSpinner Delegate Method
    func spinnerChoose(_ spinner:LBZSpinner, index:Int,value:String) {
        var spinnerName = ""
        if spinner == viewExpiryMonth { spinnerName = "Month" }
        if spinner == viewExpiryYear { spinnerName = "Year" }
        
        print("Spinner : \(spinnerName) : { Index : \(index) - \(value) }")
    }
    
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
