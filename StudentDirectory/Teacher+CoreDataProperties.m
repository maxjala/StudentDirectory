//
//  Teacher+CoreDataProperties.m
//  StudentDirectory
//
//  Created by Max Jala on 29/03/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Teacher"];
}

@dynamic fullName;
@dynamic age;
@dynamic subject;
@dynamic student;

@end
