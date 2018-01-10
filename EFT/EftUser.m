//
//  EftUser.m
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "EftUser.h"

@implementation EftUser

-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        if ([dict objectForKey:@"eu_id"] != nil) {
            self.eu_id = [(NSNumber*)[dict objectForKey:@"eu_id"] intValue];
        }
        if ([dict objectForKey:@"eu_username"] != nil) {
            self.eu_username = (NSString*)[dict objectForKey:@"eu_username"];
        }
        if ([dict objectForKey:@"eu_password"] != nil) {
            self.eu_password = (NSString*)[dict objectForKey:@"eu_password"];
        }
        if ([dict objectForKey:@"eu_email"] != nil) {
            self.eu_email = (NSString*)[dict objectForKey:@"eu_email"];
        }
    }
    return self;
}

@end
