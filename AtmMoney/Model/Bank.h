//
//  Bank.h
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


typedef enum : NSUInteger {
    EbankStateUknown = 0,
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
    EBankTypeNationalBank
} EBankType;

@interface Bank : NSObject

@property(nonatomic,assign,readonly) NSInteger buid;
@property(nonatomic,assign,readonly) CGFloat longtitude;
@property(nonatomic,assign,readonly) CGFloat latitude;
@property(nonatomic,strong,readonly) NSString *address;
@property(nonatomic,strong,readonly) NSString *name;
@property(nonatomic,strong,readonly) NSString *phone;
@property(nonatomic,assign,readonly) CGFloat distance;
@property(nonatomic,assign,readonly) EBankType bankType;
@property(nonatomic,assign,readonly) EBankState bankState;
@property(nonatomic,assign,readonly) NSInteger visitors;
@property(nonatomic,assign,readonly) CLLocationCoordinate2D location;
@property(nonatomic,assign,readonly) CGFloat actualDistance;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSString *)getBankNameFromType:(EBankType)bankType;

+ (NSString *)getStateNameFromState:(EBankState)bankState;

+ (UIColor *)getTextColorFromBankState:(EBankState)bankState;

+ (NSString *)getImageNameFromBankState:(EBankState)bankState;

+ (NSString *)getReadableStateFromBankState:(EBankState)bankState;

+ (UIImage *)getBankLogoFromBankType:(EBankType)bankType;

@end
