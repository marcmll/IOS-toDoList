//
//  detailedViewController.m
//  ToDo
//
//  Created by Marc Mueller on 25/06/15.
//  Copyright (c) 2015 Marc Mueller. All rights reserved.
//

#import "DetailedViewController.h"
#import "ToDoListItem.h"

@interface DetailedViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *toDoListItems;

@end

@implementation DetailedViewController

- (BOOL)canBecomeFirstResponder{
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.navigationItem setTitle:self.toDoList.name];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return [[[self toDoList] items] count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if (indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"addItemCell" forIndexPath:indexPath];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"itemNameCell" forIndexPath:indexPath];
		UIEdgeInsets separatorInsets = cell.separatorInset;
		cell.separatorInset = UIEdgeInsetsMake(separatorInsets.top, 10.0, separatorInsets.bottom, separatorInsets.right);
		cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
		ToDoListItem *item = [[[[self toDoList] items] array] objectAtIndex:indexPath.row - 1];
		cell.textLabel.text = [item name];
		if([[item isDone]boolValue]){
			cell.imageView.image = [UIImage imageNamed:@"checkboxTicked"];
			cell.textLabel.textColor = [UIColor grayColor];
		}else{
			cell.imageView.image = [UIImage imageNamed:@"checkboxUnticked"];
			cell.textLabel.textColor = [UIColor blackColor];
		}
	}
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSIndexPath *toIndexPath = nil;
	
	ToDoListItem *item = [[[[self toDoList] items] array] objectAtIndex:indexPath.row - 1];
	if([[item isDone] boolValue]){
		item.isDone = @(0);
		
		toIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
		[tableView moveRowAtIndexPath:indexPath toIndexPath:toIndexPath];
		
	} else {
		item.isDone = @(1);
		
		toIndexPath = [NSIndexPath indexPathForRow:[[[self toDoList] items] count] inSection:0];
		[tableView moveRowAtIndexPath:indexPath toIndexPath:toIndexPath];
	}
	
	NSMutableArray *items = [[[self.toDoList items] array] mutableCopy];
	[items removeObject:item];
	[items insertObject:item atIndex:toIndexPath.row - 1];
	self.toDoList.items = [[NSOrderedSet alloc] initWithArray:items];
	
	[[item managedObjectContext] save:nil];
	[tableView reloadRowsAtIndexPaths:@[toIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	 // tell table to refresh now
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// The initial row is reserved for adding new items so it can't be moved.
	if (indexPath.row == 0) {
		return NO;
	}
	
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		ToDoListItem *toDoListItem = [[[self.toDoList items] array] objectAtIndex:indexPath.row - 1];
		[[toDoListItem managedObjectContext] deleteObject:toDoListItem];
		[[toDoListItem managedObjectContext] save:nil];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft]; // tell table to refresh now
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if (![textField.text isEqualToString:@""]) {
		NSString *itemName = textField.text;
		ToDoListItem *toDoListItem = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoListItem" inManagedObjectContext:[[self toDoList] managedObjectContext]];
		toDoListItem.name = itemName;
		toDoListItem.toDoList = self.toDoList;
		
		NSMutableArray *items = [[[self.toDoList items] array] mutableCopy];
		[items removeObject:toDoListItem];
		[items insertObject:toDoListItem atIndex:0];
		self.toDoList.items = [[NSOrderedSet alloc] initWithArray:items];
		
		[[[self toDoList] managedObjectContext] save:nil];
		[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		textField.text = @"";
	}
	
	[textField resignFirstResponder];
	
	return YES;
}

@end
