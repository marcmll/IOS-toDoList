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

@end

@implementation detailedViewController

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self.navigationItem setTitle:self.toDoList.name];
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
    return [[[self toDoList] items] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addItemCell" forIndexPath:indexPath];
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"itemNameCell" forIndexPath:indexPath];
        ToDoListItem *item = [[[[self toDoList] items] allObjects] objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = [item name];
        if([[item isDone]boolValue]){
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
    
    ToDoListItem *item = [[[[self toDoList] items] allObjects] objectAtIndex:indexPath.row - 1];
    if([[item isDone]boolValue]){
        item.isDone = @(0);
    }else{
        item.isDone = @(1);
    }
    [[item managedObjectContext] save:nil];
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
        ToDoListItem *toDoListItem = [[[self.toDoList items] allObjects] objectAtIndex:indexPath.row - 1];
        [[toDoListItem managedObjectContext] deleteObject:toDoListItem];
        [[toDoListItem managedObjectContext] save:nil];
        [tableView reloadData]; // tell table to refresh now
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
    ToDoListItem *toDoListItem = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoListItem" inManagedObjectContext:[[self toDoList] managedObjectContext]];
    toDoListItem.name = itemName;
    [[self toDoList] addItemsObject:toDoListItem];
    [[[self toDoList] managedObjectContext] save:nil];
    [self.tableView reloadData];
    textField.text = @"";
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
