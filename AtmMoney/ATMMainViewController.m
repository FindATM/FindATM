//
//  ViewController.m
//  AtmMoney
//
//  Created by Harris Spentzas on 7/3/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "ATMMainViewController.h"
#import "DataHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "Bank.h"
#import "ATMBankTableViewCell.h"
#import "ATMDetailBankViewController.h"
#import "MapViewController.h"

@interface ATMMainViewController   ()
@end

@implementation ATMMainViewController {

    UIBarButtonItem *btnMap;
}

static NSString *simpleTableIdentifier = @"bankItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTable(@"mainviewcontroller.title", @"Localization", nil);
    
    //adding observer to being notify when location property is changed
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[ATMBankTableViewCell class] forCellReuseIdentifier:simpleTableIdentifier];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    btnMap = [[UIBarButtonItem alloc]
                                initWithTitle:@"Map"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(openMap)];
    self.navigationItem.rightBarButtonItem = btnMap;
}

- (void)refreshTableView {
    
    [Data startUpdatingLocation];
    
}

- (void)openMap {
    if([Eng.getNearestBanks.banksData count] == 0) return;
    
    MapViewController *map = [[MapViewController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
    map.delegate = self;
    map.coords = Eng.getNearestBanks.banksData;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [SVProgressHUD show];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.refreshControl beginRefreshing];
    
    [Data startUpdatingLocation];
    
    [Data addObserver:self forKeyPath:CURRENT_LOCATION_KEY options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [Data removeObserver:self forKeyPath:CURRENT_LOCATION_KEY];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [Eng.getNearestBanks.banksData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ATMBankTableViewCell *cell = (ATMBankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if (Eng.getNearestBanks.banksData.count) {
        Bank *bank = [Eng.getNearestBanks.banksData objectAtIndex:indexPath.row];
        [cell updateWithBank:bank];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Bank *bank = [Eng.getNearestBanks.banksData objectAtIndex:indexPath.row];

    // Hides the
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    ATMDetailBankViewController  *atmDetailViewController = [[ATMDetailBankViewController alloc] initWithBank:bank];
    
    [SVProgressHUD show];
    [Eng.getNearestBanks getBankHistoryWithId:bank.buid
                               withCompletion:^{
                                   [SVProgressHUD dismiss];
                                   [self.navigationController pushViewController:atmDetailViewController animated:YES];
                                   
                               }
                                   andFailure:^{
                                       [SVProgressHUD showErrorWithStatus:@"Network Failure"];
                                   
                                   }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:CURRENT_LOCATION_KEY]) {
        // do some stuff
        [self getBanks];
        [Data stopUpdatingLocation];
    }
}

- (void)getBanks {
    
    CLLocation *location = Data.currentLocation;
    [[Engine sharedInstance].getNearestBanks getNearestBanksWithLocation:location andDistance:0.8 withCompletion:^{
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
    } andFailure:^{
        [self.refreshControl endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"Network Failure"];
    }];
    
}


#pragma mark mapdelegate method

- (void)openBankDetailViewWithBank:(Bank *)bank {

    ATMDetailBankViewController  *atmDetailViewController = [[ATMDetailBankViewController alloc] initWithBank:bank];
    
    [SVProgressHUD show];
    [Eng.getNearestBanks getBankHistoryWithId:bank.buid
                               withCompletion:^{
                                   [SVProgressHUD dismiss];
                                   [self.navigationController pushViewController:atmDetailViewController animated:YES];
                                   
                               }
                                   andFailure:^{
                                       [SVProgressHUD showErrorWithStatus:@"Network Failure"];
                                       
                                   }];

}
@end
