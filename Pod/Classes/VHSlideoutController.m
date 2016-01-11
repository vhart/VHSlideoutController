//
//  VHSlideoutController.m
//  Pods
//
//  Created by Varindra Hart on 1/11/16.
//
//


#import "VHSlideoutController.h"

const double ANIMATION_DURATION = .275;
NSString * const movedLeft        = @"VHMovedLeftNotification";
NSString * const movedRight       = @"VHMovedRightNotification";
NSString * const returnedToCenter = @"VHReturnedToCenterNotification";

@interface VHSlideoutController ()

@property (nonatomic) BOOL isLeft;
@property (nonatomic) BOOL isRight;
@property (nonatomic) BOOL hasSetUpViews;
@property (nonatomic) UIViewController *topViewController;

@end

@implementation VHSlideoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

#pragma MARK - SetupViews
- (void)setup{

    if (!self.hasSetUpViews){

        CGFloat width = self.view.bounds.size.width/2;
        CGFloat height = self.view.bounds.size.height;

        UIView *left   = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.leftView  = left;
        [self.view addSubview:self.leftView];

        UIView *right  = [[UIView alloc]initWithFrame:CGRectMake(width, 0, width, height)];
        self.rightView = right;
        [self.view addSubview:self.rightView];

        self.hasSetUpViews = YES;
    }
}

#pragma MARK - Embedding View Controllers
- (void)embedTopViewController:(UIViewController *)topViewController{

    [self addChildViewController:topViewController];
    topViewController.view.frame = self.view.bounds;
    [self.view addSubview:topViewController.view];
    [topViewController willMoveToParentViewController:self];

    self.topViewController = topViewController;
    [self addSwipeGesturesToView:self.topViewController.view];
    [self addShadow:self.topViewController.view];

}

- (void)embedRightViewController:(UIViewController *)rightViewController{

    [self addChildViewController:rightViewController];
    rightViewController.view.frame = self.rightView.bounds;
    [self.rightView addSubview:rightViewController.view];
    [rightViewController willMoveToParentViewController:self];

}

- (void)embedLeftViewController:(UIViewController *)leftViewController{

    [self addChildViewController:leftViewController];
    leftViewController.view.frame = self.leftView.bounds;
    [self.leftView addSubview:leftViewController.view];
    [leftViewController willMoveToParentViewController:self];

}

#pragma MARK - SwipeGesture Methods

//Method called to add swipe gestures to the top view controller. This allows it to
//slide left and right
- (void)addSwipeGesturesToView:(UIView *)swipeView {

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [swipeView addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [swipeView addGestureRecognizer:swipeRight];

}

//New center for the top view controller is found and then the top view is
//animated
- (void)swipeRecognized:(UISwipeGestureRecognizer *)swipe{

    CGRect newFrame = [self getNewFrame:self.topViewController.view.center swipeDirection:swipe.direction];

    if (swipe.direction==UISwipeGestureRecognizerDirectionLeft && !self.isLeft) {

        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.topViewController.view.frame = newFrame;
        } completion:^(BOOL finished) {
            if (self.isRight) {
                self.isRight = NO;
            }
            else{
                self.isLeft = YES;
            }

            [self postCompletionNotification];
        }];
    }

    else if (swipe.direction==UISwipeGestureRecognizerDirectionRight && !self.isRight){

        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.topViewController.view.frame = newFrame;
        } completion:^(BOOL finished) {
            if (self.isLeft) {
                self.isLeft = NO;
            }
            else{
                self.isRight = YES;
            }

            [self postCompletionNotification];
        }];
    }
}

- (CGRect)getNewFrame:(CGPoint)center swipeDirection:(UISwipeGestureRecognizerDirection)direction{

    CGPoint newAnchor = [self findNewAnchor:self.topViewController.view.center swipeDirection:direction];

    return CGRectMake(newAnchor.x, newAnchor.y, self.topViewController.view.bounds.size.width, self.topViewController.view.bounds.size.height);

}

- (CGPoint)findNewAnchor:(CGPoint)center swipeDirection:(UISwipeGestureRecognizerDirection)direction{

    CGPoint oldAnchor = CGPointMake(center.x- (self.topViewController.view.bounds.size.width/2), .5);
    float shift = direction==UISwipeGestureRecognizerDirectionLeft? -1: 1;
    CGPoint newAnchor = CGPointMake(oldAnchor.x + (shift*self.topViewController.view.bounds.size.width/2), .5);

    return newAnchor;

}

//Post a notification to allow other Controllers to react to the animation, if
//necessary. Be sure to remove observer when not needed.
- (void)postCompletionNotification{

    if (self.shouldPostMovedLeftNotification && self.isLeft) {
        [[NSNotificationCenter defaultCenter]postNotificationName:movedLeft object:nil];
    }
    if (self.shouldPostMovedRightNotification && self.isRight) {
        [[NSNotificationCenter defaultCenter]postNotificationName:movedRight object:nil];
    }
    if (self.shouldPostReturnedToCenterNotification && !self.isLeft && !self.isRight) {
        [[NSNotificationCenter defaultCenter]postNotificationName:returnedToCenter object:nil];
    }

}

#pragma MARK - Shadow Effect

//Adds shadow to the top view controller giving it a layered illusion
- (void)addShadow:(UIView *)topView{

    [self.topViewController.view.layer setCornerRadius:0];
    [self.topViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.topViewController.view.layer setShadowOpacity:0.8];
    [self.topViewController.view.layer setShadowOffset:CGSizeMake(0,2.5)];
    
}

@end