//
//  MapViewController.h
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Harris Spentzas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property(nonatomic,strong)NSMutableArray *coords;

- (void)showAnnotations;
@end
