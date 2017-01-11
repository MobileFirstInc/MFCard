<img src="https://raw.githubusercontent.com/MobileFirstInc/MFCard/master/MFcard%20poster.jpg" alt=" text" width="100%" />

# MFCard

<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<img src="https://img.shields.io/badge/swift3-compatible-green.svg?style=flat" alt="Swift 3 compatible" />
<img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License MIT" />
<a href="https://cocoapods.org/pods/MFCard"><img src="https://img.shields.io/badge/pod-1.0.9-blue.svg" alt="CocoaPods compatible" /></a>

MFCard is an awesome looking Credit Card input & validation control. Written in Swift 3.

<img src="https://raw.githubusercontent.com/MobileFirstInc/MFCard/master/MFCardDemo/Screens/Card Front.png" alt=" text" width="40%" />


## Demo

<img src="https://raw.githubusercontent.com/MobileFirstInc/MFCard/master/MFCardDemo/Screens/_MFCard.gif" alt=" text" width="40%" />


## Usage

First Step  - `@import MFCard` to your project 

Second Step - Add a delegate `MFCardDelegate` to your class & add two delegate methods 

Third Step - Present a Card 

```
var myCard : MFCardView
myCard  = MFCardView(withViewController: self)
myCard.delegate = self
myCard.autoDismiss = true
myCard.toast = true
myCard.showCard()

```

## CocoaPods Install

Add this to your Podfile. 

```
pod 'MFCard'
```


## Supported Cards

* MasterCard
* Visa
* JCB
* Diners
* Discover
* Amex
* Maestro
* UnionPay
* Electron
* Dankort
* RuPay

## Customisation Options

- Card Image 
- Background colour
- Front Chrome colour (Front Card colour)
- Back Chrome colour (Back Card colour)
- Front Chrome Alpha
- Back Chrome Alpha
- Back Card Magnetic Tap colour
- All Label colour
- TextField Customisation
- Control Buttons
- Corner Radius
- Placeholders
- Auto Dismiss
- Flip on Done



<img src="https://raw.githubusercontent.com/MobileFirstInc/MFCard/master/MFCardDemo/Screens/Card1.png" alt=" text" width="40%" />


<img src="https://raw.githubusercontent.com/MobileFirstInc/MFCard/master/MFCardDemo/Screens/Card Back.png" alt=" text" width="40%" />


<img src="https://raw.githubusercontent.com/MobileFirstInc/MFCard/master/MFCardDemo/Screens/MF.png" alt=" text" width="60%" />






## Features

- Card Validation Support
- Present Card like alert
- Swipe Gesture To Swipe Card front & back
- Error Handing
- Toast Messages for error handling 
- All Properties editable using IBDesignable


## Collaboration
Feel free to collaborate with ideas, issues and/or pull requests.


## Further Plans 

- Provide More Classic card views
- Mutiple Card Collection Viewer 
- Stripe Integration 
- Language Support (French, Spanish)
- More Animations :-P

## Thanks 
- https://github.com/RC7770/CreditCardValidator
- https://github.com/scalessec/Toast-Swift
- Icon Credit : https://thenounproject.com/term/credit-card/490264/




## Contact

* Arpan & Rahul (http://mobilefirst.in)
* Twitter: [@mobilefirstinc](http://twitter.com/mobilefirstinc)
* Email : [arpan at mobilefirst.in](mailto://arpan@mobilefirst.in)

## License

MFCard is released under the [MIT License](http://www.opensource.org/licenses/MIT).

