//
//  LoginViewController.h
//  BLE
//
//  Created by zkr on 5/12/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property(weak,nonatomic) IBOutlet UITextField* username;
@property(weak,nonatomic) IBOutlet UITextField* password;




-(IBAction)regist:(id)sender;

@end
