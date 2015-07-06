//
//  MapViewController.h
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapDelegate <NSObject>

@optional
- (void)openBankDetailViewWithBank:(Bank *)bank;

@end

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property(nonatomic,strong)NSMutableArray *coords;
@property(nonatomic,weak)id <MapDelegate> delegate;

- (void)showAnnotations;
@end
