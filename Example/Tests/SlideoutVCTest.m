//
//  SlideoutVCTest.m
//  VHSlideoutController
//
//  Created by Varindra Hart on 1/11/16.
//  Copyright © 2016 Varindra. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VHViewController.h"
#import "VHViewController+Tested.h"

@interface SlideoutVCTest : XCTestCase
@property (nonatomic) VHViewController *vcToTest;
@end

@implementation SlideoutVCTest

- (void)setUp {
    [super setUp];
    self.vcToTest = [[VHViewController alloc]init];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVCSetup {

    [self.vcToTest setupViews];

    XCTAssertNotEqual(self.vcToTest.leftView.bounds.size.width, 0);
    
    XCTAssertNotEqual(self.vcToTest.rightView.center.x, 0);

}

@end
