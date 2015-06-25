//
//  ToDoListItem.h
//  ToDo
//
//  Created by Marc Mueller on 24/06/15.
//  Copyright (c) 2015 Marc Mueller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ToDoList;

@interface ToDoListItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) ToDoList *toDoList;

@end
