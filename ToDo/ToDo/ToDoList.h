//
//  ToDoList.h
//  ToDo
//
//  Created by Marc Mueller on 24/06/15.
//  Copyright (c) 2015 Marc Mueller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ToDoListItem;

@interface ToDoList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rowId;
@property (nonatomic, retain) NSSet *items;
@end

@interface ToDoList (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ToDoListItem *)value;
- (void)removeItemsObject:(ToDoListItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
