//
//  addProfiles.m
//  MoneyMaster
//
//  Created by Clac on 29/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//

#import "addProfiles.h"
#import "DBManager.h"

@interface addProfiles ()
@property (weak, nonatomic) IBOutlet UITextField *profilesTextField;
@property (weak, nonatomic) IBOutlet UITextField *investorsTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *currencySegmented;

@property (nonatomic, strong) DBManager *dbManager;
@end

@implementation addProfiles

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sample.sql"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addProfiles:(id)sender {
  
    
    //create date
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    // Prepare the query string.
    NSString *query = [NSString stringWithFormat:@"INSERT INTO Profile(nome, valuta, dataCreazione, creatoDa) VALUES ('%@', '%@', '%@' ,'%@');", self.profilesTextField.text, [self.currencySegmented titleForSegmentAtIndex:[self.currencySegmented selectedSegmentIndex]], [dateFormatter stringFromDate:[NSDate date]],self.investorsTextField.text];

    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        [self.delegate editingInfoWasFinished];

        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
