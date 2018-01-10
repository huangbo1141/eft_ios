//
//  EftGooglePlace.h
//  EFT
//
//  Created by Twinklestar on 12/10/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface EftGooglePlace : NSObject

@property (nonatomic,strong) NSString*reference;
@property (nonatomic,strong) NSString*place_id;
@property (nonatomic,strong) NSString*formatted_address;
@property (nonatomic,strong) NSString*formatted_phone_number;
@property (nonatomic,strong) NSString*lat;
@property (nonatomic,strong) NSString*lon;
@property (nonatomic,strong) NSString*icon;
@property (nonatomic,strong) NSString*name;
@property (nonatomic,strong) NSString*types;
@property (nonatomic,strong) NSString*xid;
@property (nonatomic,strong) NSArray*address_components;

@property (nonatomic,strong) NSString* googlePicture;
@property (nonatomic,strong) NSString* distance;
@property (nonatomic,strong) NSString* vicinity;


-(instancetype)initWithDictionary:(NSDictionary*) dict;

-(NSString*)getAddressForTextQuery;

@property (nonatomic,strong) NSString*tmpReview;
@property (nonatomic,strong) UIImage* tmpImage;

-(CGFloat)getHeightForReview;
-(CGFloat)getHeightForReviewEdit;
@end
