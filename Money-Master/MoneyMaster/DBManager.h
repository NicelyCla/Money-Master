//
//  DBManager.h
//  MoneyMaster
//
//  Created by Clac on 29/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)expensivesTrackerDB;
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
-(void)copyDatabaseIntoDocumentsDirectory;

//----
@property (nonatomic, strong) NSMutableArray *arrResults;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end
