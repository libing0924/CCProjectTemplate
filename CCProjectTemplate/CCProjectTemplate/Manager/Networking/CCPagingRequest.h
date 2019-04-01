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

@end

@interface CCPagingRequest : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) id<CCPagingRequestProtocol> requestDelegate;

@property (nonatomic, weak) MJRefreshHeader *mj_header;
@property (nonatomic, weak) MJRefreshFooter *mj_footer;

- (void)firstPageRequest:(void(^)(NSMutableArray *dataSource))callback;

- (void)nextPageRequest:(void(^)(NSMutableArray *dataSource))callback;

@end
