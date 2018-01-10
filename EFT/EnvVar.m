//
//  EnvVar.m
//  ClearShield
//
//  Created by Zhang on 2/14/15.
//  Copyright (c) 2015 jinung. All rights reserved.
//

#import "EnvVar.h"
#import "macros.h"
#import "CGlobal.h"
//Login keys
static NSString * kDefaultsServiceUrlKey = @"SERVICEURL";
static NSString * kDefaultsUserNameKey = @"USERNAME";
static NSString * kDefaultsPasswordKey = @"PASSWORD";

//Store details keys
static NSString * kDefaultsStoreIDKey = @"STOREDETAILS_STOREID";
static NSString * kDefaultsStoreNumberKey = @"STOREDETAILS_STORENUMBER";
static NSString * kDefaultsStoreNameKey = @"STOREDETAILS_STORENAME";

//updated keys
static NSString * kDefaultsLastLoggedInKey = @"LASTLOGGEDIN";
static NSString * kDefaultsNagsUpdatedKey = @"NAGS_UPDATED";
static NSString * kDefaultsStatesUpdatedKey = @"STATES_UPDATED";
static NSString * kDefaultsInsuranceCompanyUpdated = @"INSURANCE_UPDATED";

//My own keys

static NSString * kDefaultsUserLanguageKey = @"USERLANGUAGE";
static NSString * kDefaultsSignKey = @"SIGNKEY";
static NSString * kDefaultsSignTypeKey = @"SIGNTYPE";


@interface EnvVar()
{
    BOOL bSaveDefaults;
}
@end

@implementation EnvVar

- (long) udLong:(NSString *)key default:(long)v
{
    if (UDValue(key))
    {
        return UDInteger(key);
    }
    else
    {
        //set default value and return default value;
        UDSetInteger(key, v);
        UDSync();
        return v;
    }
}
- (void) loadFromDefaults
{
    
    _username = UDValue(kDefaultsUserNameKey);
    _password = UDValue(kDefaultsPasswordKey);
    _lastLogin = UDInteger(kDefaultsLastLoggedInKey);
    
    
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        bSaveDefaults = YES;
        [self loadFromDefaults];
    }
    return self;
}

- (id) initTemp
{
    self = [super init];
    if (self != nil)
    {
        bSaveDefaults = NO;
    }
    return self;
}

#pragma mark - Login environment variables....
- (void)saveDefaults:(NSString *)key value:(id)obj
{
    if (bSaveDefaults)
    {
        if (obj != nil)
            UDSetValue(key, obj);
        else
            UDRemove(key);
        UDSync();
    }
    
}

- (void)saveDefaultsLong:(NSString *)key value:(long)v
{
    if (bSaveDefaults)
    {
        UDSetInteger(key, v);
        UDSync();
    }
}


- (void)setUsername:(NSString *)username
{
    _username = [username copy];
    [self saveDefaults:kDefaultsUserNameKey value:username];
}

- (void)setPassword:(NSString *)password
{
    _password = password;
    [self saveDefaults:kDefaultsPasswordKey value:password];
}

- (BOOL)hasLoginDetails
{
    return self.username != nil && self.password != nil;
}

- (void)logOut
{
    self.username = nil;
    self.password = nil;
    self.lastLogin = -1;
}

#pragma mark - Other Preference Values
- (void)setLastLogin:(long)lastLogin
{
    _lastLogin = lastLogin;
    [self saveDefaultsLong:kDefaultsLastLoggedInKey value:lastLogin];
}



@end
