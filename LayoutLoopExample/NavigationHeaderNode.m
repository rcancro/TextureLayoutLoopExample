//
//  NavigationHeaderNode.m
//  LayoutLoopExample
//
//  Created by Ricky Cancro on 3/27/19.
//  Copyright © 2019 Ricky Cancro. All rights reserved.
//

#import "NavigationHeaderNode.h"

@implementation NavigationHeaderNode

- (void)setButton:(ASControlNode *)button
{
    [_button removeFromSupernode];
    _button = button;
    [self addSubnode:button];
}

#pragma mark - Layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSArray *children = self.button ? @[self.button] : @[];
    return [ASAbsoluteLayoutSpec absoluteLayoutSpecWithSizing:ASAbsoluteLayoutSpecSizingSizeToFit children:children];
}

@end
