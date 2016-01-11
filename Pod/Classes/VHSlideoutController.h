//
//  VHSlideoutController.h
//  Pods
//
//  Created by Varindra Hart on 1/11/16.
//
//

#import <UIKit/UIKit.h>

@interface VHSlideoutController : UIViewController
@property (nonatomic) UIView *leftView;
@property (nonatomic) UIView *rightView;

- (void)embedLeftViewController :(UIViewController *)leftViewController;
- (void)embedRightViewController:(UIViewController *)rightViewController;
- (void)embedTopViewController  :(UIViewController *)topViewController;

@end