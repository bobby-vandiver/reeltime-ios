#import <Foundation/Foundation.h>

@protocol RTPagedListInteractorDelegate <NSObject>

- (void)retrievedListPage:(id)listPage;

- (void)failedToRetrieveListPageWithError:(NSError *)error;

@end
