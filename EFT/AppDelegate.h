//
//  AppDelegate.h
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "EftRegion.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) DBManager *dbManager;

-(void)performLogin;
-(void)saveCurrentRegion;
-(BOOL)hasThisRegion:(EftRegion*)region;

@property (nonatomic,strong) CLLocationManager *cl_locationManager;
@property (nonatomic,strong) CLLocation *cl_location;


@end

