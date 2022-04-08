//
//  ModifyProfiles.m
//  MoneyMaster
//
//  Created by Clac on 30/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//

#import "ModifyProfiles.h"
#import "DBManager.h"

@interface ModifyProfiles ()
@property (weak, nonatomic) IBOutlet UITextField *profilesTextField;
@property (weak, nonatomic) IBOutlet UITextField *investorsTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *currencySegmented;

@property (nonatomic, strong) DBManager *dbManager;

-(void)loadInfoToEdit;

@end

@implementation ModifyProfiles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sample.sql"];


    [self loadInfoToEdit];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadInfoToEdit{
    
    self.profilesTextField.text =self.recordIDToEdit;
    self.investorsTextField.text = self.investorsToEdit;
    
    if([self.currencyToEdit isEqualToString:@"€"]){
        self.currencySegmented.selectedSegmentIndex = 0;
    }
    else if([self.currencyToEdit isEqualToString:@"$"]){
        self.currencySegmented.selectedSegmentIndex = 1;
    }
    else if([self.currencyToEdit isEqualToString:@"£"]){
        self.currencySegmented.selectedSegmentIndex = 2;
    }
    else if([self.currencyToEdit isEqualToString:@"₽"]){
        self.currencySegmented.selectedSegmentIndex = 3;
    }
    else if([self.currencyToEdit isEqualToString:@"¥"]){
        self.currencySegmented.selectedSegmentIndex = 4;
    }
    else if([self.currencyToEdit isEqualToString:@"BTC"]){
        self.currencySegmented.selectedSegmentIndex = 5;
    }
    else if([self.currencyToEdit isEqualToString:@"ETH"]){
        self.currencySegmented.selectedSegmentIndex = 6;
    }
    
    /*
    self.investorsTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"creatoDa"]];
    self.budgetTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"budget"]];
     */
     
}

- (IBAction)modifyProfilesButton:(id)sender {
    NSString *query;

        query = [NSString stringWithFormat:@"UPDATE Profile set nome='%@', creatoDa='%@', valuta='%@' WHERE nome='%@'", self.profilesTextField.text, self.investorsTextField.text, [self.currencySegmented titleForSegmentAtIndex:[self.currencySegmented selectedSegmentIndex]] ,self.recordIDToEdit];
    
    
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
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
