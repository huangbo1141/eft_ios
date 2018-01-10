//
//  EftQuery.h
//  EFT
//
//  Created by Twinklestar on 12/10/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EftQuery : NSObject

@property (nonatomic,assign) int catid;
@property (nonatomic,strong) NSString* lat;
@property (nonatomic,strong) NSString* lon;
@property (nonatomic,assign) int radius;

@property (nonatomic,strong) NSString* query;

-(void)initData;

@end
