//
//  ViewController.m
//  StudentDirectory
//
//  Created by Max Jala on 28/03/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

#import "ViewController.h"
#import "Student+CoreDataClass.h"
#import "CoreDataManager.h"
#import "StudentDetailViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *students;

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (weak, nonatomic) Student *selectedStudent;

@property (strong, nonatomic) NSMutableArray *maleStudentsArray;

@property (strong, nonatomic) NSMutableArray *femaleStudentsArray;

//@property (weak, nonatomic) Student *student;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    //[self filterGender];
    [self setupUI];

}

-(void)viewWillAppear:(BOOL)animated {
    [self filterGender];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

-(void)setupUI {
    
    [self.buttonAdd addTarget:self action:@selector(buttonAddTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

-(void)setUpData {
    
    self.students = [NSMutableArray array];
    
    NSFetchRequest *fetchRequest = [Student fetchRequest];
    self.context = [[CoreDataManager shared] managedObjectContext];
    
    //set predicate - unique identifier for teacher
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teacher.fullName == %@", self.currentTeacher.fullName];
    [fetchRequest setPredicate:predicate];
    
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:NULL cacheName:NULL];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
  
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:NULL cacheName:NULL];
    
    self.fetchedResultsController.delegate = self; //will observe changes in table view and database;
    NSError *fetchControllerError = NULL;
    [self.fetchedResultsController performFetch:&fetchControllerError];
    
    if (fetchControllerError) {
        NSLog(@"FetchController Error: %@", fetchControllerError);
    }
    
    [self filterGender];
    
}


-(void)buttonAddTapped:(UIButton *)sender {
    
    [self createNewStudent];
    
}

-(void)createNewStudent {
    
    //NSManagedObjectContext *context = [[CoreDataManager shared] managedObjectContext];
    Student *aStudent = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
    
    NSArray *randomGenderArray = @[@"Male", @"Female"];
    int r = arc4random_uniform(2);
    
 
    
    aStudent.name = self.textField.text;
    aStudent.age = arc4random_uniform(30);
    aStudent.gender = randomGenderArray[r];
    
    
    //Disable Empty Entries
    if ([self.textField.text isEqualToString:@""]) {
        return;
    }
    
    
    // establish relationship
    aStudent.teacher = self.currentTeacher;
    
    NSError *saveError = NULL;
    [self.context save:&saveError];
    
    if (saveError) {
        //save failed, show alert
        return;
        
    }
    [self filterGender];
    //[self.tableView reloadData];
}

-(void)removeStudents:(Student *)student {
    NSManagedObjectContext *context = [[CoreDataManager shared]managedObjectContext];
    [context deleteObject:student];
    
    
    NSError *saveError = NULL;
    [context save:&saveError];
    if (saveError) {
        return;
    }
    [self filterGender];
    //[self.tableView reloadData];

}


#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView.tag == 0) {
        return @"All Students:";
    } else if (tableView.tag ==1) {
        return @"Male Students:";
    } else {
        return @"Female Students:";
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView.tag==2) {
        return [self.femaleStudentsArray count];
    } else if (tableView.tag==1) {
        return [self.maleStudentsArray count];
    } else {
        return self.fetchedResultsController.fetchedObjects.count;

}
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
    
    Student *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //FILTER TABLEVIEW BY GENDER
    if (tableView.tag == 0) {
        //student = self.students[indexPath.row];
      student = self.fetchedResultsController.fetchedObjects[indexPath.row];
    } else if (tableView.tag ==1) {
        student = self.maleStudentsArray[indexPath.row];
    } else {
        student = self.femaleStudentsArray[indexPath.row];
    }
    
    cell.textLabel.text = student.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %i                Gender: %@", student.age, student.gender];
    
    return cell;
    
}

#pragma mark - TableView Delete Function

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        UIAlertController *deleteAlertController = [UIAlertController alertControllerWithTitle:@"Warning:" message:@"Are you sure you want to delete item?" preferredStyle:UIAlertControllerStyleAlert];
        
        //ADD DELETE ACTION
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [self removeStudents:self.fetchedResultsController.fetchedObjects[indexPath.row]];
            
            
        }];
        [deleteAlertController addAction:deleteAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [deleteAlertController addAction:cancelAction];
        
        [self presentViewController:deleteAlertController animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.selectedStudent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    StudentDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([StudentDetailViewController class])];
    
    
    controller.currentStudent = self.selectedStudent;
    
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - Segmented Controller Actions and Filters


- (IBAction)filterTableView:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 2) {
        self.tableView.tag = 2;
        //[self.tableView reloadData];
    }
    else if (sender.selectedSegmentIndex == 1) {
        self.tableView.tag = 1;
        //[self.tableView reloadData];
    } else {
        self.tableView.tag = 0;
        //[self.tableView reloadData];
    }
    
    [self.tableView reloadData];
}


-(void)filterGender {
    self.maleStudentsArray = [[NSMutableArray alloc]init];
    self.femaleStudentsArray = [[NSMutableArray alloc]init];
    
    for (Student *genderedStudent in self.fetchedResultsController.fetchedObjects) {
        if ([genderedStudent.gender isEqualToString: @"Male"])  {
            [self.maleStudentsArray addObject: genderedStudent];
        } else {
            [self.femaleStudentsArray addObject:genderedStudent];
        }
    }
    //[self.tableView reloadData];
   
}

#pragma mark - NSFetchedResultsController Delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath; {
    
    [self.tableView beginUpdates];
    
    switch (type) { //type is value you want to check
            case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeMove:
        {
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;

    }
    
//perform the same as an if statement --> if(type == NSFetchedResultsChangeInsert {
    
//} else if (_____) { etc...

    
    [self.tableView endUpdates];
}








@end
