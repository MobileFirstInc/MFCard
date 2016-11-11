//
//  MFCardView.swift
//  MFCard
//
//  Created by MobileFirst Applications on 03/11/16.
//  Copyright © 2016 MobileFirst Applications. All rights reserved.
//

import UIKit
import CreditCardValidator

protocol MFCardDelegate {
    func cardDoneButtonClicked(card:Card?, error:String?)
}

@IBDesignable class MFCardView: UIView {
    
        
    var delegate :MFCardDelegate?
    fileprivate var  chromeColor : UIColor? {
        return UIColor.chromeColor()
    }
    fileprivate var addedCardType: CardType?
    fileprivate var error :String? = String()
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var cardBackView: UIView!
    
    @IBOutlet weak var cardFrontView: UIView!
    @IBOutlet weak var backChromeView: UIView!
    
    @IBOutlet weak var magneticTapeView: UIView!
    
    @IBOutlet weak var txtCvc: UITextField!
    
    @IBOutlet weak var frontCardImage: UIImageView!
    
    @IBOutlet weak var frontChromeView: UIView!
    
    @IBOutlet weak var txtCardName: UITextField!
    
    @IBOutlet weak var txtCardNoP1: UITextField!
    @IBOutlet weak var txtCardNoP2: UITextField!
    @IBOutlet weak var txtCardNoP3: UITextField!
    @IBOutlet weak var txtCardNoP4: UITextField!
    
    @IBOutlet weak var cardTypeImage: UIImageView!
    @IBOutlet weak var viewExpiryMonth: LBZSpinner!
    @IBOutlet weak var viewExpiryYear: LBZSpinner!
    
    @IBOutlet weak var controlView: UIView!

    @IBOutlet weak var btnCvc: UIButton!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet var cardLabels: [UILabel]!
    var cardTextFields:[UITextField]!
//    var addedCard = Card()
    fileprivate var nibName: String = "MFCardView"
    
