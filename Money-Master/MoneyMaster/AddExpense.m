//
//  AddExpense.m
//  MoneyMaster
//
//  Created by Clac on 31/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//

#import "AddExpense.h"
#import "DBManager.h"

@interface AddExpense ()
@property (weak, nonatomic) IBOutlet UITextField *nomeProdottoTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *venditoreTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataAcquistoDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *categoriaTextField;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

@property (nonatomic, strong) DBManager *dbManager;

-(void)loadInfoToEdit;


@end

@implementation AddExpense

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sample.sql"];

    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addBought:(id)sender {
    
    //create date
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    // Prepare the query string.
    NSString *query;
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"INSERT INTO Bought(oraAcquisto, prezzo, nomeVenditore, descrizione, categoria, note, boughtBy) VALUES ('%@', '%@', '%@' ,'%@', '%@', '%@', '%@');", [dateFormatter stringFromDate:self.dataAcquistoDatePicker.date], self.priceTextField.text,self.venditoreTextField.text,self.nomeProdottoTextField.text,self.categoriaTextField.text, self.noteTextField.text, self.boughtBy];
    }
    else{
        query = [NSString stringWithFormat:@"UPDATE Bought set oraAcquisto='%@', prezzo='%@', nomeVenditore='%@', descrizione='%@', categoria='%@', note='%@' WHERE codBuy=%d",[dateFormatter stringFromDate:self.dataAcquistoDatePicker.date], self.priceTextField.text, self.venditoreTextField.text, self.nomeProdottoTextField.text, self.categoriaTextField.text, self.noteTextField.text, self.recordIDToEdit];
    }
    
    
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
    
    //NSLog(@"le varabili hanno il valore: profilo:%@ investitore:%@ budget:%.2f%@ e la data %@",self.profilesTextField.text, self.investorsTextField.text, [self.budgetTextField.text doubleValue], [self.currencySegmented titleForSegmentAtIndex:[self.currencySegmented selectedSegmentIndex]], [dateFormatter stringFromDate:[NSDate date]]);
    
}

- (IBAction)categories:(id)sender {
    /*
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select a category:"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Delete"
                                  otherButtonTitles:@"Apps & Games", @"Arts, Crafts & Sewing", @"Automotive Parts & accessories", @"Baby", @"Books",@"Cell Phones & Accessories" ,@"Clothing, Shoes & Jewelry" ,@"Computers",@"Courses",@"Digital Music",@"Electronics",@"Health",@"Home",@"Software",@"Sports" ,@"Toys",@"Vehicle" ,  nil];
    [actionSheet showInView:self.view];
     */
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select a category:" message:@"Organize everything at its bests" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Apps & Games" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Apps & Games";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Arts, Crafts & Sewing" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Arts, Crafts & Sewing";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Automotive Parts & accessories" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Automotive Parts & accessories";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Baby" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Baby";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Books" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Books";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cell Phones & Accessories" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Cell Phones & Accessories";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Clothing, Shoes & Jewelry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Clothing, Shoes & Jewelry";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Computers" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Computers";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Courses" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Courses";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Digital Music" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Digital Music";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Electronics" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Electronics";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Health" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Health";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Home" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Home";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Software" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Software";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Sports" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Sports";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Toys" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Toys";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Vehicle" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.categoriaTextField.text=@"Vehicle";
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)filterExpense:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)loadInfoToEdit{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.nomeProdottoTextField.text = self.nomeProdottoTextFieldToEdit;
    self.priceTextField.text = self.priceTextFieldToEdit;
    self.venditoreTextField.text = self.venditoreTextFieldToEdit;
    NSDate *date=[dateFormatter dateFromString:self.dataAcquistoDatePickerToEdit];
    [self.dataAcquistoDatePicker setDate:date];
    self.categoriaTextField.text = self.categoriaTextFieldToEdit;
    self.noteTextField.text = self.noteTextFieldToEdit;
    

}

@end
