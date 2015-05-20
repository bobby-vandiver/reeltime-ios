#import <Foundation/Foundation.h>

@protocol RTChangePasswordDataManagerDelegate;
@class RTClient;

@interface RTChangePasswordDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTChangePasswordDataManagerDelegate>)delegate
                          client:(RTClient *)client;

- (void)changePassword:(NSString *)password
              callback:(void (^)())callback;

@end
