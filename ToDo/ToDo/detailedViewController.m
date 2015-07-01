//
//  detailedViewController.m
//  ToDo
//
//  Created by Marc Mueller on 25/06/15.
//  Copyright (c) 2015 Marc Mueller. All rights reserved.
//

#import "detailedViewController.h"
#import "ToDoListItem.h"

@interface detailedViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *toDoListItems;

@end

@implementation detailedViewController

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self fetchItems];
    
    
    [self.navigationItem setTitle:[self.toDoList valueForKey: @"name"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.toDoListItems count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addItemCell" forIndexPath:indexPath];
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"itemNameCell" forIndexPath:indexPath];
        PFObject *item = [self.toDoListItems objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = [item valueForKey:@"name"];
        if([[item valueForKey:@"isDone"]boolValue]){
            cell.imageView.image = [UIImage imageNamed:@"checkboxTicked"];
            cell.textLabel.textColor = [UIColor grayColor];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"checkboxUnticked"];
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    
    
    // Configure the cell...
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *item = [self.toDoListItems objectAtIndex:indexPath.row - 1];
    
    if([[item valueForKey:@"isDone"]boolValue]){
        [item setValue:@NO forKey:@"isDone"];
    }else{
        [item setValue:@YES forKey:@"isDone"];
    }

    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saved");
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@",errorString);
        }
    }];
    
    //[[item managedObjectContext] save:nil];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic]; // tell table to refresh now
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        PFObject *toDoListItem = [self.toDoListItems objectAtIndex:indexPath.row - 1];
//        [[toDoListItem managedObjectContext] deleteObject:toDoListItem];
//        [[toDoListItem managedObjectContext] save:nil];
        [toDoListItem deleteInBackground];
        [self fetchItems];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *itemName = textField.text;
//    ToDoListItem *toDoListItem = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoListItem" inManagedObjectContext:[[self toDoList] managedObjectContext]];
//    toDoListItem.name = itemName;
//    [[self toDoList] addItemsObject:toDoListItem];
//    [[[self toDoList] managedObjectContext] save:nil];
    
    PFObject *item = [PFObject objectWithClassName:@"Items"];
    item[@"name"] = itemName;
    item[@"isDone"] = @NO;
    item[@"listId"] = [self.toDoList valueForKey:@"objectId"];
    item[@"rowId"] = @([self.toDoListItems count]+1);
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self fetchItems];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@",errorString);
        }
    }];
    
    [self.tableView reloadData];
    textField.text = @"";
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)fetchItems
{
    
    NSString *listId = [self.toDoList valueForKey:@"objectId"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Items"];
    [query whereKey:@"listId" equalTo:listId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.toDoListItems = [objects mutableCopy];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


@end
