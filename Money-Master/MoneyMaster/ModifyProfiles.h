//
//  ModifyProfiles.h
//  MoneyMaster
//
//  Created by Clac on 30/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyProfilesDelegate

-(void)editingInfoWasFinished;

@end

@interface ModifyProfiles : UIViewController
@property (nonatomic) NSString *recordIDToEdit;
@property (nonatomic) NSString *investorsToEdit;
@property (nonatomic) NSString *currencyToEdit;

@property (nonatomic, strong) id<ModifyProfilesDelegate> delegate;

@end
