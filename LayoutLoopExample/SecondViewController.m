//
//  SecondViewController.m
//  LayoutLoopExample
//
//  Created by Ricky Cancro on 3/27/19.
//  Copyright © 2019 Ricky Cancro. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstViewController.h"
#import "NavigationHeaderNode.h"

@interface SecondViewController ()
@end

@implementation SecondViewController

- (instancetype)init
{
    self = [self initWithNode:[[ASDisplayNode alloc] init]];
    if (self) {
        self.node.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    FirstViewController *firstViewController = (FirstViewController *)[self.navigationController.viewControllers firstObject];
    ASControlNode *button = firstViewController.headerNode.button;
    button.selected = !button.selected;
}

@end
