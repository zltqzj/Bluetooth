//
//  LoginViewController.m
//  BLE
//
//  Created by zkr on 5/12/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

-(IBAction)regist:(id)sender{
    RegistViewController* regist = viewOnSb(@"RegistViewController");
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController pushViewController:regist animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    _username.delegate = self;
    _password.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_password resignFirstResponder];
    [_username resignFirstResponder];
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
