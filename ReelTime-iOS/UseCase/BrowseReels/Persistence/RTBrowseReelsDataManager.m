#import "RTBrowseReelsDataManager.h"
#import "RTBrowseReelsDataManagerDelegate.h"
#import "RTAPIClient.h"

#import "RTReelList.h"
#import "RTLogging.h"

@interface RTBrowseReelsDataManager ()

@property id<RTBrowseReelsDataManagerDelegate> delegate;

@end

@implementation RTBrowseReelsDataManager

- (instancetype)initWithDelegate:(id<RTBrowseReelsDataManagerDelegate>)delegate
                          client:(RTAPIClient *)client {
    self = [super initWithClient:client];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)retrievePage:(NSUInteger)page
            callback:(ArrayCallback)callback {
    
    ReelListCallback successCallback = ^(RTReelList *reelList) {
        callback(reelList.reels);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        DDLogWarn(@"Failed to retrieve reel list: %@", serverErrors);
        callback(@[]);
    };
    
    [self.delegate listReelsPage:page
                      withClient:self.client
                         success:successCallback
                         failure:failureCallback];
}

@end
