//
//  EftUser.h
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EftUser : NSObject

@property (nonatomic,assign) int eu_id;
@property (nonatomic,strong) NSString* eu_username;
@property (nonatomic,strong) NSString* eu_password;
@property (nonatomic,strong) NSString* eu_email;

-(instancetype)initWithDictionary:(NSDictionary*) dict;
@end
