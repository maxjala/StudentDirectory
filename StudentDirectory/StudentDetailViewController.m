//
//  StudentDetailViewController.m
//  StudentDirectory
//
//  Created by Max Jala on 29/03/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

#import "StudentDetailViewController.h"
#import "CoreDataManager.h"

@interface StudentDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@property (weak, nonatomic) NSString *randomAge;

@property (strong, nonatomic) NSArray *genderArray;

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSArray *randomImageArray;


@end

@implementation StudentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[CoreDataManager shared] managedObjectContext];
    // Do any additional setup after loading the view.
   // [self createStudentProfile];
    [self createStudentProfile];
    
    [self generateRandomPicture];
    
    
    
    
}

-(void)createStudentProfile {
    [self.nameTextField setText: self.currentStudent.name];
    [self.ageTextField setText: [NSString stringWithFormat:@"%i", self.currentStudent.age]];
    [self.genderLabel setText: self.currentStudent.gender];
    
}


- (IBAction)updateButton:(UIButton *)sender {
    self.currentStudent.name = self.nameTextField.text;
    self.currentStudent.age = [self.ageTextField.text integerValue];
    self.currentStudent.gender = self.genderLabel.text;
    
    NSError *saveError = NULL;
    [self.context save:&saveError];
    
    if (saveError) {
        //save failed, show alert
        return;
        
    }
    
}


- (IBAction)genderSwitch:(UISwitch *)sender {
    self.genderArray = @[@"Male", @"Female"];
    
    if ([self.genderLabel.text isEqualToString: @"Male"]) {
        self.genderLabel.text = [self.genderArray objectAtIndex:1];
    } else if ([self.genderLabel.text isEqualToString: @"Female"]) {
        self.genderLabel.text = [self.genderArray objectAtIndex:0];
    } else {
        return;
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)generateRandomPicture {

    self.randomImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"mewtwo"], [UIImage imageNamed:@"Raikou"], nil];
    
    int x = arc4random_uniform(2);
    
    [self.imageView setImage:self.randomImageArray[x]];
}








@end
