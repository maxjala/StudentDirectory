//
//  AppDelegate.h
//  StudentDirectory
//
//  Created by Max Jala on 28/03/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;




-(void)saveContext;


@end

