#import "RTBrowseDevicesDataManager.h"
#import "RTAPIClient.h"

#import "RTClientList.h"
#import "RTLogging.h"

@implementation RTBrowseDevicesDataManager

- (void)retrievePage:(NSUInteger)page
            callback:(ArrayCallback)callback {

    ClientListCallback successCallback = ^(RTClientList *clientList) {
        callback(clientList.clients);
    };

    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        DDLogWarn(@"Failed to retrieve client list: %@", serverErrors);
        callback(@[]);
    };
 
    [self.client listClientsPage:page
                         success:successCallback
                         failure:failureCallback];
}

@end
