//
//  VHViewController.m
//  VHSlideoutController
//
//  Created by Varindra Hart on 1/11/16.
//  Copyright © 2016 Varindra. All rights reserved.
//

#import "VHViewController.h"

@interface VHViewController ()

@end

@implementation VHViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
}

- (void)setupViews{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *left = [storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    UIViewController *right = [storyboard instantiateViewControllerWithIdentifier:@"RightViewController"];
    UIViewController *top = [storyboard instantiateViewControllerWithIdentifier:@"TopViewController"];



}

@end
