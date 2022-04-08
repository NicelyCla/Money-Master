//
//  addProfiles.h
//  MoneyMaster
//
//  Created by Clac on 29/05/18.
//  Copyright © 2018 Clac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoViewControllerDelegate

-(void)editingInfoWasFinished;

@end

@interface addProfiles : UIViewController

@property (nonatomic, strong) id<EditInfoViewControllerDelegate> delegate;


@end
