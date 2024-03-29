//
//  CoreDataController.h
//  MuyingYongpin
//
//  Created by zhang kai on 10/2/12.
//
//

#import <Foundation/Foundation.h>

@interface CoreDataController : NSObject

+ (id)sharedInstance;

- (NSManagedObjectContext *)masterManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;
- (NSManagedObjectContext *)newManagedObjectContext;

- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;
@end
