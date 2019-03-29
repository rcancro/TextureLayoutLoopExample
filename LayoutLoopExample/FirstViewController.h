//
//  FirstViewController.h
//  LayoutLoopExample
//
//  Created by Ricky Cancro on 3/27/19.
//  Copyright © 2019 Ricky Cancro. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class NavigationHeaderNode;

NS_ASSUME_NONNULL_BEGIN

@interface FirstViewController : ASViewController
@property (strong, readonly) NavigationHeaderNode *headerNode;
@end

NS_ASSUME_NONNULL_END
