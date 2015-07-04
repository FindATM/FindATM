//
//  DataHandler.h
//  iLocate
//
//  Created by Theocharis Spentzas on 2/20/15.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define CURRENT_LOCATION_KEY @"currentLocation"

#define Data [DataHandler sharedInstance]

@class Reachability;

@interface DataHandler : NSObject <CLLocationManagerDelegate>

+ (DataHandler *)sharedInstance;

@property (strong, nonatomic) CLLocation *currentLocation;

- (void)getAddressFromLocation:(CLLocation *)location WithCompletion:(MessageResponse)completion;

-(double)getLatitude;
-(double)getLongitude;
-(double)getAccuracy;

- (void)setupLocationManager;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
