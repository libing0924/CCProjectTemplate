//
//  CCConvenientRequest.h
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/3/25.
//  Copyright © 2019 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCRawDataProcess <NSObject>

@required
- (void)responseSuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

@protocol CCRequestMaskProgressHUD <NSObject>

@required
- (void)showProgressHUD;
- (void)showError:(NSString *)errorMsg;
- (void)showSuccess:(NSString *)successMsg;

@end

@interface CCResponseMetaModel : NSObject

@property (nonatomic, strong) id rawData;
@property (nonatomic, strong) id ripeData;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@interface CCConvenientRequest : NSObject

@property (nonatomic, strong) id<CCRawDataProcess> dataProcess;
@property (nonatomic, strong) id<CCRequestMaskProgressHUD> progressHUD;

// 模型绑定
- (void)requestGET:(NSString *)urlStr
        parameters:(NSDictionary *)params
          response:(nullable void (^)(CCResponseMetaModel *metaModel))success;

// 缓存绑定
- (void)cacheRequest:(NSString *)urlStr;

@end
