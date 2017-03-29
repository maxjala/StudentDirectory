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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *students;

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (weak, nonatomic) Student *selectedStudent;

@property (strong, nonatomic) NSMutableArray *maleStudentsArray;

@property (strong, nonatomic) NSMutableArray *femaleStudentsArray;

@property (weak, nonatomic) Student *genderedStudent;

@property (weak, nonatomic) Student *student;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    [self fetchData];
    [self setupUI];

}

-(void)viewWillAppear:(BOOL)animated {
    [self fetchData];
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
    
}


-(void)buttonAddTapped:(UIButton *)sender {
    
    [self createNewStudent];
    [self fetchData];
    [self.tableView reloadData];
    
}

-(void)createNewStudent {
    
    NSManagedObjectContext *context = [[CoreDataManager shared] managedObjectContext];
    Student *aStudent = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
    
    NSArray *randomGenderArray = @[@"Male", @"Female"];
    int r = arc4random_uniform(2);
    
 
    
    aStudent.name = self.textField.text;
    aStudent.age = arc4random_uniform(30);
    aStudent.gender = randomGenderArray[r];
    
    
    // establish relationship
    aStudent.teacher = self.currentTeacher;
    
    NSError *saveError = NULL;
    [context save:&saveError];
    
    if (saveError) {
        //save failed, show alert
        return;
        
    }
}

-(void)fetchData {
    
    NSFetchRequest *fetchRequest = [Student fetchRequest];
    NSManagedObjectContext *context = [[CoreDataManager shared] managedObjectContext];
    
    //set predicate - unique identifier for teacher
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teacher.fullName == %@", self.currentTeacher.fullName];
    [fetchRequest setPredicate:predicate];
    
    //sort
    //NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES];
    //[fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *fetchError = NULL;
    self.students = [[context executeFetchRequest:fetchRequest error:&fetchError]mutableCopy];
    
    
    if (fetchError) {
        //fetching failed, show alert
        return;
    }
    
    [self filterGender];
   [self.tableView reloadData];
    
    
}

-(void)removeStudents:(Student *)student {
    NSManagedObjectContext *context = [[CoreDataManager shared]managedObjectContext];
    [context deleteObject:student];
    
    
    NSError *saveError = NULL;
    [context save:&saveError];
    if (saveError) {
        return;
    }
    [self fetchData];
}


    


#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Students:";
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView.tag==2) {
        return [self.femaleStudentsArray count];
    } else if (tableView.tag==1) {
        return [self.maleStudentsArray count];
    } else {
    return self.students.count;
        
}
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
    
    //FILTER TABLEVIEW BY GENDER
    if (tableView.tag == 0) {
        self.student = self.students[indexPath.row];
    } else if (tableView.tag ==1) {
        self.student = self.maleStudentsArray[indexPath.row];
    } else {
        self.student = self.femaleStudentsArray[indexPath.row];
    }

        cell.textLabel.text = self.student.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %i                Gender: %@", self.student.age, self.student.gender];
    
    return cell;
    
}

#pragma mark - TableView Delete Function

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        UIAlertController *deleteAlertController = [UIAlertController alertControllerWithTitle:@"Warning:" message:@"Are you sure you want to delete item?" preferredStyle:UIAlertControllerStyleAlert];
        
        //ADD DELETE ACTION
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [self removeStudents:self.students[indexPath.row]];
            
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
    
    self.selectedStudent = self.students[indexPath.row];
    
    StudentDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([StudentDetailViewController class])];
    
    
    controller.currentStudent = self.selectedStudent;
    
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - Segmented Controller Actions and Filters

- (IBAction)filterTableView:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 2) {
        self.tableView.tag = 2;
    }
    else if (sender.selectedSegmentIndex == 1) {
        self.tableView.tag = 1;
    } else {
        self.tableView.tag = 0;
    }
    
    [self.tableView reloadData];
}

-(void)filterGender {
    self.maleStudentsArray = [[NSMutableArray alloc]init];
    self.femaleStudentsArray = [[NSMutableArray alloc]init];
    
    for (_genderedStudent in self.students) {
        if ([_genderedStudent.gender isEqualToString: @"Male"])  {
            [self.maleStudentsArray addObject: _genderedStudent];
        } else {
            [self.femaleStudentsArray addObject:_genderedStudent];
        }
    }
}








@end
