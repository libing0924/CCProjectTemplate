//
//  CCBasePagingViewController.m
//  BluetoothScale
//
//  Created by 李冰 on 2019/4/29.
//  Copyright © 2019 CC. All rights reserved.
//

#import "CCBasePagingViewController.h"

@interface CCBasePagingViewController ()<CCPagingRequestProtocol>

@end

@implementation CCBasePagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_headerRefresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_requestData)];
    self.pagingRequest.mj_header = self.tableView.mj_header;
    self.pagingRequest.mj_footer = self.tableView.mj_footer;
    
    self.pagingRequest.requestDelegate = self;
}

- (void)_requestData {
    
    WEAKSELF;
    [self.pagingRequest nextPageRequest:^(NSMutableArray *dataSource) {
        
        [weakSelf.tableView reloadData];
    }];
}

- (void)_headerRefresh {
    
    WEAKSELF;
    [self.pagingRequest firstPageRequest:^(NSMutableArray *dataSource) {
        
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.pagingRequest.dataSource.count;
}

- (NSDictionary *)parametersWithPagingRequest:(CCPagingRequest *)pagingRequest {
    
    return [self requestParameters];
}

- (Class)ripeDataModel {
    
    return [self needRipeModel];
}

- (Class)needRipeModel {
    
    return nil;
}

- (NSDictionary *)requestParameters {
    
    return nil;
}

@end
