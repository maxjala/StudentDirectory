//
//  StudentDetailViewController.h
//  StudentDirectory
//
//  Created by Max Jala on 29/03/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Student+CoreDataClass.h"

@interface StudentDetailViewController : UIViewController

@property (strong, nonatomic) Student *currentStudent;


@end
