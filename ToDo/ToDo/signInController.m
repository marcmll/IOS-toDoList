//
//  signInController.m
//  ToDo
//
//  Created by Marc Mueller on 30/06/15.
//  Copyright (c) 2015 Marc Mueller. All rights reserved.
//

#import "signInController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface signInController ()

@end

@implementation signInController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valueDidChange:(id)sender {
    
    if (![_usernameField.text isEqualToString:@""] && ![_passwordField.text isEqualToString:@""]) {
        _signInButton.enabled = YES;
        _signUpButton.enabled = YES;
    }else{
        _signInButton.enabled = NO;
        _signUpButton.enabled = NO;
    }
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)signUp:(id)sender {
    PFUser *user = [PFUser user];
    user.username = _usernameField.text;
    user.password = _passwordField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
//            success
            [self performSegueWithIdentifier:@"signUpSegue" sender:self];
            
            
        } else {   NSString *errorString = [error userInfo][@"error"];
            
//            fail
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorString
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil,nil];
            [alert show];
            _usernameField.text = @"";
            _passwordField.text = @"";
            
        }
    }];
}

- (IBAction)signIn:(id)sender {
    
    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            [self performSegueWithIdentifier:@"signInSegue" sender:self];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSString *errorString = [error userInfo][@"error"];
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                            message:errorString
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"Okay"
                                                                                  otherButtonTitles:nil,nil];
                                            [alert show];
                                            _usernameField.text = @"";
                                            _passwordField.text = @"";
                                            
                                        }
                                    }];
    
}

@end
