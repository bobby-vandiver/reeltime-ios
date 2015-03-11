#import <Foundation/Foundation.h>

@protocol RTPagedListInteractorDelegate <NSObject>

- (void)retrievedItems:(NSArray *)items;

- (void)failedToRetrieveItemsWithError:(NSError *)error;

@end
