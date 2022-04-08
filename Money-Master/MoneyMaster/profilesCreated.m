//
//  profilesCreated.m
//  MoneyMaster
//
//  Created by Clac on 29/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//

#import "profilesCreated.h"
#import "addProfiles.h"
#import "ModifyProfiles.h"
#import "Expenses.h"
#import "DBManager.h"

@interface profilesCreated ()
@property (strong, nonatomic) IBOutlet UITableView *tblProfiles;

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrProfilesInfo;

@property (nonatomic) NSString *recordIDToEdit;
@property (nonatomic) NSString *investorsToEdit;
@property (nonatomic) NSString *currencyToEdit;



-(void)loadData;


@end

@implementation profilesCreated

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Make self the delegate and datasource of the table view.
    self.tblProfiles.delegate = self;
    self.tblProfiles.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sample.sql"];

    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ProfilesRecord" ];
    
    //Load the data
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrProfilesInfo.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue the cell.
    static NSString *CellIdentifier = @"ProfilesRecord";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSInteger indexOfname = [self.dbManager.arrColumnNames indexOfObject:@"nome"];
    NSInteger indexOfvaluta = [self.dbManager.arrColumnNames indexOfObject:@"valuta"];
    NSInteger indexOfDataCreazione = [self.dbManager.arrColumnNames indexOfObject:@"dataCreazione"];
    NSInteger indexOfcreatoDa = [self.dbManager.arrColumnNames indexOfObject:@"creatoDa"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfname]];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created by: %@", [[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfcreatoDa]];
    //[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];

    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)loadData{
    // Form the query.
    NSString *query = @"SELECT * FROM Profile";
    
    // Get the results.
    if (self.arrProfilesInfo != nil) {
        self.arrProfilesInfo = nil;
    }
    self.arrProfilesInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblProfiles reloadData];
}

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        NSString *recordoIDtoDelete = [[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:0];
        
        //int recordIDToDelete = [[[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"DELETE FROM Profile WHERE nome='%@'", recordoIDtoDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
    
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addNewProfiles"]) {

        addProfiles *editInfoViewController = [segue destinationViewController];
        editInfoViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"modifyProfileRow"]) {
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:sender];
        
        self.recordIDToEdit = [[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:0];
        self.currencyToEdit = [[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:1];
        self.investorsToEdit = [[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:3];
        
        ModifyProfiles *modificaProfilo = [segue destinationViewController];
        modificaProfilo.delegate = self;
        modificaProfilo.recordIDToEdit = self.recordIDToEdit;
        modificaProfilo.investorsToEdit = self.investorsToEdit;
        modificaProfilo.currencyToEdit = self.currencyToEdit;
        
    }
    else{
        NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
        self.recordIDToEdit = [[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:0];
        self.currencyToEdit = [[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:1];
        Expenses *expenses = [segue destinationViewController];
        expenses.recordIDToEdit = self.recordIDToEdit;
        expenses.valuta = self.currencyToEdit;
        
    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
