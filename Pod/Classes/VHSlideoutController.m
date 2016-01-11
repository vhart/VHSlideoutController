//
//  VHSlideoutController.m
//  Pods
//
//  Created by Varindra Hart on 1/11/16.
//
//


#import "VHSlideoutController.h"

const double ANIMATION_DURATION = .275;

@interface VHSlideoutController ()

@property (nonatomic) BOOL isLeft;
@property (nonatomic) BOOL isRight;
@property (nonatomic) UIViewController *topViewController;

@end

@implementation VHSlideoutController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma MARK - SetupView
- (void)setup{

    if ([self needsViews]){

        CGFloat width = self.view.bounds.size.width/2;
        CGFloat height = self.view.bounds.size.height;

        UIView *left   = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.leftView  = left;

        UIView *right  = [[UIView alloc]initWithFrame:CGRectMake(0, width, width, height)];
        self.rightView = right;
    }
}

- (BOOL)needsViews{
    return self.rightView.bounds.origin.x == 0;
}

#pragma mark - Embedding View Controllers
- (void)embedTopViewController:(UIViewController *)topViewController{

    [self setup];

    [self addChildViewController:topViewController];
    topViewController.view.frame = self.view.bounds;
    [self.view addSubview:topViewController.view];
    [topViewController willMoveToParentViewController:self];

    self.topViewController = topViewController;
    [self addSwipeGesturesToView:self.topViewController.view];
    [self addShadow:self.topViewController.view];

}

- (void)embedRightViewController:(UIViewController *)rightViewController{

    [self setup];

    [self addChildViewController:rightViewController];
    rightViewController.view.frame = self.rightView.bounds;
    [self.rightView addSubview:rightViewController.view];
    [rightViewController willMoveToParentViewController:self];

}

- (void)embedLeftViewController:(UIViewController *)leftViewController{

    [self setup];

    [self addChildViewController:leftViewController];
    leftViewController.view.frame = self.leftView.bounds;
    [self.leftView addSubview:leftViewController.view];
    [leftViewController willMoveToParentViewController:self];

}

#pragma MARK SwipeGesture Methods

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

// New center for the top view controller is found and then the top view is
// animated
- (void)swipeRecognized:(UISwipeGestureRecognizer *)swipe{

    CGPoint newAnchor = [self findNewAnchor:self.topViewController.view.center swipeDirection:swipe.direction];

    CGRect newFrame = CGRectMake(newAnchor.x, newAnchor.y, self.topViewController.view.bounds.size.width, self.topViewController.view.bounds.size.height);

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
        }];
    }
}

- (CGPoint)findNewAnchor:(CGPoint)center swipeDirection:(UISwipeGestureRecognizerDirection)direction{

    CGPoint oldAnchor = CGPointMake(center.x- (self.topViewController.view.bounds.size.width/2), .5);
    float shift = direction==UISwipeGestureRecognizerDirectionLeft? -1: 1;
    CGPoint newAnchor = CGPointMake(oldAnchor.x + (shift*self.topViewController.view.bounds.size.width/2), .5);

    return newAnchor;

}

#pragma MARK Shadow Effect

//Adds shadow to the top view controller giving it a layered illusion
- (void)addShadow:(UIView *)topView{

    [self.topViewController.view.layer setCornerRadius:0];
    [self.topViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.topViewController.view.layer setShadowOpacity:0.8];
    [self.topViewController.view.layer setShadowOffset:CGSizeMake(0,2.5)];
    
}

@end