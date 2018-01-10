//
//  EftReview.h
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface EftReview : NSObject

@property (nonatomic,assign) int er_id;
@property (nonatomic,strong) NSString* er_text;
@property (nonatomic,assign) int eu_rid;
@property (nonatomic,assign) int ep_rid;
@property (nonatomic,assign) double er_rating;
@property (nonatomic,strong) NSString* er_picture;
@property (nonatomic,assign) int er_hasrating;


-(instancetype)initWithDictionary:(NSDictionary*) dict;
-(void)initData;

-(float)getHeightForSubMenuForReviewText;
@end
