//
//  EftPlace.m
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "EftPlace.h"
#import "CGlobal.h"
#import "NSString+Common.h"
#import "BaseModel.h"
@implementation EftPlace

-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        [BaseModel parseResponse:self Dict:dict];
        
        
        if ([dict objectForKey:@"detailjson"] != nil) {
            self.detailjson = (NSString*)[dict objectForKey:@"detailjson"];
            NSData*data = [self.detailjson dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            NSDictionary*json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            _googlePlace = [[EftGooglePlace alloc] initWithDictionary:json];
        }
        
        if ([dict objectForKey:@"reviewcount"] != nil) {
            self.reviewcount = [(NSNumber*)[dict objectForKey:@"reviewcount"] intValue];
            
        }else{
            self.reviewcount = 0;
        }
        
        if ([dict objectForKey:@"ep_reviews"] != nil) {
            NSArray*array = [dict objectForKey:@"ep_reviews"];
            NSMutableArray *pp = [[NSMutableArray alloc] init];
            NSMutableArray *listpath = [[NSMutableArray alloc] init];
            for (id subdict in array) {
                EftReview*review = [[EftReview alloc] initWithDictionary:subdict];
                [pp addObject:review];
                
                if (review.er_picture!=nil && ![review.er_picture isBlank]) {
                    [listpath addObject:review.er_picture];
                }
            }
            
            self.ep_reviews = pp;
            self.ep_reviewpictures = listpath;
        }
        
        
    }
    return self;
}

-(CGFloat)getHeightForSubMenuForName{
    UIFont *bigFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGFloat labelwidth = 240 - 20;
    CGFloat height1 = [CGlobal heightForView:_ep_name Font:bigFont Width:labelwidth];
   
    return height1;
}
-(CGFloat)getHeightForSubMenuForAddress{
    
    UIFont *smallFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGFloat labelwidth = 240 - 20;
    
    CGFloat height2 = [CGlobal heightForView:_googlePlace.formatted_address Font:smallFont Width:labelwidth];
    return 40;
}
-(CGFloat)getHeightForReview{
    CGRect rect = [UIScreen mainScreen].bounds;
    UIFont* font = [UIFont systemFontOfSize:12.0];
    CGFloat h1 = [CGlobal heightForView:self.ep_name Font:font Width:rect.size.width];
    CGFloat h2 = [CGlobal heightForView:self.ep_desc Font:font Width:rect.size.width];
    CGFloat h3 = [CGlobal heightForView:@"xxxxxx" Font:font Width:rect.size.width];
    CGFloat gap = 8;
    return h1+h2+h3+gap*4;
}
-(CGFloat)getHeightForReviewEdit{
    CGFloat h1 = [self getHeightForReview];
    return h1 + 180;
}
@end
