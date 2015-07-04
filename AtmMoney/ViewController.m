//
//  ViewController.m
//  AtmMoney
//
//  Created by Harris Spentzas on 7/3/15.
//  Copyright (c) 2015 Harris Spentzas. All rights reserved.
//

#import "ViewController.h"
#import "DataHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "Bank.h"

@interface ViewController () {

    UITableView *_tableView;
    NSMutableArray *banksData;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view, typically from a nib.
    
    //adding observer to being notify when location property is changed
    [Data addObserver:self forKeyPath:CURRENT_LOCATION_KEY options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  [banksData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *simpleTableIdentifier = @"BankItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Bank *bank = [banksData objectAtIndex:indexPath.row];
    cell.textLabel.text = bank.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Bank *bank = [banksData objectAtIndex:indexPath.row];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"buid": @(bank.buid),@"state":@(bank.bankState)};
    [manager POST:@"http://dimmdesign.com/clients/atmmoney/api/submitBank" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"Submit ok!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

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
    }

}
- (void)getBanks {

//http://dimmdesign.com/clients/atmmoney/api/submitBank?buid=16&state=2
//http://dimmdesign.com/clients/atmmoney/api/getNearestBanks?lat=21.4&lng=38.6
    
    
    banksData = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"lng": @([Data getLongitude]),@"lat":@([Data getLatitude])};
    [manager POST:@"http://dimmdesign.com/clients/atmmoney/api/getNearestBanks" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [[responseObject objectForKey:@"banks"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            Bank *bank = [[Bank alloc]initWithDict:dict];
            [banksData addObject:bank];
        }];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
