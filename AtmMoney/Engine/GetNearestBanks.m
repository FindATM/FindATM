//
//  GetNearestBanks.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "GetNearestBanks.h"
#import "Bank.h"
#import "BankHistory.h"

#define GET_NEAREST_BANKS_URL @"getNearestBanks"
#define GET_BANK_HISTORY_URL @"getBankHistory"

@implementation GetNearestBanks

- (instancetype)init {
    self = [super init];
    if (self) {
        self.banksData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getNearestBanksWithLocation:(CLLocation *)location withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure {
   
    self.banksData = [[NSMutableArray alloc] init];
    
    [Eng postMethod:GET_NEAREST_BANKS_URL
         parameters:@{@"lng": @(location.coordinate.longitude), @"lat":@(location.coordinate.latitude)}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                    NSLog(@"JSON: %@", responseObject);
                    if ([responseObject objectForKey:@"error"]) {
                        if (failure != nil)
                            failure();
                        return;
                    }
                    
                    NSArray *banks = [responseObject objectForKey:@"banks"];
                    
                    [banks enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                        Bank *bank = [[Bank alloc] initWithDict:dict];
                        [self.banksData addObject:bank];
                    }];
                    
                    if (completion != nil)
                        completion();
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Network Failure");
                    if (failure != nil) {
                        failure();
                    }
            }];
    
}
- (void)getBankHistoryWithId:(NSInteger)buid withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure {
    
    self.bankHistoryData = [[NSMutableArray alloc] init];
    
    [Eng postMethod:GET_BANK_HISTORY_URL
         parameters:@{@"buid": @(buid)}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                if ([responseObject objectForKey:@"error"]) {
                    if (failure != nil)
                        failure();
                    return;
                }
                
                NSArray *history = [responseObject objectForKey:@"bankHistory"];
                
                [history enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                    BankHistory *bankHistory = [[BankHistory alloc] initWithDict:dict];
                    if(bankHistory.bankState == EbankStateUknown)
                        return ;
                    [self.bankHistoryData addObject:bankHistory];
                }];
                
                if (completion != nil)
                    completion();
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Network Failure");
                if (failure != nil) {
                    failure();
                }
            }];
    
}

@end
