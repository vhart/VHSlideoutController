# VHSlideoutController

[![CI Status](http://img.shields.io/travis/Varindra/VHSlideoutController.svg?style=flat)](https://travis-ci.org/Varindra/VHSlideoutController)
[![Version](https://img.shields.io/cocoapods/v/VHSlideoutController.svg?style=flat)](http://cocoapods.org/pods/VHSlideoutController)
[![License](https://img.shields.io/cocoapods/l/VHSlideoutController.svg?style=flat)](http://cocoapods.org/pods/VHSlideoutController)
[![Platform](https://img.shields.io/cocoapods/p/VHSlideoutController.svg?style=flat)](http://cocoapods.org/pods/VHSlideoutController)

## Overview

VHSlideoutController is a subclass of UIViewController that lets you set a top, left, and right view controller. You can then swipe to reveal the layers.


<p align = center> <img src= "https://github.com/vhart/VHSlideoutController/blob/master/VHSlideoutControllerDemo.gif" /> </p>

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
ARC

## Installation

VHSlideoutController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "VHSlideoutController"
```

## Documentation

### Implementation
To use VHSlideoutController you first create a new class and make it a subclass of VHSlideoutController.
Then in your viewDidLoad create instances of the three view controllers you would like to designate as the left, right, and top. These view controllers will most likely have classes of their own so be sure to import the appropriate headers. 
The example below shows how to instantiate and embed the view controllers from the storyboard:
```objC
UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
UIViewController *left  = [storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
UIViewController *right = [storyboard instantiateViewControllerWithIdentifier:@"RightViewController"];
UIViewController *top   = [storyboard instantiateViewControllerWithIdentifier:@"TopViewController"];

[self embedLeftViewController:left];
[self embedRightViewController:right];
[self embedTopViewController:top];
```
Again, the above is using the storyboard, but you can just as easily instantiate from a nib and then call the embed methods.

### VHSlideoutController Notifications
You may want to perform certain actions upon the animations completion. Because there are three view controllers to communicate with (left, right, and top), you can simply tell your subclass of VHSlideoutController to post NSNotifications.
To do this you just set the following in the viewDidLoad of your VHSlideoutController subclass:
```objC
// Send Notification when animation to the left is complete
self.shouldPostMovedLeftNotification = YES;
  
// Send Notification when animation to the right is complete
self.shouldPostMovedRightNotification = YES;

// Send Notification when animation returning to the center is complete
self.shouldPostReturnedToCenterNotification = YES;
```
But, be sure to add the recieving classes as observers to the Notification Center:
```objC
   //These are the three notification names:
   @"VHMovedLeftNotification"         //LEFT NOTIFICATION
   @"VHMovedRightNotification"        //RIGHT NOTIFICATION
   @"VHReturnedToCenterNotification"  //RETURNED TO CENTER
```
Here's how you would add the observer:
```objC
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_SELECTOR_NAME_) name:@"VHMovedLeftNotification" object:nil];
```
When not needed, remember to remove the observer. 

## Author

Varindra, varindrahart@gmail.com

## License

VHSlideoutController is available under the MIT license. See the LICENSE file for more info.
