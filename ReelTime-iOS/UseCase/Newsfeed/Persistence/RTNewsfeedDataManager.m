#import "RTNewsfeedDataManager.h"
#import "RTClient.h"
#import "RTNewsfeed.h"
#import "RTServerErrors.h"
#import "RTLogging.h"

@implementation RTNewsfeedDataManager

- (void)retrievePage:(NSUInteger)page
            callback:(ArrayCallback)callback {
    
    NewsfeedCallback successCallback = ^(RTNewsfeed *newsfeed) {
        callback(newsfeed.activities);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *errors) {
        DDLogWarn(@"Failed to retrieve newsfeed activities: %@", errors);
        callback(@[]);
    };
    
    [self.client newsfeedPage:page
                      success:successCallback
                      failure:failureCallback];
}

@end
