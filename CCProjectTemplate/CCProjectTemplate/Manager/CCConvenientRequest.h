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

@interface CCResponseMetaModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) id rawData;
@property (nonatomic, strong) id ripeData;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL success;

@end

@interface CCConvenientRequest : NSObject

// 模型绑定
- (void)requestGET:(NSString *)urlStr
        parameters:(NSDictionary *)params
          response:(nullable void (^)(CCResponseMetaModel *metaModel))success;

// 缓存绑定
- (void)cacheRequest:(NSString *)urlStr;

@end
