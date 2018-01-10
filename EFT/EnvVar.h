//
//  EnvVar.h
//  ClearShield
//
//  Created by Zhang on 2/14/15.
//  Copyright (c) 2015 jinung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvVar : NSObject
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, assign) long lastLogin;



- (BOOL)hasLoginDetails;
- (void)logOut;
- (BOOL)detailsStored;

- (id) initTemp;




- (void)setLang:(long)lang;
- (void)setSignType:(long)type;
- (void)setSign:(NSString*)sign;
- (void)setLanguage:(long)lang;

@end
