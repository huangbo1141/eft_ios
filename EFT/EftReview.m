//
//  EftReview.m
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "EftReview.h"
#import "CGlobal.h"
@implementation EftReview

-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        if ([dict objectForKey:@"er_id"] != nil) {
            self.er_id = [(NSNumber*)[dict objectForKey:@"er_id"] intValue];
        }
        if ([dict objectForKey:@"er_text"] != nil) {
            self.er_text = (NSString*)[dict objectForKey:@"er_text"];
        }
        if ([dict objectForKey:@"eu_rid"] != nil) {
            self.eu_rid = [(NSNumber*)[dict objectForKey:@"eu_rid"] intValue];
        }
        if ([dict objectForKey:@"er_rating"] != nil) {
            self.er_rating = [(NSNumber*)[dict objectForKey:@"er_rating"] doubleValue];
        }
        if ([dict objectForKey:@"ep_rid"] != nil) {
            self.ep_rid = [(NSNumber*)[dict objectForKey:@"ep_rid"] intValue];
        }
        if ([dict objectForKey:@"er_picture"] != nil) {
            self.er_picture = (NSString*)[dict objectForKey:@"er_picture"];
        }
        
    }
    return self;
}
-(void)initData{
    _er_id = -1;
    _er_text = @"";
    _er_rating = 0;
    _er_picture = @"";
    
}
-(float)getHeightForSubMenuForReviewText{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGFloat tablewidth = 240 - 76;
    CGFloat height = [CGlobal heightForView:_er_text Font:font Width:tablewidth];
    
    return height;
}

@end
