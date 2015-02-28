#import "RTNewsfeedDataManager.h"

#import "RTClient.h"

#import "RTNewsfeed.h"
#import "RTServerErrors.h"

@interface RTNewsfeedDataManager ()

@property RTClient *client;

@end

@implementation RTNewsfeedDataManager

- (instancetype)initWithClient:(RTClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}

- (void)retrieveNewsfeedPage:(NSUInteger)page
                    callback:(void (^)(RTNewsfeed *))callback {

    id successCallback = ^(RTNewsfeed *newsfeed) {
        callback(newsfeed);
    };
    
    id failureCallback = ^{
        // TODO: Log errors
        RTNewsfeed *newsfeed = [[RTNewsfeed alloc] init];
        newsfeed.activities = [NSArray array];

        callback(newsfeed);
    };
    
    [self.client newsfeedPage:page
                      success:successCallback
                      failure:failureCallback];
}

@end
