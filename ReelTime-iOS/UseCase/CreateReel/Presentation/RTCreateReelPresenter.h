#import <Foundation/Foundation.h>

#import "RTCreateReelInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTCreateReelView;
@class RTCreateReelInteractor;

@interface RTCreateReelPresenter : NSObject <RTCreateReelInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTCreateReelView>)view
                  interactor:(RTCreateReelInteractor *)interactor;

- (void)requestedReelCreationForName:(NSString *)name;

@end
