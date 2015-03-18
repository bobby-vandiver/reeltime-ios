#import <Foundation/Foundation.h>

#import "RTPagedListInteractorDelegate.h"

@protocol RTPagedListPresenterDelegate;
@class RTPagedListInteractor;

typedef void (^RefreshCompletedCallback)();

@interface RTPagedListPresenter : NSObject <RTPagedListInteractorDelegate>

- (instancetype)initWithDelegate:(id<RTPagedListPresenterDelegate>)delegate
                      interactor:(RTPagedListInteractor *)interactor;

- (void)requestedNextPage;

- (void)requestedRefreshWithCallback:(RefreshCompletedCallback)callback;

@end
