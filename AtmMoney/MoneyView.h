//
//  MoneyView.h
//  AtmMoney
//
//  Created by squeezah on 7/5/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyView : UIView

-(instancetype)initWithFrame:(CGRect)frame State:(EBankState)state;

- (void)updateWithState:(EBankState)state;

@end
