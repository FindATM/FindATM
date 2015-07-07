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

@dynamic data;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.banksData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *)data {
    NSMutableArray *initialData = self.banksData;

    if (self.selectedBanksToFilter) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.bankType IN %@", self.selectedBanksToFilter];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];

        self.banksData = [[self.banksData filteredArrayUsingPredicate:predicate] mutableCopy];
        [self.banksData sortUsingDescriptors:@[sort]];
    }
    
    initialData = self.banksData;
    return initialData;
}

- (void)getNearestBanksWithLocation:(CLLocation *)location andDistance:(CGFloat)distance withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure {
   
    [Eng postMethod:GET_NEAREST_BANKS_URL
         parameters:@{@"lng": @(location.coordinate.longitude), @"lat":@(location.coordinate.latitude), @"distance":[NSNumber numberWithFloat:distance]}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                    NSLog(@"JSON: %@", responseObject);
                    if ([responseObject objectForKey:@"error"]) {
                        if (failure != nil)
                            failure();
                        return;
                    }
                
                    self.banksData = [[NSMutableArray alloc] init];
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
    
    
    [Eng postMethod:GET_BANK_HISTORY_URL
         parameters:@{@"buid": @(buid)}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                if ([responseObject objectForKey:@"error"]) {
                    if (failure != nil)
                        failure();
                    return;
                }
                
                self.bankHistoryData = [[NSMutableArray alloc] init];
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
