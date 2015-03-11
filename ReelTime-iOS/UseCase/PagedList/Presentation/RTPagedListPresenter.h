#import <Foundation/Foundation.h>

#import "RTPagedListInteractorDelegate.h"

@protocol RTPagedListPresenterDelegate;
@class RTPagedListInteractor;

@interface RTPagedListPresenter : NSObject <RTPagedListInteractorDelegate>

- (instancetype)initWithDelegate:(id<RTPagedListPresenterDelegate>)delegate
                      interactor:(RTPagedListInteractor *)interactor;

- (void)requestedNextPage;

- (void)requestedReset;

@end
