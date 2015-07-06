//
//  Bank.h
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bank.h"


@interface BankHistory : NSObject

@property(nonatomic,assign,readonly) EBankState bankState;
@property(nonatomic,strong,readonly) NSDate *time;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (NSString *)getBankNameFromType:(EBankType)bankType;

- (NSString *)getStateNameFromState:(EBankState)bankState;

@end
