# BEPureLayout

[![CI Status](https://img.shields.io/travis/bigearsenal/BEPureLayout.svg?style=flat)](https://travis-ci.org/bigearsenal/BEPureLayout)
[![Version](https://img.shields.io/cocoapods/v/BEPureLayout.svg?style=flat)](https://cocoapods.org/pods/BEPureLayout)
[![License](https://img.shields.io/cocoapods/l/BEPureLayout.svg?style=flat)](https://cocoapods.org/pods/BEPureLayout)
[![Platform](https://img.shields.io/cocoapods/p/BEPureLayout.svg?style=flat)](https://cocoapods.org/pods/BEPureLayout)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- [PureLayout](https://github.com/PureLayout/PureLayout)

## Installation

BEPureLayout is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BEPureLayout'
```
## Usage

BEPureLayout adds some custom UI classes, short-hand helper-functions to well-known PureLayout library that helps developers quickly create common UIComponents like pure UIView, UIButton, UILabel, UIImageView,... Besides, this library add some common-used methods for adding constraints.

### BEViewController + BENavigationController
BEViewController is a subclass of UIViewController which was implemented methods for easy NavigationBar and StatusBar configurations and setUps
- `BEViewController` should be embeded in a `BENavigationController`
- Layout code should be implemented inside `override func setUp()`
- DataBinding should be implemented inside `override func bind()`
- For NavigationBar customization, override property `var preferredNavigationBarStype: BEViewController.NavigationBarStyle`
- For changing navigationBar's backgroundColor, use `setNavigationBarBackgroundColor(:)`
- For changing navigationBar's textStyle, use `setNavigationBarTitleStyle(textColor: UIColor, font: UIFont)`
- For changing statusBarStyle, use `changeStatusBarStyle(_ style: UIStatusBarStyle)`

### UIView
```
init(width:, height:, backgroundColor:, cornerRadius:)
```
### UIButton
```
init(width:, height:, backgroundColor:, cornerRadius:, label:, labelFont:, textColor:, contentInsets:)
```
### UILabel
```
init(text:, textSize:, weight:, textColor:, numberOfLines:, textAlignment:)
```
### UIImageView
```
init(width:, height:, backgroundColor:, cornerRadius:, imageNamed:, contentMode:)
```
### UITextView
```
init(width:, height:, backgroundColor:, cornerRadius:, font:, keyboardType:, placeholder:, autocorrectionType:, autocapitalizationType:, spellCheckingType:, textContentType:, isSecureTextEntry:, horizontalPadding:, leftView:, leftViewMode:, rightView:, rightViewMode:)
```
Note: You don't have to provide all properties to initializers. Only provide known or required properties, then other properties will be set by default. For example, if the view's width is based on superview's width, then just remove the width property from the initializer: `UIView(height: 30)` and add needed width constraint to superview

### New methods for adding constraint
- autoPinToTopLeftCornerOfSuperview
- autoPinToTopRightCornerOfSuperview
- autoPinToBottomLeftCornerOfSuperview
- autoPinToBottomRightCornerOfSuperview
- autoPinToTopLeftCornerOfSuperviewSafeArea
- autoPinToTopRightCornerOfSuperviewSafeArea
- autoPinToBottomLeftCornerOfSuperviewSafeArea
- autoPinToBottomRightCornerOfSuperviewSafeArea
- autoPinBottomToSuperViewSafeAreaAvoidKeyboard

### ContentHuggingScrollView
This subclass of UIScrollView contains a `contentView` that is hugged inside ScrollView itself and only scrollable in a defined direction provided by property `scrollableAxis`.
Everything that needs to add to ScrollView should be added only to its `contentView`.
For example:
```
let scrollView = ContentHuggingScrollView(scrollableAxis: .vertical)
view.addSubview(scrollView)
scrollView.autoPinEdgesToSuperviewEdges()

let label = UILabel(text: "Very long text.....")

scrollView.contentView.addSubview(label)
label.autoPinEdgesToSuperviewEdges()
```

### BETableHeaderView
This subclass of UIView allows you to create flexible `tableHeaderView` for UITableView. After any layout changes in this BETableHeaderView, it will reassign itself as tableView's tableHeaderView and triggle re-layout in tableView. 

The usage of BETableHeaderView is quite simple, you can subclass it and override function commonInit to layout its content:
```
class MyTableHeaderView: BETableHeaderView {
    lazy var label = UILabel(text: "TableViewHeaderView is loading...", textSize: 20, weight: .bold, textColor: .black, numberOfLines: 0)
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(label)
        label.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
    }
}
```
Then you can construct `MyTableHeaderView` alongside with `UITableView` using initializer:
```
let tableHeaderView = MyTableHeaderView(tableView: tableView)
```

And freely change content of headerView without any concern about re-layouting
```
tableHeaderView.label.text =
    """
    TableHeaderView was loaded

    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

    """
```

For more detail, see Example project

## Author

bigearsenal, bigearsenal@gmail.com

## License

BEPureLayout is available under the MIT license. See the LICENSE file for more info.
