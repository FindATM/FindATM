//
//  ATMFilterView.h
//  ATMMoney
//
//  Created by Abzorba Games on 07/07/2015.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATMFilterView : UIView

- (instancetype)initWithFrame:(CGRect)frame andSelectedBanks:(NSMutableArray *)selectedBanks;

@property (nonatomic, strong, readonly) NSMutableArray *selectedBanks;

@end
