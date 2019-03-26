//
//  BaseNavigationController.m
//  BoLiYuan
//
//  Created by 李冰 on 2018/10/18.
//  Copyright © 2018年 BL. All rights reserved.
//

#import "CCBaseNavigationController.h"
#import "UIImage+LBWithColor.h"

@interface CCBaseNavigationController ()

@end

@implementation CCBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage hyb_imageWithColor:[UIColor colorWithHex:0x1E1F21] toSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.navigationBar.frame))] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
}

+ (void)initialize {
    
    // 设置整个项目的navigationBar属性
    UINavigationBar *bar = [UINavigationBar appearance];
    // 背景色
//    bar.barTintColor = [UIColor colorWithHex:0xFFBF27];
    //    bar.tintColor = kColor(colorWithHexString:@"FFFFFF");
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0xFFBF27],NSForegroundColorAttributeName, [UIFont systemFontOfSize:14],NSFontAttributeName , nil] forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"navigationButtonReturn"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navigationButtonReturn"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -2) forBarMetrics:UIBarMetricsDefault];
    // 标题颜色
    bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]};
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"ic_top_back"] forState:UIControlStateNormal];
        // [button setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 30, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    
    return self.topViewController;
}

@end
