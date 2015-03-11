#import <Foundation/Foundation.h>

#import "RTPagedListInteractorDelegate.h"

@class RTPagedListInteractor;

@interface RTPagedListPresenter : NSObject <RTPagedListInteractorDelegate>

- (instancetype)initWithInteractor:(RTPagedListInteractor *)interactor;

- (void)requestedNextPage;

- (void)requestedReset;

- (void)clearPresentedItems;

- (void)presentItem:(id)item;

@end
