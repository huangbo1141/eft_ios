//
//  EftRegion.m
//  EFT
//
//  Created by Twinklestar on 12/11/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "EftRegion.h"

@implementation EftRegion
-(instancetype)initData{
    self = [super init];
    if (self) {
        self.erg_address = @"";
        self.erg_city = @"";
        self.erg_country = @"";
        self.erg_lat=@"";
        self.erg_lon=@"";
        self.erg_placeid=@"";
        self.erg_state=@"";
        self.erg_type = -1;
        self.erg_zipcode = @"";
        
    }
    return self;
}
-(NSString*)getAddress{
    NSString *address;
    if (_erg_type == 1) {
        address = _erg_city;
        
    }else{
        address = _erg_address;
    }
    return address;
}
-(NSString*)getAddressForQuery{
    NSString *address;
    if (_erg_type == 1) {
        address = _erg_city;
        
        address = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        address = [address stringByReplacingOccurrencesOfString:@"," withString:@"+"];
        address = [address stringByReplacingOccurrencesOfString:@"++" withString:@"+"];
    }else if(_erg_type ==2 ){
        address = [_eft_googleplace getAddressForTextQuery];
    }
    return address;
}
// data table
// erg_id   erg_city    erg_state   erg_country     erg_zipcode
//          erg_type    erg_lat     erg_lon         erg_address
//create table region (erg_id integer primary key not null,erg_city text , erg_state text, erg_country text, erg_zipcode text, erg_type integer, erg_lat text, erg_lon text, erg_address text, erg_placeid text);
-(instancetype)initFromDb:(NSArray*)row{
    self  = [super init];
    if (self) {
        _erg_id     =   [(NSNumber*)[row objectAtIndex:0] intValue];
        _erg_city   =   (NSString*)[row objectAtIndex:1];
        _erg_state   =   (NSString*)[row objectAtIndex:2];
        _erg_country   =   (NSString*)[row objectAtIndex:3];
        _erg_zipcode   =   (NSString*)[row objectAtIndex:4];
        
        _erg_type   =   [(NSNumber*)[row objectAtIndex:5] intValue];
        _erg_lat   =   (NSString*)[row objectAtIndex:6];
        _erg_lon   =   (NSString*)[row objectAtIndex:7];
        _erg_address   =   (NSString*)[row objectAtIndex:8];
        _erg_placeid   =   (NSString*)[row objectAtIndex:9];
    }
    return self;
}
-(void)setGooglePlace:(EftGooglePlace*)place{
    if (place != nil) {
        _eft_googleplace = place;
        _erg_type = 2;
        
        _erg_lat = place.lat;
        _erg_lon = place.lon;
        _erg_address = _eft_googleplace.formatted_address;
    }
}
@end
