//
//  detailedViewController.h
//  ToDo
//
//  Created by Marc Mueller on 25/06/15.
//  Copyright (c) 2015 Marc Mueller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoList.h"

@interface DetailedViewController : UITableViewController

@property (nonatomic, strong) ToDoList *toDoList;

@end
