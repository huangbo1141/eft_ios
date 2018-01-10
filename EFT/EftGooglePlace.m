//
//  EftGooglePlace.m
//  EFT
//
//  Created by Twinklestar on 12/10/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "EftGooglePlace.h"
#import "CGlobal.h"
#import "BaseModel.h"
@implementation EftGooglePlace

-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        [BaseModel parseResponse:self Dict:dict];
        
        
        if ([dict objectForKey:@"geometry"] != nil) {
            id geometry = [dict objectForKey:@"geometry"];
            if ([geometry objectForKey:@"location"] != nil) {
                id location = [geometry objectForKey:@"location"];
                
                double lat = [(NSNumber*)[location objectForKey:@"lat"] doubleValue];
                double lon = [(NSNumber*)[location objectForKey:@"lng"] doubleValue];
                
                self.lat = [NSString stringWithFormat:@"%f", lat];
                self.lon = [NSString stringWithFormat:@"%f", lon];
            }
            
            
        }
        
        
        if ([dict objectForKey:@"address_components"] != nil) {
            NSArray*array = [dict objectForKey:@"address_components"];
            
            NSMutableArray*tmp = [[NSMutableArray alloc] init];
            for (int i=0; i< [array count]; i++) {
                id item = [array objectAtIndex:i];
                EftGoogleAddressComponent*component = [[EftGoogleAddressComponent alloc] initWithDictionary:item];
                
                [tmp addObject:item];
            }
            
            self.address_components = tmp;
        }
    }
    return self;
}

-(NSString*)getAddressForTextQuery{
    NSString*ret = nil;
    NSString*found1 = @"country";
    NSString*found2 = @"administrative_area_level_1";
    NSString*found3 = @"administrative_area_level_2";
    
    NSString* foundResult1 = @"";
    NSString* foundResult2 = @"";
    NSString* foundResult3 = @"";
    
    for (int i=0; i< [_address_components count]; i++) {
        EftGoogleAddressComponent*item = [_address_components objectAtIndex:i];
        for (NSString*type in item.types) {
            if ([type isEqualToString:found1]) {
                foundResult1 = item.long_name;
                break;
            }
            
            if ([type isEqualToString:found2]) {
                foundResult2 = item.long_name;
                break;
            }
            
            if ([type isEqualToString:found3]) {
                foundResult3 = item.long_name;
                break;
            }
        }
    }
    
    ret = [foundResult3 stringByAppendingString:foundResult2];
    ret = [ret stringByAppendingString:foundResult1];
    
    ret = [ret stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    if ([ret length]>0) {
        return ret;
    }
    return nil;
    
}
-(CGFloat)getHeightForReview{
    CGRect rect = [UIScreen mainScreen].bounds;
    UIFont* font = [UIFont systemFontOfSize:12.0];
    CGFloat h1 = [CGlobal heightForView:self.name Font:font Width:rect.size.width];
    CGFloat h2 = [CGlobal heightForView:self.vicinity Font:font Width:rect.size.width];
    CGFloat h3 = [CGlobal heightForView:@"xxxxxx" Font:font Width:rect.size.width];
    CGFloat gap = 8;
    return h1+h2+h3+gap*4;
}
-(CGFloat)getHeightForReviewEdit{
    CGFloat h1 = [self getHeightForReview];
    return h1 + 180;
}
@end
