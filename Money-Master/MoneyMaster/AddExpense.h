//
//  AddExpense.h
//  MoneyMaster
//
//  Created by Clac on 31/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddExpenseDelegate

-(void)editingInfoWasFinished;

@end



@interface AddExpense : UIViewController
@property (nonatomic) NSString *boughtBy;
@property (nonatomic, strong) id<AddExpenseDelegate> delegate;
@property (nonatomic) int recordIDToEdit;

@property (nonatomic) NSString *nomeProdottoTextFieldToEdit;
@property (nonatomic) NSString *priceTextFieldToEdit;
@property (nonatomic) NSString *venditoreTextFieldToEdit;
@property (nonatomic) NSString *dataAcquistoDatePickerToEdit;
@property (nonatomic) NSString *categoriaTextFieldToEdit;
@property (nonatomic) NSString *noteTextFieldToEdit;


@end
