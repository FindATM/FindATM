//
//  Bank.m
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "BankHistory.h"


@interface BankHistory ()

@property(nonatomic,assign,readwrite) EBankState bankState;
@property(nonatomic,strong,readwrite) NSDate *time;

@end

@implementation BankHistory {

    NSDateFormatter *formatter;
}

- (instancetype)initWithDict:(NSDictionary *)dict {

    
    self = [super init];
    if(self) {
        self.bankState = [[dict objectForKey:@"state"] integerValue];
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Athens"];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.time = [formatter dateFromString:[dict objectForKey:@"time"]];

    }
    return self;
}

- (NSString *)getBankNameFromType:(EBankType)bankType {
    switch (bankType) {
        case EBankTypeAlpha:
        case EBankTypeCitybank:
            return NSLocalizedStringFromTable(@"bank.alphabank", @"Localization", nil);
            break;
        case EBankTypeAttica:
            return NSLocalizedStringFromTable(@"bank.atticabank", @"Localization", nil);
            break;
        case EBankTypeEurobank:
            return NSLocalizedStringFromTable(@"bank.eurobank", @"Localization", nil);
            break;
        case EBankTypeHsbc:
            return NSLocalizedStringFromTable(@"bank.hsbc", @"Localization", nil);
            break;
        case EBankTypeNationalBank:
            return NSLocalizedStringFromTable(@"bank.nationalbank", @"Localization", nil);
            break;

        case EBankTypePiraeusBank:
            return NSLocalizedStringFromTable(@"bank.piraeusbank", @"Localization", nil);
            break;
        case EBankTypePostbank:
            return NSLocalizedStringFromTable(@"bank.postbank", @"Localization", nil);
            break;
            
        default:
            break;
    }
    return @"";
}

- (NSString *)getStateNameFromState:(EBankState)bankState {
    switch (bankState) {
        case EbankStateUknown:
            return NSLocalizedStringFromTable(@"bankstate.money", @"Localization", nil);
            break;
            
        case EbankStateMoneyAndTwenties:
            return NSLocalizedStringFromTable(@"bankstate.moneytwenties", @"Localization", nil);
            break;

        case EBankStateNoMoney:
            return NSLocalizedStringFromTable(@"bankstate.nomoney", @"Localization", nil);
            break;

        default:
            return NSLocalizedStringFromTable(@"bankstate.money", @"Localization", nil);
            break;
    }
    return @"";
}

@end
