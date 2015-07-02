//
//  ToDoViewControllerTableViewController.m
//  ToDo
//
//  Created by Marc Mueller on 23/06/15.
//  Copyright (c) 2015 Marc Mueller. All rights reserved.
//

#define MAINCONTEXT [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]

#import "ToDoViewControllerTableViewController.h"
#import "AddItemViewController.h"
#import "DetailedViewController.h"
#import "ToDoList.h"
#import "AppDelegate.h"

@interface ToDoViewControllerTableViewController ()

@property (nonatomic, strong) NSMutableArray *todoList;
@property (nonatomic, strong) NSFetchedResultsController *toDoListController;
@property (nonatomic, strong) ToDoList *selectedToDoList;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end

@implementation ToDoViewControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ToDoListCell"];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.toDoListController performFetch:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
}

- (IBAction)saveItem:(UIStoryboardSegue *)segue {

    NSString *toDoListName = [[((AddItemViewController *)segue.sourceViewController) todoListName] text];
    ToDoList *toDoList = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoList" inManagedObjectContext:MAINCONTEXT];
    toDoList.name = toDoListName;
    toDoList.rowId = @([[self.toDoListController fetchedObjects] count]+1);
    [MAINCONTEXT save:nil];
    [self.toDoListController performFetch:nil];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.toDoListController fetchedObjects] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    ToDoList *todoList = [self.toDoListController objectAtIndexPath:indexPath];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoListCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [todoList name];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedToDoList = [[self toDoListController] objectAtIndexPath:indexPath];
	[self performSegueWithIdentifier:@"detailedSegue" sender:self];
	
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		ToDoList *toDoList = [self.toDoListController objectAtIndexPath:indexPath];
		[MAINCONTEXT deleteObject:toDoList];
		[MAINCONTEXT save:nil];
		[self.toDoListController performFetch:nil];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft]; // tell table to refresh now
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
	NSMutableArray *allObjects = [[self.toDoListController fetchedObjects] mutableCopy];
	ToDoList *toDoList = [self.toDoListController objectAtIndexPath:fromIndexPath];
	
	[allObjects removeObject:toDoList];
	[allObjects insertObject:toDoList atIndex:toIndexPath.row];
	[allObjects enumerateObjectsUsingBlock:^(ToDoList *object, NSUInteger idx, BOOL *stop) {
		object.rowId = @(idx + 1);
	}];
	
	[MAINCONTEXT save:nil];
	[self.toDoListController performFetch:nil];
	
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailedSegue"]) {
        DetailedViewController *detailedViewController = segue.destinationViewController;
        detailedViewController.toDoList = [self selectedToDoList];
    }else if ([segue.identifier isEqualToString:@"noUser"]){
        UIViewController *signIn = segue.destinationViewController;
        signIn.navigationItem.hidesBackButton = YES;
    }
    
    
}

#pragma mark - NSFetchResultCrontroller

- (NSFetchedResultsController *)toDoListController {
    if(!_toDoListController){
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ToDoList" inManagedObjectContext:MAINCONTEXT];
        request.entity = entity;
        
        NSSortDescriptor *sortIdentifier = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
        
        [request setSortDescriptors:@[sortIdentifier]];
        
        NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:MAINCONTEXT sectionNameKeyPath:nil cacheName:@"toDoList"];
        
        _toDoListController = fetchController;
//        _toDoListController.delegate = self;
    }
    return _toDoListController;
}

@end
