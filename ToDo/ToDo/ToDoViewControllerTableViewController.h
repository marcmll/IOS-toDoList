//
//  ToDoViewControllerTableViewController.h
//  ToDo
//
//  Created by Marc Mueller on 23/06/15.
//  Copyright (c) 2015 Marc Mueller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoList;

@interface ToDoViewControllerTableViewController : UITableViewController

@property (nonatomic, readonly) ToDoList *selectedToDoList;

@end
