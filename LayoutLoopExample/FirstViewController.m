//
//  FirstViewController.m
//  LayoutLoopExample
//
//  Created by Ricky Cancro on 3/27/19.
//  Copyright © 2019 Ricky Cancro. All rights reserved.
//

#import "FirstViewController.h"

#import "SecondViewController.h"
#import "NavigationHeaderNode.h"

@interface FirstViewController ()
@property (strong) ASButtonNode *navButton1;
@property (strong, readwrite) NavigationHeaderNode *headerNode;
@end

@implementation FirstViewController

- (instancetype)init
{
    self = [self initWithNode:[[ASDisplayNode alloc] init]];
    if (self) {
        self.node.backgroundColor = [UIColor whiteColor];
        
        _navButton1 = [[ASButtonNode alloc] init];
        [_navButton1 setTitle:@"Hello" withFont:[UIFont systemFontOfSize:23] withColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_navButton1 setTitle:@"Hello!!" withFont:[UIFont systemFontOfSize:23] withColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        
        ASTextNode *textNode = [[ASTextNode alloc] init];
        textNode.attributedText = [[NSAttributedString alloc] initWithString:@"Tap the \"Push VC\" to push a new VC. The new VC will select the \"Hello\" button above when it appears. Tap on the back button in the nav bar and we will enter an infinite layout loop."
                                                                  attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:20]}];

        ASButtonNode *button = [[ASButtonNode alloc] init];
        [button setTitle:@"Push VC" withFont:[UIFont systemFontOfSize:23] withColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        self.node.automaticallyManagesSubnodes = YES;
        self.node.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            ASStackLayoutSpec *verticalSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
            verticalSpec.spacing = 12;
            verticalSpec.children = @[ textNode, button ];
            ASCenterLayoutSpec *centerSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:verticalSpec];
            return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 16, 0, 16) child:centerSpec];
        };

        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationHeaderNode *headerNode = [[NavigationHeaderNode alloc] init];
    headerNode.button = self.navButton1;
    self.headerNode = headerNode;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = headerNode.view;
}

- (void)buttonTapped:(id)sender
{
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

@end
