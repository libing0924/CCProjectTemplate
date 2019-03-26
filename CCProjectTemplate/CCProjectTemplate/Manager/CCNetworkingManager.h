//
//  LBNetworkingManager.h
//  PandaTakeaway
//
//  Created by smufs on 2017/5/17.
//  Copyright © 2017年 李冰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef CCNetworkingInstance
#define CCNetworkingInstance [CCNetworkingManager sharedManager]
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CCNetworkingManager : NSObject

typedef void(^Progress)(float progress);

typedef void(^Success)(id responseObject, NSInteger code, NSString *message);

typedef void(^Failure)(NSError *err);

// status code白名单，加入的status code不会显示相应的message信息
@property (nonatomic, copy, nullable) NSIndexSet *whiteStatusCodes;

/**
 common get request

 @param urlStr url
 @param params parameters
 @param showHUD show or not show HUD
 @param headers header
 @param progress progress
 @param success success
 @param failure failure
 */
- (void) requestGET:(NSString *) urlStr
         parameters:(NSDictionary *) params
            showHUD:(BOOL) showHUD
            headers:(NSDictionary *) headers
           progress:(Progress) progress
            success:(Success) success
            failure:(Failure) failure;

- (void) requestGET:(NSString *) urlStr
         parameters:(NSDictionary *) params
            showHUD:(BOOL) showHUD
            success:(Success) success
            failure:(Failure) failure;

- (void) requestGET:(NSString *) urlStr
         parameters:(NSDictionary *) params
            showHUD:(BOOL) showHUD
            success:(Success) success;

/**
 *  上传图片
 *
 *  @param operations   上传图片预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @parm size      图片要被压缩到的大小 KB
 *  @param urlString    上传的url
 *  @param success 上传成功的回调
 *  @param failure 上传失败的回调
 *  @param progress     上传进度
 */
- (void)uploadImageWithOperations:(NSDictionary *)operations
                       ImageArray:(NSArray *)imageArray
                      targetWidth:(CGFloat )width
                       targetSize:(CGFloat) size
                        UrlString:(NSString *)urlString
                         progress:(Progress)progress
                          success:(Success)success
                          failure:(Failure)failure;

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

/**
 *  上传视频
 *
 *  @param videoPath    视频本地路径
 *  @param myRequestUrl 上传服务器地址
 */
- (void)uploadVideoWithPath:(NSString *)videoPath severUrl:(NSString *) myRequestUrl successBlock:(Success) block;



/**
 全局类

 @return 网络请求单例
 */
+ (CCNetworkingManager *) sharedManager;

- (void) requestPOST:(NSString *) urlStr
          parameters:(NSDictionary *) params
             showHUD:(BOOL) showHUD
             headers:(NSDictionary *) headers
            progress:(Progress) progress
             success:(Success) success
             failure:(Failure) failure;

- (void) requestPOST:(NSString *) urlStr
          parameters:(NSDictionary *) params
             showHUD:(BOOL) showHUD
             success:(Success) success
             failure:(Failure) failure;

@end

NS_ASSUME_NONNULL_END
