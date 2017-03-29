//
//  Student+CoreDataClass.h
//  StudentDirectory
//
//  Created by Max Jala on 29/03/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Teacher+CoreDataClass.h"

@class Teacher;

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Student+CoreDataProperties.h"
