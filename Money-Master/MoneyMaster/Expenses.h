//
//  Expenses.h
//  MoneyMaster
//
//  Created by Clac on 30/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddExpense.h"

@interface Expenses : UITableViewController <UITableViewDelegate, UITableViewDataSource, AddExpenseDelegate>
@property (nonatomic) NSString *recordIDToEdit;
@property (nonatomic) NSString *valuta;


@property int codBuy;
@property (nonatomic) NSString *dataAcquistoDatePickerToEdit;
@property (nonatomic) NSString *priceTextFieldToEdit;
@property (nonatomic) NSString *venditoreTextFieldToEdit;
@property (nonatomic) NSString *nomeProdottoTextFieldToEdit;
@property (nonatomic) NSString *categoriaTextFieldToEdit;
@property (nonatomic) NSString *noteTextFieldToEdit;

@end
