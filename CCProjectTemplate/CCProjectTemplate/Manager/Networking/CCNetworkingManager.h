//
//  LBNetworkingManager.h
//  PandaTakeaway
//
//  Created by smufs on 2017/5/17.
//  Copyright © 2017年 李冰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCNetworkingManager : NSObject

typedef void(^Progress)(float progress);

typedef void(^Success)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);

typedef void(^Failure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

+ (CCNetworkingManager *)sharedManager;

// status code白名单，加入的status code不会显示相应的message信息
@property (nonatomic, copy, nullable) NSIndexSet *whiteStatusCodes;

// status code白名单，加入的status code不会显示相应的message信息
@property (nonatomic, copy, nullable) id configuration;

- (void)requestGET:(NSString *)urlStr
        parameters:(NSDictionary *)params
           headers:(NSDictionary *)headers
           success:(Success)success
           failure:(Failure)failure;

- (void)requestPOST:(NSString *)urlStr
         parameters:(NSDictionary *)params
            headers:(NSDictionary *)headers
            success:(Success)success
            failure:(Failure)failure;

- (void)uploadImageWithOperations:(NSDictionary *)operations
                       ImageArray:(NSArray *)imageArray
                        UrlString:(NSString *)urlString
                         progress:(Progress)progress
                          success:(Success)success
                          failure:(Failure)failure;

/**
 *  上传视频
 *
 *  @param videoPath    视频本地路径
 *  @param myRequestUrl 上传服务器地址
 */
- (void)uploadVideoWithPath:(NSString *)videoPath severUrl:(NSString *) myRequestUrl successBlock:(Success) block;

/**
 *  取消所有的网络请求
 */
- (void)cancelAllRequest;

/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的url
 */

- (void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
