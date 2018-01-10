//
//  BaseModel.m
//  Hospice
//
//  Created by Twinklestar on 1/26/16.
//  Copyright © 2016 Hospice. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
#import "CGlobal.h"

@implementation BaseModel

-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        [BaseModel parseResponse:self Dict:dict];        
        
    }
    return self;
}
+(NSString*)getUpdateSql:(id)targetClass TableName:(NSString*)tableName WhereField:(NSString*)wField WhereValue:(NSString*)wValue {
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([targetClass class], &numberOfProperties);
    
    NSString*sql = nil;
    
    NSString*part1 =@"";
    
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        //NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        if ([name isEqualToString:wField]) {
            continue;
        }
        NSString* value = [targetClass valueForKey:name];
        if (value!=nil && [value isKindOfClass:[NSString class]]) {
            
            NSString*item1 = [NSString stringWithFormat:@"`%@`='%@',",name,value];
            part1 = [part1 stringByAppendingString:item1];
        }
//        NSLog(@"Property %@ attributes: %@", name, name);
    }
    free(propertyArray);
    if ([part1 length] > 0) {
        part1 = [part1 substringToIndex:[part1 length]-1];
        
        sql = [NSString stringWithFormat:@"update %@ set %@ where `%@` = '%@'",tableName,part1,wField,wValue];
    }
    
    return sql;
}
//+(NSString*)getInsertSql:(id)targetClass TableName:(NSString*)tableName Exceptions:(NSMutableArray*)exceptions{
//    unsigned int numberOfProperties = 0;
//    objc_property_t *propertyArray = class_copyPropertyList([targetClass class], &numberOfProperties);
//    
//    NSString*sql = nil;
//    
//    NSString*part1 =@"";
//    NSString*part2 =@"";
//    
//    for (NSUInteger i = 0; i < numberOfProperties; i++)
//    {
//        objc_property_t property = propertyArray[i];
//        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
//        if (exceptions!=nil && [exceptions indexOfObject:name] != NSNotFound) {
//            continue;
//        }
//        //NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
//        NSString* value = [targetClass valueForKey:name];
//        if (value==nil) {
//            NSString*item1 = [NSString stringWithFormat:@"`%@`,",name];
//            NSString*item2 = @"'',";
//            
//            part1 = [part1 stringByAppendingString:item1];
//            part2 = [part2 stringByAppendingString:item2];
//        }else{
//            if (value!=nil && [value isKindOfClass:[NSString class]]) {
//                value = [CGlobal escapeString:value];
//                
//                NSString*item1 = [NSString stringWithFormat:@"`%@`,",name];
//                NSString*item2 = [NSString stringWithFormat:@"'%@',",value];
//                
//                part1 = [part1 stringByAppendingString:item1];
//                part2 = [part2 stringByAppendingString:item2];
//            }else if(value!=nil && [value isKindOfClass:[NSNumber class]]){
//                
//                NSString*item1 = [NSString stringWithFormat:@"`%@`,",name];
//                NSString*item2 = [NSString stringWithFormat:@"'%d',",[value intValue]];
//                
//                part1 = [part1 stringByAppendingString:item1];
//                part2 = [part2 stringByAppendingString:item2];
//            }
//        }
//        
////        NSLog(@"Property %@ attributes: %@", name, name);
//    }
//    free(propertyArray);
//    if ([part1 length] > 0) {
//        part1 = [part1 substringToIndex:[part1 length]-1];
//        part2 = [part2 substringToIndex:[part2 length]-1];
//        
//        sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",tableName,part1,part2];
//    }
//    
//    return sql;
//}
+(NSMutableDictionary*)getQuestionDict:(id)targetClass{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([targetClass class], &numberOfProperties);
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableDictionary *questionDict;
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        //NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        NSString* value = [targetClass valueForKey:name];
        if (value!=nil && [value isKindOfClass:[NSString class]]) {
            [objects addObject:value];
            [keys addObject:name];
        }
//        NSLog(@"Property %@ attributes: %@", name, name);
    }
    free(propertyArray);
    if ([objects count] > 0) {
        questionDict = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    }
    
    return questionDict;
}

+(void)parseResponse:(id)targetClass Dict:(NSDictionary*)dict{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([targetClass class], &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        //NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        id value = [dict objectForKey:name];
        
        if (value!=nil && [value isKindOfClass:[NSString class]] && value != [NSNull null] ) {
            [targetClass setValue:value forKey:name];
        }else if (value!=nil && [value isKindOfClass:[NSNumber class]] && value != [NSNull null] ) {
            [targetClass setValue:value  forKey:name];
        }
//        NSLog(@"Property %@ attributes: %@", name, name);
    }
    free(propertyArray);
}
+(void)parseResponseABC:(id)targetClass Dict:(NSDictionary*)dict ABC:(NSDictionary*)abcDict{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([targetClass class], &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        if (abcDict[name] != nil) {
            NSString* nameABC = abcDict[name];
            id value = dict[nameABC];
            
            if (value!=nil && [value isKindOfClass:[NSString class]] && value != [NSNull null] ) {
                [targetClass setValue:value forKey:name];
            }else if (value!=nil && [value isKindOfClass:[NSNumber class]] && value != [NSNull null] ) {
                [targetClass setValue:value  forKey:name];
            }
        }
    }
    free(propertyArray);
}

+(NSData*)buildJsonData:(id)targetClass{
    NSData* jsonData = nil;
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([targetClass class], &numberOfProperties);
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableDictionary *questionDict;
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        //NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        NSString* value = [targetClass valueForKey:name];
        if (value!=nil && [value isKindOfClass:[NSString class]]) {
            [objects addObject:value];
            [keys addObject:name];
        }
//        NSLog(@"Property %@ attributes: %@", name, name);
    }
    free(propertyArray);
    if ([objects count] > 0) {
        questionDict = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        
        NSError * error = nil;
        jsonData = [NSJSONSerialization dataWithJSONObject:questionDict options:NSJSONWritingPrettyPrinted error:&error];
        
        
        
    }
    
    return jsonData;
}
@end





