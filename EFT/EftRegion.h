//
//  EftRegion.h
//  EFT
//
//  Created by Twinklestar on 12/11/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EftGooglePlace.h"
@interface EftRegion : NSObject
//  1   some space place
//  2   point  place
@property (nonatomic,assign) int erg_id;

@property (nonatomic,assign) int erg_type;
@property (nonatomic,strong) NSString* erg_lat;
@property (nonatomic,strong) NSString* erg_lon;
@property (nonatomic,strong) NSString* erg_address;

@property (nonatomic,strong) NSString* erg_city;
@property (nonatomic,strong) NSString* erg_state;
@property (nonatomic,strong) NSString* erg_country;
@property (nonatomic,strong) NSString* erg_zipcode;

@property (nonatomic,strong) EftGooglePlace* eft_googleplace;
@property (nonatomic,strong) NSString* erg_placeid;
@property (nonatomic,assign) BOOL isSavedToDb;

-(instancetype)initFromDb:(NSArray*)row;
-(instancetype)initData;
-(NSString*)getAddress;
-(NSString*)getAddressForQuery;
-(void)setGooglePlace:(EftGooglePlace*)place;


@end
