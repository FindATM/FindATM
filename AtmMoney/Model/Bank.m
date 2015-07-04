//
//  Bank.m
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Harris Spentzas. All rights reserved.
//

#import "Bank.h"
#import "DataHandler.h"

@interface Bank ()

@property(nonatomic,assign,readwrite) NSInteger buid;
@property(nonatomic,assign,readwrite) float longtitude;
@property(nonatomic,assign,readwrite) float latitude;
@property(nonatomic,strong,readwrite) NSString *name;
@property(nonatomic,strong,readwrite) NSString *address;
@property(nonatomic,strong,readwrite) NSString *phone;
@property(nonatomic,assign,readwrite) EBankType bankType;
@property(nonatomic,assign,readwrite) EBankState bankState;
@property(nonatomic,assign,readwrite) NSInteger visitors;
@property(nonatomic,assign,readwrite) CLLocationCoordinate2D location;

@end

@implementation Bank

- (instancetype)initWithDict:(NSDictionary *)dict {

    
    self = [super init];
    if(self) {
        self.buid = [[dict objectForKey:@"buid"] integerValue];
        self.longtitude = [[dict objectForKey:@"longitude"] floatValue];
        self.latitude = [[dict objectForKey:@"latitude"] floatValue];
        self.name = [dict objectForKey:@"name"];
        self.phone = [dict objectForKey:@"phone"];
        self.bankType = [[dict objectForKey:@"bankType"] integerValue];
        self.bankState = [[dict objectForKey:@"bankState"] integerValue];
        self.visitors = [[dict objectForKey:@"visitors"] integerValue];
        self.location = CLLocationCoordinate2DMake(self.latitude, self.longtitude);

    }
    return self;
}

- (NSString *)getBankNameFromType:(EBankType)bankType {
    switch (bankType) {
        case EBankTypeAlpha:
            return @"Alpha Bank";
            break;
        case EBankTypeAttica:
            return @"Attica Bank";
            break;
        case EBankTypeCitybank:
            return @"Citybank";
            break;
        case EBankTypeEurobank:
            return @"Eurobank";
            break;
        case EBankTypeHsbc:
            return @"HSBC";
            break;
        case EBankTypeNationalBank:
            return @"National Bank";
            break;

        case EBankTypePiraeusBank:
            return @"Piraeus Bank";
            break;
        case EBankTypePostbank:
            return @"Post Bank";
            break;
            
        default:
            break;
    }
    return @"";
}

- (NSString *)getStateNameFromState:(EBankState)bankState {
    switch (bankState) {
        case EbankStateUknown:
            return @"";
            break;
            
        case EbankStateMoneyAndTwenties:
            return @"Has Money, twenties too";
            break;

        case EBankStateNoMoney:
            return @"Empty";
            break;

        default:
            break;
    }
    return @"";
}

@end
