//
//  ViewController.m
//  TestForFMDB
//
//  Created by 薛迎波 on 15/12/13.
//  Copyright © 2015年 XueYingbo. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"



@interface ViewController ()

@property (nonatomic,strong) NSString *dbPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _dbPath = [docPath stringByAppendingPathComponent:@"sqlite.db"];
    
    
    
}

//创建数据库
- (IBAction)createTable:(UIButton *)sender {
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    
    if (![mgr fileExistsAtPath:_dbPath]) {
        FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
        if ([db open]) {
            NSString * sql = @"CREATE TABLE IF NOT EXISTS 'User' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'password' VARCHAR(30))";
            BOOL res = [db executeUpdate:sql];
            if (res) {
                NSLog(@"创建数据库表成功");
            }else{
                NSLog(@"创建数据库表失败");
            }
            
            [db close];
        }else{
            NSLog(@"数据库打开失败");
        }
    }
    
    
}
- (IBAction)insertData:(UIButton *)sender {
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        NSString *sql = @"insert into user (name, password) values(?, ?)";
        BOOL res = [db executeUpdate:sql,@"xueyingbo",@"boy"];
        if (res) {
            NSLog(@"插入数据成功");
        }else{
            NSLog(@"插入数据失败");
        }
        [db close];
    }else{
        NSLog(@"数据库打开失败");
    }
    
}
- (IBAction)queryData:(UIButton *)sender {
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    if ([db open]) {
        NSString *sql = @"select * from user";
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            int userID = [result intForColumn:@"id"];
            NSString *name = [result stringForColumn:@"name"];
            NSString *password = [result stringForColumn:@"password"];
            NSLog(@"user id:%d, name:%@ ,password:%@",userID,name,password);
        }
        [db close];
    }else{
        NSLog(@"数据库打开失败");
    }
    
}
- (IBAction)clearAll:(UIButton *)sender {
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    if ([db open]) {
        NSString *sql = @"delete from user";
        BOOL res = [db executeUpdate:sql];
        if (res) {
            NSLog(@"删除数据成功");
        }else{
            NSLog(@"删除数据失败");
        }
        
        [db close];
    }else{
        NSLog(@"数据库打开失败");
    }
    
}
- (IBAction)multiThread:(UIButton *)sender {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        NSLog(@"q1线程：%@",[NSThread currentThread]);
        for (int i = 0; i < 2; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSLog(@"q11线程：%@",[NSThread currentThread]);
                NSString * sql = @"insert into user (name, password) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"queue111 %d", i];
                BOOL res = [db executeUpdate:sql, name, @"boy"];
                if (!res) {
                    NSLog(@"error to add db data: %@", name);
                } else {
                    NSLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });
    
    dispatch_async(q2, ^{
        NSLog(@"q2线程：%@",[NSThread currentThread]);
        for (int i = 0; i < 2; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSLog(@"q22线程：%@",[NSThread currentThread]);
                NSString * sql = @"insert into user (name, password) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"queue222 %d", i];
                BOOL res = [db executeUpdate:sql, name, @"boy"];
                if (!res) {
                    NSLog(@"error to add db data: %@", name);
                } else {
                    NSLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
