//
//  ATMDetailBankViewController.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/5/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bank.h"

@interface ATMDetailBankViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong)Bank *currentBank;

@end
