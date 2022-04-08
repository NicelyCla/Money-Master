//
//  Expenses.m
//  MoneyMaster
//
//  Created by Clac on 30/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//

#import "Expenses.h"
#import "AddExpense.h"
#import "DBManager.h"

@interface Expenses ()
@property (strong, nonatomic) IBOutlet UITableView *tblBoughts;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrBoughtsInfo;
@property (nonatomic, strong) NSMutableArray *arrCategory;
@property (nonatomic, strong) NSString *query;
@property (weak, nonatomic) IBOutlet UILabel *totalCosts;
@property float totalExpenses;
@property int interruttoreCategorie;

-(void)loadData;

@end

@implementation Expenses

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrCategory = [[NSMutableArray alloc] init];
    [self.arrCategory addObject:@"All categories"];
    self.interruttoreCategorie = 1;

    // Make self the delegate and datasource of the table view.
    self.tblBoughts.delegate = self;
    self.tblBoughts.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sample.sql"];
    
    //Load the data
    [self loadData];
    
    //change textbox

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
    return self.arrBoughtsInfo.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(void)loadData{

    if(self.interruttoreCategorie==1){
        self.arrCategory = [[NSMutableArray alloc] init];
        [self.arrCategory addObject:@"All categories"];
        self.interruttoreCategorie=0;
    }
    self.totalExpenses = 0.0;

    // Form the query.
    NSString *query;
    if([self.query length] == 0){
        query = [NSString stringWithFormat:@"SELECT * FROM Bought WHERE boughtBy='%@'", self.recordIDToEdit];
    }
    else{
        query = self.query;
    }
    // Get the results.
    if (self.arrBoughtsInfo != nil) {
        self.arrBoughtsInfo = nil;
    }
    self.arrBoughtsInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblBoughts reloadData];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"boughtRecord";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    /*
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
     reuseIdentifier:@"ProfilesRecord"];
     }
     */
    
    
    NSInteger indexOfOraAcquisto = [self.dbManager.arrColumnNames indexOfObject:@"oraAcquisto"];
    NSInteger indexOfPrezzo = [self.dbManager.arrColumnNames indexOfObject:@"prezzo"];
    NSInteger indexOfNomeVenditore = [self.dbManager.arrColumnNames indexOfObject:@"nomeVenditore"];
    NSInteger indexOfDescrizione = [self.dbManager.arrColumnNames indexOfObject:@"descrizione"];
    NSInteger indexOfCategoria = [self.dbManager.arrColumnNames indexOfObject:@"categoria"];
    NSInteger indexOfNote = [self.dbManager.arrColumnNames indexOfObject:@"note"];

    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDescrizione]];
    NSString *prezzo = [NSString stringWithFormat:@"Price: %@", [[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPrezzo]];
    NSString *categoria =[[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCategoria];
    
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@%@",prezzo,self.valuta];
   
    self.totalExpenses+=[[[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPrezzo] floatValue];
    self.totalCosts.text=[NSString stringWithFormat:@"Total expenses: %.2f%@",self.totalExpenses,self.valuta];

    if([self.arrCategory indexOfObject:categoria] == NSNotFound) {
        [self.arrCategory addObject:categoria];
    }
    
    //[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
}

-(void)editingInfoWasFinished{

    // Reload the data.
    [self loadData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordoIDtoDelete = [[[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        //int recordIDToDelete = [[[self.arrProfilesInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"DELETE FROM Bought WHERE codBuy=%d", recordoIDtoDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
}
- (IBAction)category:(id)sender {
    //NSArray *numbersArrayList = @[@"One", @"Two", @"Three", @"Four", @"Five", @"Six"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Filter by Category:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int j =0 ; j<self.arrCategory.count; j++){
        NSString *titleString = self.arrCategory[j];
        UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //NSLog(@"Selected Value: %@",self.arrCategory[j]);
            if([self.arrCategory[j] isEqualToString:@"All categories"]){
                self.query = [NSString stringWithFormat:@"SELECT * FROM Bought WHERE boughtBy='%@'", self.recordIDToEdit];
                [self loadData];
            }
            else{
                self.query = [NSString stringWithFormat:@"SELECT * FROM Bought WHERE boughtBy='%@' AND categoria='%@'", self.recordIDToEdit, self.arrCategory[j]];
                [self loadData];
                
            }
            
        }];
        
        [alertController addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];

}

- (IBAction)refresh:(id)sender {
    [self loadData];
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

    
    if([[segue identifier] isEqualToString:@"addPurchaseLink"]){
        AddExpense *addExpense = [segue destinationViewController];
        addExpense.delegate = self;
        addExpense.boughtBy = self.recordIDToEdit;
        addExpense.recordIDToEdit = -1;
    }
    else{
        //resetta le categorie che vengono tutte le volte autogenerate e controllate attraverso questo interruttore
        self.interruttoreCategorie=1;
        NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
        self.codBuy = [[[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        self.dataAcquistoDatePickerToEdit = [[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:1];
        self.priceTextFieldToEdit = [[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:2];
        self.venditoreTextFieldToEdit = [[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:3];
        self.nomeProdottoTextFieldToEdit = [[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:4];
        self.categoriaTextFieldToEdit = [[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:5];
        self.noteTextFieldToEdit = [[self.arrBoughtsInfo objectAtIndex:indexPath.row] objectAtIndex:6];
        AddExpense *addExpenses = [segue destinationViewController];
        addExpenses.delegate = self;
        addExpenses.recordIDToEdit = self.codBuy;
        addExpenses.dataAcquistoDatePickerToEdit = self.dataAcquistoDatePickerToEdit;
        addExpenses.priceTextFieldToEdit = self.priceTextFieldToEdit;
        addExpenses.venditoreTextFieldToEdit = self.venditoreTextFieldToEdit;
        addExpenses.nomeProdottoTextFieldToEdit = self.nomeProdottoTextFieldToEdit;
        addExpenses.categoriaTextFieldToEdit = self.categoriaTextFieldToEdit;
        addExpenses.noteTextFieldToEdit = self.noteTextFieldToEdit;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
