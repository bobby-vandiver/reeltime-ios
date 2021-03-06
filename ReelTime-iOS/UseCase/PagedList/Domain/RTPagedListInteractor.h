#import <Foundation/Foundation.h>

@protocol RTPagedListInteractorDelegate;
@class RTPagedListDataManager;

@interface RTPagedListInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTPagedListInteractorDelegate>)delegate
                     dataManager:(RTPagedListDataManager *)dataManager;

- (void)listItemsForPage:(NSUInteger)page;

@end
