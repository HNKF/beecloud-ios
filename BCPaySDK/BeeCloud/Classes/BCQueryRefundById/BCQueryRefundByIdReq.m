//
//  BCQueryRefundByIdReq.m
//  BCPay
//
//  Created by Ewenlong03 on 15/11/25.
//  Copyright © 2015年 BeeCloud. All rights reserved.
//

#import "BCQueryRefundByIdReq.h"

#import "BCPayUtil.h"

@implementation BCQueryRefundByIdReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = BCObjsTypeQueryRefundByIdReq;
        self.objectId = @"";
    }
    return self;
}

- (instancetype)initWithObjectId:(NSString *)objectId {
    BCQueryRefundByIdReq *req = [[BCQueryRefundByIdReq alloc] init];
    req.objectId = objectId;
    return req;
}

#pragma mark - QueryRefundById

- (void)queryRefundByIdReq {
    
    [BCPayCache sharedInstance].bcResp = [[BCQueryRefundByIdResp alloc] initWithReq:self];
    
    if (!self.objectId.isValidUUID) {
        [BCPayUtil doErrorResponse:@"objectId 不合法"];
        return;
    }
    NSMutableDictionary *parameters = [BCPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [BCPayUtil doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    NSMutableDictionary *preparepara = [BCPayUtil getWrappedParametersForGetRequest:parameters];
    
    NSString *preHost = [BCPayUtil getBestHostWithFormat:kRestApiQueryRefundById];
    NSString *host = [NSString stringWithFormat:@"%@%@", preHost, self.objectId];
    
    AFHTTPRequestOperationManager *manager = [BCPayUtil getAFHTTPRequestOperationManager];
    __weak BCQueryRefundByIdReq *weakSelf = self;
    [manager GET:host parameters:preparepara
         success:^(AFHTTPRequestOperation *operation, id response) {
             [weakSelf doQueryRefundByIdResponse:(NSDictionary *)response];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [BCPayUtil doErrorResponse:kNetWorkError];
         }];
}

- (BCQueryRefundByIdResp *)doQueryRefundByIdResponse:(NSDictionary *)response {
    BCQueryRefundByIdResp *resp = (BCQueryRefundByIdResp *)[BCPayCache sharedInstance].bcResp;
    resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:BCErrCodeCommon];
    resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    resp.refund = [[BCQueryRefundResult alloc] initWithResult:[response dictValueForKey:@"refund"  defaultValue:nil]];
    [BCPayCache beeCloudDoResponse];
    return resp;
}

@end
