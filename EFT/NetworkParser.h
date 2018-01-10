//
//  NetworkParser.h
//  SchoolApp
//
//  Created by TwinkleStar on 11/27/15.
//  Copyright © 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CGlobal.h"

typedef void (^NetworkCompletionBlock)(NSDictionary*dict, NSError* error);


@interface NetworkParser : NSObject
+ (instancetype)sharedManager;

- (void)onRegisterByPhone:(NSString*) uuid withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)onQueryReview:(EftPlace*)place withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onLoginByPhone:(EftUser*)user withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onGoogleSearch:(EftQuery*)query Mode:(int)mode withCompletionBlock:(NetworkCompletionBlock)completionBlock;


- (void)onAddReview:(EftReview*)object Reference:(NSString*)reference
           Category:(EftCategory*)category withCompletionBlock:(NetworkCompletionBlock)completionBlock;

-(void) onAddCategory:(EftCategory*)category withCompletionBlock:(NetworkCompletionBlock)completionBlock;

-(void)onGoogleSearchOne:(EftCategory*) category Latitude:(NSString*)lat Longitude:(NSString*)lon Radius:(NSString*)radius Query:(NSString*)query withCompletionBlock:(NetworkCompletionBlock)completionBlock;

-(void)onGetMyLocationAddress:(NSString*)latlng withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)uploadImage:(UIImage*)image ImagePath:(NSString*)path FileName:(NSString*)fileName withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onDeleteReview:(EftReview*)object withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onAddReviewFast:(EftQuery *)query EftReview:(EftReview*)object Mode:(int)mode withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)onGooglePlaceDetail:(EftGooglePlace*)place withCompletionBlock:(NetworkCompletionBlock)completionBlock;
@end
