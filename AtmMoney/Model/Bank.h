//
//  Bank.h
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Harris Spentzas. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    EbankStateUknown,
    EbankStateMoneyAndTwenties,
    EbankStateMoneyNoTwenties,
    EBankStateNoMoney
} EBankState;

typedef enum : NSUInteger {
    EBankTypePiraeusBank = 0,
    EBankTypeAttica,
    EBankTypeEurobank,
    EBankTypeAlpha,
    EBankTypeCitybank,
    EBankTypePostbank,
    EBankTypeHsbc,
    EBankTypeNationalBank,
} EBankType;

@interface Bank : NSObject

@property(nonatomic,assign,readonly)NSInteger buid;
@property(nonatomic,assign,readonly)float longtitude;
@property(nonatomic,assign,readonly)float latitude;
@property(nonatomic,strong,readonly)NSString *name;
@property(nonatomic,strong,readonly)NSString *phone;
@property(nonatomic,assign,readonly)EBankType bankType;
@property(nonatomic,assign,readonly)EBankState bankState;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
