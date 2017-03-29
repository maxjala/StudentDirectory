//
//  Teacher+CoreDataProperties.h
//  StudentDirectory
//
//  Created by Max Jala on 29/03/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

#import "Teacher+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fullName;
@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *subject;
@property (nullable, nonatomic, retain) Student *student;

@end

NS_ASSUME_NONNULL_END
