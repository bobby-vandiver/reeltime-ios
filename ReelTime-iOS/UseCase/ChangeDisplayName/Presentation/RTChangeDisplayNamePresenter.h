#import <Foundation/Foundation.h>
#import "RTChangeDisplayNameInteractorDelegate.h"

@protocol RTChangeDisplayNameView;
@class RTChangeDisplayNameInteractor;

@interface RTChangeDisplayNamePresenter : NSObject <RTChangeDisplayNameInteractorDelegate>

- (instancetype)initWithView:(id<RTChangeDisplayNameView>)view
                  interactor:(RTChangeDisplayNameInteractor *)interactor;

- (void)requestedDisplayNameChangeWithDisplayName:(NSString *)displayName;

@end
