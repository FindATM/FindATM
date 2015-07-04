//
// Prefix header for all source files of the 'Roulette' target in the 'Roulette' project
//

#import <Availability.h>

#ifndef __IPHONE_3_0
#warning "This project uses features only available in iOS SDK 3.0 and later."
#endif

#ifdef __OBJC__

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <AdSupport/ASIdentifierManager.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "Flurry.h"
#import "DDLog.h"
#import "UIView+Position.h"
#import "FlurryEvents.h"
#import "GameConstants.h"

#warning NOTE: Change this in case of changes on the common code
#define COMMON_VERSION              @"3.5"

#define GAME_SUB_ID_ABZORBA         @"0"
#define GAME_SUB_ID_TANGO           @"5"

typedef void (^JSONResponseBlock)(NSDictionary* json);
typedef void (^MutableArrayResponseBlock) (NSMutableArray *mutableArray);
typedef void (^VoidBlock)(void);
typedef void (^ImageBlock)(UIImage *image);
typedef void (^ArrayBlock)(NSArray *results);
typedef void (^MessageResponse )(NSString* message);
typedef NSString *(^FormatterBlock)(NSNumber *number);
typedef void (^BoolBlock)(BOOL result);

#endif

#ifdef DEBUG
#define Log NSLog
#else
// do nothing
#define Log(...)
#endif

#define ARVO_BOLD                           @"Arvo-Bold"
#define ARVO_REGULAR                        @"Arvo"

#define ALEO_REGULAR                        @"Aleo-Regular"
#define ALEO_BOLD                           @"Aleo-Bold"


// Log levels: off, error, warn, info, verbose
#define LUMBERJACK_LOG_LEVEL        LOG_LEVEL_OFF

#define ORIENTATION_DEPENDENT ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) //iOS 8 + is now orientation dependent

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPHONE4 ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ( (ORIENTATION_DEPENDENT == YES) ? ([[UIScreen mainScreen ] bounds].size.width == 480.0) : ([[UIScreen mainScreen ] bounds].size.height == 480) ))

#define IS_IPHONE5 ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ( (ORIENTATION_DEPENDENT == YES) ? ([[UIScreen mainScreen ] bounds].size.width == 568.0f) : ([[UIScreen mainScreen ] bounds].size.height == 568.0f) ))

#define IS_IPHONE_6 ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.width == 667.0) && ([[UIScreen mainScreen] scale] == 2.0f))

#define IS_IPHONE_6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] scale] == 3.0f))

#define DeviceSpecificSetting1(iPhone, iPhoneFive,iPhoneSix,iPhoneSixPlus,iPad) ((!IS_IPAD)?( (!IS_IPHONE_6PLUS) ? (!IS_IPHONE_6) ? ( (!IS_IPHONE5) ? iPhone :iPhoneFive) : (iPhoneSix) : (iPhoneSixPlus)): iPad)

#define DeviceSpecificSetting(iPhone, iPhoneFive) (!(IS_IPHONE5) ? (iPhone) : (iPhoneFive))
#define DeviceiPadiPhoneSpecificSetting(iPhone, iPad) (!(IS_IPAD) ? (iPhone) : (iPad))
#define DeviceAllSpecificSetting(iPhone, iPhoneFive, iPad) (!(IS_IPAD) ? (!(IS_IPHONE5) ? (iPhone) : (iPhoneFive)) : (iPad))

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
