//
//  CCPagingRequestControl.m
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/3/25.
//  Copyright © 2019 CC. All rights reserved.
//

#import "CCPagingRequest.h"
#import "CCNetworkingManager.h"

static NSArray *(^cc_rawDataListHandle)(id responseObject);

static NSInteger(^cc_statusCodeHandle)(id responseObject);

static NSInteger cc_success_code = 200;

@implementation CCPagingRequest

- (instancetype)init {
    
    if (self = [super init]) {
        
        _pageNumber = 1;
        _pageSize = 10;
    }
    
    return self;
}

- (void)firstPageRequest:(void(^)(NSMutableArray *dataSource))callback {
    
    _pageNumber = 1;
    self.mj_footer.hidden = YES;
    [self requestGET:self.url.absoluteString response:callback];
}

- (void)nextPageRequest:(void(^)(NSMutableArray *dataSource))callback {
    
    self.mj_header.hidden = YES;
    [self requestGET:self.url.absoluteString response:callback];
}

- (void)requestGET:(NSString *)urlStr response:(void(^)(NSMutableArray *dataSource))success {
    
    NSDictionary *parameters = nil;
    if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(parametersWithPagingRequest:)]) {
        
        parameters = [self.requestDelegate parametersWithPagingRequest:self];
    }
    
    [[CCNetworkingManager sharedManager] requestGET:urlStr parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self _endRefreshAnimation];
        
        NSArray *rawDataList = nil;
        NSInteger statusCode = 0;
        
        [self _handleResponseObject:responseObject rawDataList:&rawDataList statusCode:&statusCode];
        
        [self _requestSuccess:rawDataList statusCode:statusCode];
            
        if (success && statusCode == cc_success_code) {
            
            success(self.dataSource);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self _endRefreshAnimation];
    }];
}

- (void)_handleResponseObject:(id)responseObject rawDataList:(NSArray **)rawDataList statusCode:(NSInteger *)statusCode {
    
    if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(rawDataListWithResponseObject:)]) {
        
        NSArray *array = [self.requestDelegate rawDataListWithResponseObject:responseObject];
        if ([array isKindOfClass:NSArray.class]) {
            
            *rawDataList = array;
        }
    } else if (cc_rawDataListHandle) {
        
        NSArray *array = cc_rawDataListHandle(responseObject);
        if ([array isKindOfClass:NSArray.class]) {
            
            *rawDataList = array;
        }
    } else {
        
        NSArray *array = responseObject[@"data"];
        if ([array isKindOfClass:NSArray.class]) {
            
            *rawDataList = array;
        }
    }
    
    if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(statusCodeWithResponseObject:)]) {
        
        NSInteger code = [self.requestDelegate statusCodeWithResponseObject:responseObject];
        *statusCode = code;
    } else if (cc_rawDataListHandle) {
        
        NSInteger code = cc_statusCodeHandle(responseObject);
        *statusCode = code;
    } else {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        *statusCode = code;
    }
}

- (void)_requestSuccess:(NSArray *)rawListData statusCode:(NSInteger)statusCode {
    
    if (statusCode == cc_success_code) {
        
        if (self.pageNumber == 1) [self.dataSource removeAllObjects];
        
        NSArray *datas = [NSArray arrayWithArray:rawListData];
        
        [self.dataSource addObjectsFromArray:datas];
        
        if (datas.count < self.pageSize) {
            
            [self.mj_footer endRefreshingWithNoMoreData];
        } else {
            
            self.pageNumber++;
        }
    }
}

- (void)_endRefreshAnimation {
    
    self.mj_header.hidden = NO;
    self.mj_footer.hidden = NO;
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (NSMutableArray *)dataSource {
    
    if (_dataSource) return _dataSource;
    
    _dataSource = @[].mutableCopy;
    
    return _dataSource;
}

#pragma mark - Globe Configuration
+ (void)rawDataList:(NSArray *(^)(id responseObject))rawDataListHandle {
    
    cc_rawDataListHandle = rawDataListHandle;
}

+ (void)statusCode:(NSInteger(^)(id responseObject))statusCodeHandle {
    
    cc_statusCodeHandle = statusCodeHandle;
}

+ (void)setSuccessStatusCode:(NSInteger)successCode {
    
    cc_success_code = successCode;
}

@end
