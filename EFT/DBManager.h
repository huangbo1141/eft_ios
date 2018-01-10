//
//  DBManager.h
//  SQLite3DBSample
//
//  Created by Gabriel Theodoropoulos on 25/6/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EftRegion.h"
@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;


-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;


-(long long)deleteLocation:(EftRegion*)region;
-(long long)insertLocation:(EftRegion*)region;
-(BOOL)checkDatabaseForRegion:(EftRegion*)region;
-(NSArray*)getLocation;

@end
