//
//  MoneyView.m
//  AtmMoney
//
//  Created by squeezah on 7/5/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "MoneyView.h"
#import "Bank.h"

@interface MoneyView ()

@property (nonatomic,strong) UIImageView    *moneyIcon;
@property (nonatomic,strong) UILabel        *moneyLabel;

@end

@implementation MoneyView

-(instancetype)initWithFrame:(CGRect)frame State:(EBankState)state {

    self = [super initWithFrame:frame];
    if(self) {
    
        self.moneyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getImageNameFromBankState:state]]];
        [self.moneyIcon sizeToFit];
        [self addSubview:self.moneyIcon];
        
        self.moneyLabel = [[UILabel alloc] init];
        self.moneyLabel.font = [UIFont systemFontOfSize:11];
        self.moneyLabel.textColor = [UIColor blackColor];
        self.moneyLabel.backgroundColor = [UIColor clearColor];
        self.moneyLabel.text = @"";
        self.moneyLabel.textColor = [self getTextColorFromBankState:state];
        [self addSubview:self.moneyLabel];

    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    CGFloat padding = 5;
    
    
    [self.moneyIcon sizeToFit];
    self.moneyIcon.frame = CGRectMake(0,
                                      floorf(CGRectGetHeight(self.frame) - CGRectGetHeight(self.moneyIcon.frame) - padding),
                                      CGRectGetWidth(self.moneyIcon.frame),
                                      CGRectGetHeight(self.moneyIcon.frame));
    
    
    [self.moneyLabel sizeToFit];
    self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(self.moneyIcon.frame) + padding,
                                       CGRectGetMinY(self.moneyIcon.frame),
                                       CGRectGetWidth(self.moneyLabel.frame),
                                       CGRectGetHeight(self.moneyLabel.frame));

    
}
- (NSString *)getImageNameFromBankState:(EBankState)bankState
{
    switch (bankState) {
        case EbankStateUknown:
            return @"money-icon-full";
            break;
            
        case EbankStateMoneyAndTwenties:
            return @"money-icon-full";
            break;
            
        case EBankStateNoMoney:
            return @"money-icon-empty";
            break;
            
            
        default:
            break;
    }
    return @"money-icon-full";
}


- (UIColor *)getTextColorFromBankState:(EBankState)bankState
{
    switch (bankState) {
        case EbankStateUknown:
            return [UIColor colorWithRed:0.13 green:0.69 blue:0.04 alpha:1.0];
            break;
            
        case EbankStateMoneyAndTwenties:
            return [UIColor colorWithRed:0.13 green:0.69 blue:0.04 alpha:1.0];
            break;
            
        case EBankStateNoMoney:
            return [UIColor colorWithRed:0.89 green:0.13 blue:0.07 alpha:1.0];
            break;
            
            
        default:
            break;
    }
    return [UIColor colorWithRed:0.13 green:0.69 blue:0.04 alpha:1.0];
}

- (void)updateWithState:(EBankState)state {
    Bank *bank = [[Bank alloc]init];
    self.moneyLabel.text = [bank getStateNameFromState:state];
    self.moneyLabel.textColor = [self getTextColorFromBankState:state];
    self.moneyIcon.image = [UIImage imageNamed:[self getImageNameFromBankState:state]];

}

- (CGSize)sizeThatFits:(CGSize)size {
    Bank *bank = [[Bank alloc]init];

    UIImage *img = [UIImage imageNamed:[self getImageNameFromBankState:1]];
    NSString *text = [bank getStateNameFromState:1];
    CGSize textSize = [text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:11] }];

    CGSize size1 = CGSizeMake(img.size.width + textSize.width, img.size.height);
    
    return size1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