    //MARK:
    //MARK: initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupUI()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupUI()

    }
    
    
    //MARK:
    //MARK: Setup
    private func setup() {
        // 1. load a nib
        view = loadViewFromNib()
        // 2. add as subview
        self.addSubview(self.view)
        // 3. allow for autolayout
        self.view.translatesAutoresizingMaskIntoConstraints = false
        // 4. add constraints to span entire view
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": self.view]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": self.view]))
        
        //Other SetUps...
       cardTextFields = [txtCardNoP4,txtCardNoP3,txtCardNoP2,txtCardNoP1,txtCardName,txtCvc];
        btnDone.isHidden = true
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: Date())
        let year = components.year
        let expiryMonth = ["01","02","03","04","05","06","07","08","09", "10", "11", "12"]
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
        
        txtCardNoP1.addTarget(self, action: #selector(MFCardView.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtCardNoP2.addTarget(self, action: #selector(MFCardView.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtCardNoP3.addTarget(self, action: #selector(MFCardView.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtCardNoP4.addTarget(self, action: #selector(MFCardView.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.flip))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.flip))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.addGestureRecognizer(leftSwipe)
        self.addGestureRecognizer(rightSwipe)
    }
    
    private func setupUI(){
        self.backgroundColor = self.backGroundColor
        self.btnCvc.layer.cornerRadius = self.controlButtonsRadius
        self.btnDone.layer.cornerRadius = self.controlButtonsRadius
        self.cardBackView.layer.cornerRadius = self.cardRadius
        self.cardFrontView.layer.cornerRadius = self.cardRadius
        self.frontChromeColor = chromeColor
        changeFont(color: UIColor.white)
        changeTextFieldTextColor(color: UIColor.black)
        changeTextFieldColor(color: UIColor.white)
        cardImage = UIImage(named: "blank-world-map")
    }
    
    //MARK:
    //MARK: Helper Methods
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
//    func getBundle() -> Bundle {
//        let podBundle = Bundle(for: ViewController.self)
//        
//        let bundleURL = podBundle.url(forResource: "MFCardView", withExtension: "bundle")
//        return Bundle(url: bundleURL!)!
//    }

    
    private func changeFont(color :UIColor){
        btnDone.setTitleColor(color, for: .normal)
        btnCvc.setTitleColor(color, for: .normal)
        viewExpiryMonth.lineColor   = color
        viewExpiryYear.lineColor    = color
        for labelItem: UILabel in cardLabels{
            labelItem.textColor = color
        }
    }
    private func changeTextFieldColor(color:UIColor){
        for cardTextField: UITextField in cardTextFields{
            cardTextField.backgroundColor = color
        }
        
    }
    
    private func changeTextFieldTextColor(color:UIColor){
        for cardTextField: UITextField in cardTextFields{
            cardTextField.textColor = color
        }
    }
    private func setPlaceholder(allow:Bool){
        if allow{
            txtCvc.placeholder      = "###"
            txtCardName.placeholder = "Enter Name"
            txtCardNoP1.placeholder = "####"
            txtCardNoP2.placeholder = "####"
            txtCardNoP3.placeholder = "####"
            txtCardNoP4.placeholder = "####"
        }else{
            for cardTextField: UITextField in cardTextFields{
                cardTextField.placeholder = ""
            }
        }
    }
    
    
    //MARK:
    //MARK: IBAction
    @IBAction func btnCVCAction(_ sender: AnyObject) {
        
        flip(sender: nil)
    }
    
    @IBAction func btnDoneAction(_ sender: AnyObject) {
        
        var card :Card?
        let cardNumber :String = getCardNumber()
        if (txtCvc.text?.characters.count)! <= 3 && cardNumber.characters.count <= 13 {
            error = "Please enter valid card details"
            //UIViewController().showAlertWithTitle("Failed" ,message:"Please enter valid card details", popVC: false)
        }else if viewExpiryMonth.labelValue.text! == "MM" {
             error = "Please Select Expiry Month"
           // UIViewController().showAlertWithTitle("Failed", message:"Please Select Expiry Month", popVC: false)
        }else if viewExpiryYear.labelValue.text! == "YYYY" {
            error = "Please Select Expiry Year"
           // UIViewController().showAlertWithTitle("Failed", message:"Please Select Expiry Year", popVC: false)
        }
        else{
        }
        card = Card(name: txtCardName.text, number: cardNumber, month: viewExpiryMonth!.labelValue.text!, year: viewExpiryYear!.labelValue.text!, cvc: txtCvc.text, paymentType: Card.PaymentType.card, cardType:addedCardType, userId: 1)
        
        if self.delegate != nil{
            self.delegate?.cardDoneButtonClicked(card: card, error: error)
        }

    }
    
    //MARK:
    //MARK: Card Management
    
    fileprivate func hideDoneButton(){
        UIView.animate(withDuration: 1, animations: {
            self.btnDone.alpha = 0
            self.btnDone.isHidden = true
        })
    }
    fileprivate func unHideDoneButton(){
        UIView.animate(withDuration: 1, animations: {
            self.btnDone.alpha = 1
            self.btnDone.isHidden = false
        })
    }
    fileprivate func getCardNumber ()->String{
        return txtCardNoP1.text! + txtCardNoP2.text! + txtCardNoP3.text! + txtCardNoP4.text!
    }
    @objc fileprivate func flip(sender:UISwipeGestureRecognizer?) {
        
        if sender?.direction == .left && cardFrontView.isHidden == true{
            print("left")
            return
        }
        if sender?.direction == .right && cardFrontView.isHidden == false{
            print("right")
            return
        }
        
        if (cardFrontView.isHidden == false) {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            btnCvc.setTitle("CARD", for: UIControlState())
            UIView.transition(with: cardFrontView, duration: 1.0, options: transitionOptions, animations: {
                self.cardFrontView.isHidden = true
            }, completion: nil)
            
            UIView.transition(with: cardBackView, duration: 1.0, options: transitionOptions, animations: {
                self.cardBackView.isHidden = false
                self.txtCvc.becomeFirstResponder()
            }, completion: nil)
        }
        else {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            btnCvc.setTitle("CVC", for: UIControlState())
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
        
        func setImageWithAnnimation(_ image:UIImage,cardType:CardType){
            addedCardType = cardType
            UIView.animate(withDuration: 1, animations: {
                self.cardTypeImage.image = image
            })
        }
        
        switch card {
            
        case CardType.Visa.rawValue:
            setImageWithAnnimation(UIImage(named: "Visa")!,cardType: CardType.Visa)
            break
            
        case CardType.MasterCard.rawValue:
            setImageWithAnnimation(UIImage(named: "MasterCard")!,cardType: CardType.MasterCard)
            break
            
        case CardType.JCB.rawValue:
            setImageWithAnnimation(UIImage(named: "JCB")!,cardType: CardType.JCB)
            break
            
        case CardType.Discover.rawValue:
            setImageWithAnnimation(UIImage(named: "Discover")!,cardType: CardType.Discover)
            break
            
        case CardType.Diners.rawValue:
            setImageWithAnnimation(UIImage(named: "DinersClub")!,cardType: CardType.Diners)
            
            
        case CardType.Unknown.rawValue:
            cardTypeImage.image = nil
            addedCardType = CardType.Unknown
        default:
            cardTypeImage.image = nil
            addedCardType = CardType.Visa

            break
        }
    }
    
    //MARK:
    //MARK: @IBInspectable
    
    @IBInspectable var backGroundColor: UIColor? = UIColor.clear{
        didSet {
            if oldValue != backgroundColor {
                self.backgroundColor = self.backGroundColor
            }
        }
    }
    
    @IBInspectable var controlButtonsRadius: CGFloat = 5 {
        didSet {
            if oldValue != controlButtonsRadius {
                self.btnCvc.layer.cornerRadius  = self.controlButtonsRadius
                self.btnDone.layer.cornerRadius = self.controlButtonsRadius
            }
        }
    }

    @IBInspectable var cardRadius: CGFloat = 15 {
        didSet {
            if oldValue != cardRadius {
                self.cardBackView.layer.cornerRadius    = self.cardRadius
                self.cardFrontView.layer.cornerRadius   = self.cardRadius
            }
        }
    }
    
    @IBInspectable var labelColor: UIColor? = UIColor.white{
        didSet {
            if oldValue != labelColor {
                changeFont(color: labelColor!)
            }
        }
    }
    
    @IBInspectable var MMYYTextColor: UIColor? = UIColor.white{
        didSet {
            if oldValue != MMYYTextColor {
                viewExpiryMonth.textColor = MMYYTextColor!
                viewExpiryYear.textColor = MMYYTextColor!
                viewExpiryMonth.dDLTextColor = MMYYTextColor!
                viewExpiryYear.dDLTextColor = MMYYTextColor!
            }
        }
    }
    
    @IBInspectable var TF_Color: UIColor? = UIColor.white{
        didSet {
            if oldValue != TF_Color {
                changeTextFieldColor(color: TF_Color!)
                
            }
        }
    }
    
    @IBInspectable var TF_TextColor: UIColor? = UIColor.black{
        didSet {
            if oldValue != TF_TextColor {
                changeTextFieldTextColor(color: TF_TextColor!)
            }
        }
    }
    
    @IBInspectable var placeholder: Bool = true {
        didSet{
            if oldValue != placeholder {
                setPlaceholder(allow: placeholder)
            }
            
        }
    }

    @IBInspectable var frontChromeColor :UIColor? = UIColor.black {
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
    
    @IBInspectable var frontChromeAlpha :CGFloat = 0.8 {
        didSet{
            if oldValue != frontChromeAlpha {
                frontChromeView.alpha = frontChromeAlpha
            }
        }
        
    }
    
    @IBInspectable var backChromeColor :UIColor? = UIColor.black {
        didSet{
            if oldValue != backChromeColor {
                backChromeView.backgroundColor = backChromeColor
            }
        }
        
    }
    
    @IBInspectable var backChromeAlpha :CGFloat = 0.8 {
        didSet{
            if oldValue != backChromeAlpha {
                backChromeView.alpha = backChromeAlpha
            }
        }
        
    }
    
    @IBInspectable var cardImage :UIImage? = UIImage(named: "blank-world-map")  {
        didSet{
            if oldValue != cardImage {
                frontCardImage.image = cardImage
            }
        }
        
    }
    @IBInspectable var backTape :UIColor = UIColor.black  {
        didSet{
            if oldValue != backTape {
                magneticTapeView.backgroundColor = backTape
            }
        }
        
    }
    
}


extension MFCardView: UITextFieldDelegate{
   
    func textFieldDidChange(_ textField: UITextField){
        if textField != txtCvc{
            changeTextFieldLessThan0(textField)
            changeTextFieldMoreThan4(textField)
        }
        if textField == txtCvc {
            if (textField.text?.characters.count)! >= 3 {
                self.unHideDoneButton()
            }else{
                self.hideDoneButton()
            }
        }
        
    }
    
    // GET THE NAME OF THE CARD AND SET THE IMAGE IN THE IMAGEVIEW
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtCardNoP2 {
            
            let number = txtCardNoP1.text! + txtCardNoP2.text!
            
            let validator = CreditCardValidator()
            
            if let type = validator.typeFromString(number) {
                
                print(type.name)
                
                setImage(type.name)
                
                
            }
                
            else {
                error = "Can not detect card."
                print("Can not detect card.")
            }
            
        }
        if textField == txtCvc {
            if (textField.text?.characters.count)! >= 3 {
                self.unHideDoneButton()
            }else{
                self.hideDoneButton()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != txtCvc{
            let charLimit = 4
            let currentLength = (textField.text?.characters.count)! + string.characters.count - range.length
            let newLength = charLimit - currentLength
            if newLength < 0 {
                changeTextFieldMoreThan4(textField)
                
                return false
            }else{
                
                return true
                
            }
        }else{
            let charLimit = 3
            let currentLength = (textField.text?.characters.count)! + string.characters.count - range.length
            let newLength = charLimit - currentLength
            if newLength < 0 {
                return false
            }else{
                return true
                
            }
        }
        
    }
    
    //MARK: Helper Methods
    func changeTextFieldMoreThan4(_ textField: UITextField){
        let text = textField.text
        if text?.characters.count == 4 {
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
        if (text?.characters.count)! <= 0 {
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
extension MFCardView :LBZSpinnerDelegate{
    // LBZSpinner Delegate Method
    func spinnerChoose(_ spinner:LBZSpinner, index:Int,value:String) {
        var spinnerName = ""
        if spinner == viewExpiryMonth { spinnerName = "Month" }
        if spinner == viewExpiryYear { spinnerName = "Year" }
        
        print("Spinner : \(spinnerName) : { Index : \(index) - \(value) }")
    }
    

}
extension UIColor{
    
    class func chromeColor() -> UIColor {
        return UIColor(colorLiteralRed: 0.02, green: 0.52, blue: 0.64, alpha: 1)
        //0485A3
    }
}

extension UIViewController{

    func showAlertWithTitle(_ title:String, message:String, popVC:Bool){
        
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK",
                                     style: .cancel) { (alert) -> Void in
                                        if popVC == true {
                                            self.navigationController?.popViewController(animated: true)
                                        }else{}
                                        
        }
        alert.addAction(okButton)
        self.present(alert, animated: true,
                     completion: nil)
    }
}
