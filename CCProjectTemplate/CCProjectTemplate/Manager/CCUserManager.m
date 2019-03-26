//
//  LBUserManager.m
//  PanlongWaterAffairs
//
//  Created by 李冰 on 2018/11/9.
//  Copyright © 2018年 PL. All rights reserved.
//

#import "CCUserManager.h"

#define USER_ID_KEY @"user.model.persistence.id.key"
#define USER_TOKEN_KEY @"user.model.persistence.token.key"
#define USER_MODEL_KEY @"user.model.persistence.model.key"

@interface CCUserManager ()

@property (nonatomic, copy) CCUserLoginSuccess loginCallback;

@end

@implementation CCUserManager

+ (instancetype)shareInstance {
    
    static CCUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CCUserManager alloc] init];
    });
    
    return manager;
}

- (void)setupManager {
    
    _userToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN_KEY];
    _userModel = [[NSUserDefaults standardUserDefaults] objectForKey:USER_MODEL_KEY];
    _userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
}

- (void)setUserModel:(NSDictionary *)userModel {
    
    _userModel = userModel;
    [self _persistenceObject:userModel forKey:USER_MODEL_KEY];
}

- (void)setUserToken:(NSString *)userToken {
    
    _userToken = userToken;
    [self _persistenceObject:_userToken forKey:USER_TOKEN_KEY];
    
    if (_userToken) [self _invokeLoginCallback];
}

- (void)setUserId:(NSString *)userId {
    
    _userId = userId;
    [self _persistenceObject:_userId forKey:USER_ID_KEY];
}

- (void)_persistenceObject:(id)object forKey:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)_invokeLoginCallback {
    
    if (_loginCallback) _loginCallback(self.isLogin);
    
    _loginCallback = nil;
}

- (void)checkLoginThen:(CCUserLoginSuccess)loginCallback {
    
    _loginCallback = loginCallback;
}

- (BOOL)isLogin {
    
    return _userToken ? YES : NO;
}

- (void)logout {
    
    self.userModel = nil;
    self.userToken = nil;
    self.userId = nil;
}

@end
