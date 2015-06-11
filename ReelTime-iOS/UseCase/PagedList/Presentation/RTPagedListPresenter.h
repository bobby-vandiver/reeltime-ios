#import <Foundation/Foundation.h>

#import "RTPagedListInteractorDelegate.h"

@protocol RTPagedListPresenterDelegate;
@class RTPagedListInteractor;

typedef void (^RefreshCompletedCallback)();

@interface RTPagedListPresenter : NSObject <RTPagedListInteractorDelegate>

// TODO: If the need to expose more access to the underlying item storage
// increases in the future, then refactor this logic to its own class.
@property NSMutableArray *items;

- (instancetype)initWithDelegate:(id<RTPagedListPresenterDelegate>)delegate
                      interactor:(RTPagedListInteractor *)interactor;

- (void)requestedNextPage;

- (void)requestedRefreshWithCallback:(RefreshCompletedCallback)callback;

@end
