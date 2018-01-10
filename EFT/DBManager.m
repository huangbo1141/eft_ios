//
//  DBManager.m
//  SQLite3DBSample
//
//  Created by Gabriel Theodoropoulos on 25/6/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "DBManager.h"
#import "CGlobal.h"
#import <sqlite3.h>


@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;

@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrResults;


-(void)copyDatabaseIntoDocumentsDirectory;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end


@implementation DBManager

#pragma mark - Initialization

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = dbFilename;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
        
    }
    return self;
}
-(void) deleteDatabase:(NSString *)filepath{
    //delete file
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    BOOL fileExists = [fileManager fileExistsAtPath:filepath];
    
    if (fileExists)
    {
        BOOL success = [fileManager removeItemAtPath:filepath error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        
    }
}


#pragma mark - Private method implementation

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        //[self deleteDatabase:sourcePath];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    //[self deleteDatabase:destinationPath];
}



-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // In this case data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                
                // Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}


#pragma mark - Public method implementation

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrResults;
}


-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}
//
// erg_id   erg_city    erg_state   erg_country     erg_zipcode
//          erg_type    erg_lat     erg_lon         erg_address     erg_placeid
// region table
-(long long)insertLocation:(EftRegion*)region{
    NSString*query;
    if (region.erg_type == 1) {
        query = [NSString stringWithFormat:@"insert into region(erg_city,erg_state,erg_country,erg_zipcode,erg_type,erg_lat,erg_lon,erg_address,erg_placeid) values ('%@','%@','%@','%@','%d','','','','')",region.erg_city,region.erg_state,region.erg_country,region.erg_zipcode,region.erg_type];
    }else if(region.erg_type == 2){
        query = [NSString stringWithFormat:@"insert into region(erg_city,erg_state,erg_country,erg_zipcode,erg_type,erg_lat,erg_lon,erg_address,erg_placeid) values ('','','','','%d','%@','%@','%@','%@')",region.erg_type,region.erg_lat,region.erg_lon,region.erg_address,region.eft_googleplace.place_id];
    }
    [self executeQuery:query];
    
    return _lastInsertedRowID;
}
-(long long)deleteLocation:(EftRegion*)region{
    NSString*query = [NSString stringWithFormat:@"delete from region where erg_id = %d",region.erg_id];
    
    [self executeQuery:query];
    
    return 1;
}
-(NSArray*)getLocation{
    NSMutableArray*retarray = [[NSMutableArray alloc] init];
    
    NSString* query = @"select * from region order by erg_id desc";
    NSArray *array = [self loadDataFromDB:query];
    
    for (id obj in array) {
        NSArray*item = (NSArray*)obj;
        EftRegion *model = [[EftRegion alloc] initFromDb:item];
        [retarray addObject:model];
    }

    return retarray;
}
-(BOOL)checkDatabaseForRegion:(EftRegion*)region{
    NSString*query;
    if (region.erg_type == 1) {
        query = [NSString stringWithFormat:@"select * from  region where erg_city='%@' and erg_state='%@' and erg_country='%@' and erg_zipcode='%@' and erg_type='%d'",region.erg_city,region.erg_state,region.erg_country,region.erg_zipcode,region.erg_type];
    }else if(region.erg_type == 2){
        query = [NSString stringWithFormat:@"select * from region where erg_type='%d' and erg_placeid='%@' ",region.erg_type,region.eft_googleplace.place_id];
    }
    NSArray*array = [self loadDataFromDB:query];
    if ([array count]>0) {
        return true;
    }else{
        return  false;
    }
}
@end
