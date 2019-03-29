# TextureLayoutLoopExample
The simplest example I can come up with that shows a infinite layout loop in Texture

I found a layout loop in Texture dealing with nodes in a UINavigationItem's titleView. The steps are rougly:
1) Create a ASDisplayNode with a subnode (I used a button) and set it as a VC's navigationItem's titleView.
2) Push another VC
3) Cause the subnode in the titleView in the first VC to relayout.
4) Pop the 2nd VC

I have put up a PR to fix the loop here: https://github.com/TextureGroup/Texture/pull/1434

I tried to create a unit test to reproduce this, but didn't have any luck. This is what I came up with if it is useful:

```

#import <XCTest/XCTest.h>

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASDisplayNode(Private)
- (void)__enterHierarchy;
@end

@interface NavigationHeaderNode : ASDisplayNode
@property (nonatomic, strong, nullable) ASControlNode *button;
@end

@implementation NavigationHeaderNode

- (void)setButton:(ASControlNode *)button
{
  [_button removeFromSupernode];
  _button = button;
  [self addSubnode:button];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
  NSArray *children = self.button ? @[self.button] : @[];
  return [ASAbsoluteLayoutSpec absoluteLayoutSpecWithSizing:ASAbsoluteLayoutSpecSizingSizeToFit children:children];
}
@end

@interface SecondViewController : ASViewController
@end

@interface FirstViewController : ASViewController
@property (strong) NavigationHeaderNode *headerNode;
@property (strong) ASButtonNode *navButton1;
@end

@implementation FirstViewController

- (instancetype)init
{
  ASButtonNode *button = [[ASButtonNode alloc] init];
  [button setTitle:@"Push VC" withFont:[UIFont systemFontOfSize:23] withColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  
  ASDisplayNode *node = [[ASDisplayNode alloc] init];
  node.automaticallyManagesSubnodes = YES;
  node.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
    return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:button];
  };
  
  self = [self initWithNode:node];
  if (self) {
    _navButton1 = [[ASButtonNode alloc] init];
    [_navButton1 setTitle:@"Hello" withFont:[UIFont systemFontOfSize:23] withColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_navButton1 setTitle:@"Hello!!" withFont:[UIFont systemFontOfSize:23] withColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    
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
  self.navigationItem.titleView.frame = CGRectMake(0, 0, 375, 44);
}

- (void)buttonTapped:(id)sender
{
  SecondViewController *secondVC = [[SecondViewController alloc] init];
  [self.navigationController pushViewController:secondVC animated:YES];
}

@end

@implementation SecondViewController

- (instancetype)init
{
  return [self initWithNode:[[ASDisplayNode alloc] init]];
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

@interface ASDisplayNodeRequestLayoutFromAboveTests : XCTestCase
@end

@implementation ASDisplayNodeRequestLayoutFromAboveTests

- (void)testRequestLayoutFromAbove
{
  FirstViewController *firstViewController = [[FirstViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
  [firstViewController.view setNeedsLayout];
  [firstViewController.view layoutIfNeeded];
  
  UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [window makeKeyAndVisible];
  window.rootViewController = navController;

  SecondViewController *secondViewController = [[SecondViewController alloc] init];
  
  [navController pushViewController:secondViewController animated:NO];
  
  [secondViewController.view setNeedsLayout];
  [secondViewController.view layoutIfNeeded];
  
  ASControlNode *button = firstViewController.headerNode.button;
  button.selected = !button.selected;
  
  [navController popViewControllerAnimated:NO];
  
  [firstViewController.headerNode layoutIfNeeded];
  firstViewController.headerNode.frame = CGRectMake(0, 0, 375, 0);
  firstViewController.headerNode.button.frame = CGRectMake(0, 0, 51.5, 27.5);
  [firstViewController.headerNode.button __enterHierarchy];
}
```
