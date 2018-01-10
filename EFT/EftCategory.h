//
//  EftCategory.h
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EftCategory : NSObject

@property (nonatomic,assign) int ec_id;
@property (nonatomic,strong) NSString* ec_name;
@property (nonatomic,strong) NSString* ec_key;

@property (nonatomic,assign) int ec_registered;
@property (nonatomic,assign) int ec_parent;
@property (nonatomic,strong) NSString* ec_googlekey;

@property (nonatomic,weak) NSMutableArray* ec_subcategory_temp;

@property (nonatomic,strong) NSMutableArray* ec_subcategory;
@property (nonatomic,assign) BOOL isopened;

-(instancetype)initWithDictionary:(NSDictionary*) dict;
-(instancetype)initWithDictionaryForSingle:(NSDictionary*) dict;
@end
