//
//  LBUserManager.h
//  PanlongWaterAffairs
//
//  Created by 李冰 on 2018/11/9.
//  Copyright © 2018年 PL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CCUserLoginSuccess)(BOOL loginSuccess);

@interface CCUserManager : NSObject

@property (nonatomic, strong) NSDictionary *userModel;

/**
 Must set user token when user login success.
 */
@property (nonatomic, strong) NSString *userToken;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign, readonly) BOOL isLogin;

+ (instancetype)shareInstance;

/**
 Initialize user manager.
 */
- (void)setupManager;

/**
 User logout.
 */
- (void)logout;

/**
 Check user login status.

 @param loginCallback Invocked when user login success.
 */
- (void)checkLoginThen:(CCUserLoginSuccess)loginCallback;

@end
