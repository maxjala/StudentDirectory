//
//  ViewController.h
//  StudentDirectory
//
//  Created by Max Jala on 28/03/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Teacher+CoreDataClass.h"

@interface ViewController : UIViewController

//-(void)configureManagedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, strong) Teacher *currentTeacher;

@end

