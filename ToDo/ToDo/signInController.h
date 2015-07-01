//
//  signInController.h
//  ToDo
//
//  Created by Marc Mueller on 30/06/15.
//  Copyright (c) 2015 Marc Mueller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signInController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@property (nonatomic, strong) IBOutlet UIButton *signInButton;
@property (nonatomic, strong) IBOutlet UIButton *signUpButton;

@end
