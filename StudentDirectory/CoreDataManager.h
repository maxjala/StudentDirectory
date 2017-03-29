//
//  CoreDataManager.h
//  StudentDirectory
//
//  Created by Max Jala on 28/03/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+(instancetype)shared;

- (NSManagedObjectContext *) managedObjectContext;

@end
