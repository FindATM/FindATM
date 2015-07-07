//
//  ATMFilterView.h
//  ATMMoney
//
//  Created by Abzorba Games on 07/07/2015.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATMFilterViewDelegate <NSObject>

- (void)filterViewDidRequestToFilterData;
- (void)filterViewDidRequestToClose;

@end

@interface ATMFilterView : UIView

- (instancetype)initWithFrame:(CGRect)frame andSelectedBanks:(NSMutableArray *)selectedBanks;

@property (nonatomic, strong, readonly) NSMutableArray *selectedBanks;
@property (nonatomic, assign, readonly) CGFloat distance;

@property (nonatomic, weak) id<ATMFilterViewDelegate> delegate;

- (void)showAnimatedWithCompletion:(VoidBlock)completion;
- (void)hideAnimatedWithCompletion:(VoidBlock)completion;


@end
