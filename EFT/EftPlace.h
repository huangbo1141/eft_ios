//
//  EftPlace.h
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EftGooglePlace.h"
@interface EftPlace : NSObject

@property (nonatomic,assign) int ep_id;
@property (nonatomic,strong) NSString* ec_rids;
@property (nonatomic,strong) NSString* ep_name;
@property (nonatomic,assign) double ep_lon;
@property (nonatomic,assign) double ep_lat;
@property (nonatomic,strong) NSString* ep_desc;
@property (nonatomic,assign) double ep_rating;
@property (nonatomic,assign) BOOL ep_hasreview;

@property (nonatomic,strong) NSString* place_id;
@property (nonatomic,strong) NSString* search_id;
@property (nonatomic,strong) NSString* simplejson;
@property (nonatomic,strong) NSString* detailjson;
@property (nonatomic,strong) NSString* types;
@property (nonatomic,strong) NSString* reference;

@property (nonatomic,strong) NSString* ep_googlephotoref;
@property (nonatomic,strong) NSString* ep_photopath;

@property (nonatomic,strong) NSMutableArray* ep_reviews;
@property (nonatomic,strong) NSMutableArray* ep_reviewpictures;

@property (nonatomic,strong) NSString* temp_ratingright;
@property (nonatomic,strong) NSString* temp_category;

@property (nonatomic,strong) NSString* distance;


@property (nonatomic,assign) int reviewcount;

@property (nonatomic,strong) EftGooglePlace* googlePlace;
-(instancetype)initWithDictionary:(NSDictionary*) dict;

@property (nonatomic,strong) NSString*tmpReview;
@property (nonatomic,strong) UIImage* tmpImage;

-(CGFloat)getHeightForSubMenuForName;
-(CGFloat)getHeightForSubMenuForAddress;

-(CGFloat)getHeightForReview;
-(CGFloat)getHeightForReviewEdit;
@end
