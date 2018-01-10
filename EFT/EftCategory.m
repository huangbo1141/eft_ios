//
//  EftCategory.m
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "EftCategory.h"

@implementation EftCategory

-(instancetype)initWithDictionaryForSingle:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        if ([dict objectForKey:@"ec_id"] != nil) {
            self.ec_id = [(NSNumber*)[dict objectForKey:@"ec_id"] intValue];
        }
        if ([dict objectForKey:@"ec_name"] != nil) {
            self.ec_name = (NSString*)[dict objectForKey:@"ec_name"];
        }
        if ([dict objectForKey:@"ec_key"] != nil) {
            self.ec_key = (NSString*)[dict objectForKey:@"ec_key"];
        }
        
        if ([dict objectForKey:@"ec_registered"] != nil) {
            self.ec_registered = [(NSNumber*)[dict objectForKey:@"ec_key"] intValue];
        }
        
        if ([dict objectForKey:@"ec_parent"] != nil) {
            self.ec_parent = [(NSNumber*)[dict objectForKey:@"ec_parent"] intValue];
        }
        
        if ([dict objectForKey:@"ec_googlekey"] != nil) {
            self.ec_googlekey = (NSString*)[dict objectForKey:@"ec_googlekey"];
        }
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    self = [self initWithDictionaryForSingle:dict];
    if(self){
        _ec_subcategory = [[NSMutableArray alloc] init];
        if ([dict objectForKey:@"subcategory"] != nil) {
            NSArray*array = [dict objectForKey:@"subcategory"];
            for (int i=0; i< [array count]; i++) {
                NSDictionary*subdict = [array objectAtIndex:i];
                EftCategory*item = [[EftCategory alloc] initWithDictionaryForSingle:subdict];
                [_ec_subcategory addObject: item];
            }
        }
    }
    return self;
}

@end
