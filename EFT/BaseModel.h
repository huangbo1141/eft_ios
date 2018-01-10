//
//  BaseModel.h
//  Hospice
//
//  Created by Twinklestar on 1/26/16.
//  Copyright © 2016 Hospice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (assign, nonatomic) BOOL result;
@property (copy, nonatomic) NSString* res;
@property (copy, nonatomic) NSString* custId;
@property (copy, nonatomic) NSString* challengeId;
@property (copy, nonatomic) NSString* status;
@property (copy, nonatomic) NSString* lastwinnerdate;


-(instancetype)initWithDictionary:(NSDictionary*) dict;
+(NSMutableDictionary*)getQuestionDict:(id)targetClass;
+(void)parseResponse:(id)targetClass Dict:(NSDictionary*)dict;
+(void)parseResponseABC:(id)targetClass Dict:(NSDictionary*)dict ABC:(NSDictionary*)abcDict;
+(NSData*)buildJsonData:(id)targetClass;

+(NSString*)getUpdateSql:(id)targetClass TableName:(NSString*)tableName WhereField:(NSString*)wField WhereValue:(NSString*)wValue;
+(NSString*)getInsertSql:(id)targetClass TableName:(NSString*)tableName Exceptions:(NSMutableArray*)exceptions;

@property (copy, nonatomic) NSString* action;   //updateChallengeStatus
@end

////http://sas.myriadsolutionz.com/vbn87fjk/webservices.php?
//custId=&
//date=&
//steps=&
//sleep=&
//activeCalories=&
//weight=&
//calorieGoal=&
//exercise=&
//standing=&
//walking=&
//cycling=&
//flights=&
//action=saveMySummary&
//Submit=submit
