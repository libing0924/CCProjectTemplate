//
//  CCPagingRequestControl.h
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/3/25.
//  Copyright © 2019 CC. All rights reserved.
//

// 采用装饰者模式
#import <Foundation/Foundation.h>
#import <MJRefreshHeader.h>
#import <MJRefreshFooter.h>

@class CCPagingRequest;

@protocol CCPagingRequestProtocol <NSObject>

@optional
- (NSDictionary *)parametersWithPagingRequest:(CCPagingRequest *)pagingRequest;
- (NSArray *)rawDataListWithResponseObject:(id)responseObject;
- (NSInteger)statusCodeWithResponseObject:(id)responseObject;
- (Class)ripeDataModel;

@end

@interface CCPagingRequest : NSObject

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) id<CCPagingRequestProtocol> requestDelegate;

@property (nonatomic, weak) MJRefreshHeader *mj_header;
@property (nonatomic, weak) MJRefreshFooter *mj_footer;

- (void)firstPageRequest:(void(^)(NSMutableArray *dataSource))callback;

- (void)nextPageRequest:(void(^)(NSMutableArray *dataSource))callback;

// 全局配置
// 需要获取的列表数据
+ (void)rawDataList:(NSArray *(^)(id responseObject))rawDataListHandle;
// 需要获取的请求的状态码
+ (void)statusCode:(NSInteger(^)(id responseObject))statusCodeHandle;
// default 200
+ (void)setSuccessStatusCode:(NSInteger)successCode;

@end
