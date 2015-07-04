//
//  ATMDetailBankViewController.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/5/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "ATMDetailBankViewController.h"

@interface ATMDetailBankViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankAddressLabel;

@property (weak, nonatomic) IBOutlet UIView *hasMoneyContainerView;
@property (weak, nonatomic) IBOutlet UILabel *hasMoneyLabel;
@property (weak, nonatomic) IBOutlet UISwitch *hasMoneySwitch;

@property (weak, nonatomic) IBOutlet UIView *hasTwentiesView;
@property (weak, nonatomic) IBOutlet UILabel *hasTwentiesLabel;
@property (weak, nonatomic) IBOutlet UISwitch *hasTwentiesSwitch;

@property (weak, nonatomic) IBOutlet UILabel *latestActivityLabel;
@property (weak, nonatomic) IBOutlet UITableView *latestActivityTableView;

@end

static NSString *activityCellItemIdentifier = @"activityCellItemIdentifier";

@implementation ATMDetailBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"atmdetailviewcontroller.title", @"Localization", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.hasMoneyLabel.text = NSLocalizedStringFromTable(@"detail.view.hasmoney", @"Localization", @"");
    self.hasTwentiesLabel.text = NSLocalizedStringFromTable(@"detail.view.hastwenties", @"Localization", @"");
    
    self.latestActivityTableView.delegate = self;
    self.latestActivityTableView.dataSource = self;

    [self.latestActivityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:activityCellItemIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning to be changed to show the latest activity.
    return Eng.getNearestBanks.banksData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCellItemIdentifier forIndexPath:indexPath];
    
    return cell;
}

// from: http://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
