//
//  AppDelegate.h
//  WifiMetry
//
//  Created by Neppoliyan Thangavelu on 3/30/16.
//  Copyright © 2016 Neppoliyan Thangavelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSTimer *locationUpdateTimerGlobal;

@property (nonatomic) NSTimer* locationUpdateTimer;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

