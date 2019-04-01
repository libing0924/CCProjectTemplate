//
//  CCPagingRequestControl.m
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/3/25.
//  Copyright © 2019 CC. All rights reserved.
//

#import "CCPagingRequest.h"
#import "CCNetworkingManager.h"

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
    [self requestGET:@"" response:nil];
}

- (void)nextPageRequest:(void(^)(NSMutableArray *dataSource))callback {
    
    self.mj_header.hidden = YES;
    [self requestGET:@"" response:nil];
}

- (void)requestGET:(NSString *)urlStr response:(void (^)(id))success {
    
    NSDictionary *parameters = nil;
    if (self.requestDelegate && [self.requestDelegate respondsToSelector:@selector(parametersWithPagingRequest:)]) {
        
        parameters = [self.requestDelegate parametersWithPagingRequest:self];
    }
    
    
}

- (void)_requestSuccess:(id)responseObject {
    
    [self _endRefreshAnimation];
    
    NSInteger code = [responseObject[@"code"] integerValue];
    
    if (code == 200) {
        
        if (self.pageNumber == 1) [self.dataSource removeAllObjects];
        
        NSArray *datas = [NSArray arrayWithArray:responseObject[@"data"]];
        
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

@end
