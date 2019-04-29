//
//  BaseTabBarViewController.m
//  BoLiYuan
//
//  Created by 李冰 on 2018/10/18.
//  Copyright © 2018年 BL. All rights reserved.
//

#import "CCBaseTabBarController.h"
#import "CCBaseNavigationController.h"

#import "BSHomeViewController.h"
#import "BSHistoryViewController.h"
#import "BSCircleViewController.h"
#import "BSMineViewController.h"

@interface CCBaseTabBarController ()

@end

@implementation CCBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setTranslucent:NO];
    
    UIViewController *market = [[BSHomeViewController alloc] init];
    market.title = NSLocalizedString(@"Tab Home", nil);
    market.tabBarItem.image = [[UIImage imageNamed:@"tab_bar_history_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    market.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_bar_history_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIViewController *browse = [[BSHistoryViewController alloc] init];
    browse.title = NSLocalizedString(@"Tab History", nil);
    browse.tabBarItem.image = [[UIImage imageNamed:@"tab_bar_history_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    browse.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_bar_history_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CCBaseNavigationController *browseNavi = [[CCBaseNavigationController alloc] initWithRootViewController:browse];
    
    UIViewController *search = [[BSCircleViewController alloc] init];
    search.title = NSLocalizedString(@"Tab Circle", nil);
    search.tabBarItem.image = [[UIImage imageNamed:@"tab_bar_circle_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    search.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_bar_circle_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CCBaseNavigationController *searchNavi = [[CCBaseNavigationController alloc] initWithRootViewController:search];
    
    UIViewController *account = [[BSMineViewController alloc] init];
    account.title = NSLocalizedString(@"Tab Mine", nil);
    account.tabBarItem.image = [[UIImage imageNamed:@"tab_bar_history_user_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    account.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_bar_history_user_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CCBaseNavigationController *accountNavi = [[CCBaseNavigationController alloc] initWithRootViewController:account];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0X515356],NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0x3CB5FB],NSForegroundColorAttributeName,nil]forState:UIControlStateSelected];
    [self setViewControllers:@[market, browseNavi, searchNavi, accountNavi]];
}

@end
