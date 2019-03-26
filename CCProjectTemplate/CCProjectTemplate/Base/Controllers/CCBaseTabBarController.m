//
//  BaseTabBarViewController.m
//  BoLiYuan
//
//  Created by 李冰 on 2018/10/18.
//  Copyright © 2018年 BL. All rights reserved.
//

#import "CCBaseTabBarController.h"
#import "CCBaseNavigationController.h"

@interface CCBaseTabBarController ()

@end

@implementation CCBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *market = [[ALMarketViewController alloc] init];
    market.title = @"Market";
    market.tabBarItem.image = [[UIImage imageNamed:@"ic_bottom_market"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    market.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_bottom_market_p"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CCBaseNavigationController *marketNavi = [[BaseNavigationController alloc] initWithRootViewController:market];

    UIViewController *browse = [[ALBrowseViewController alloc] init];
    browse.title = @"Browse";
    browse.tabBarItem.image = [[UIImage imageNamed:@"ic_bottom_browse"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    browse.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_bottom_browse_p"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CCBaseNavigationController *browseNavi = [[BaseNavigationController alloc] initWithRootViewController:browse];
    
    UIViewController *search = [[ALSearchViewController alloc] init];
    search.title = @"Search";
    search.tabBarItem.image = [[UIImage imageNamed:@"ic_bottom_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    search.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_bottom_search_p"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CCBaseNavigationController *searchNavi = [[BaseNavigationController alloc] initWithRootViewController:search];
    
    UIViewController *account = [[ALAccountViewController alloc] init];
    account.title = @"Account";
    account.tabBarItem.image = [[UIImage imageNamed:@"ic_bottom_account"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    account.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_bottom_account_p"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CCBaseNavigationController *accountNavi = [[BaseNavigationController alloc] initWithRootViewController:account];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0X515356],NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0xFFFFFF],NSForegroundColorAttributeName,nil]forState:UIControlStateSelected];
    [self setViewControllers:@[marketNavi, browseNavi, searchNavi, accountNavi]];
    
}

@end
