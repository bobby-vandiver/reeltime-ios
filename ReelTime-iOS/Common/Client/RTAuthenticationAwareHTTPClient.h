#import <Foundation/Foundation.h>

@class RTClientDelegate;
@class RKObjectManager;
@class RTServerErrors;

@interface RTAuthenticationAwareHTTPClient : NSObject

- (instancetype)initWithDelegate:(RTClientDelegate *)delegate
            restKitObjectManager:(RKObjectManager *)objectManager;
- (void)authenticatedGetForPath:(NSString *)path
                 withParameters:(NSDictionary *)parameters
                        success:(void (^)(id result))success
                        failure:(void (^)(id error))failure;

- (void)unauthenticatedGetForPath:(NSString *)path
                   withParameters:(NSDictionary *)parameters
                          success:(void (^)(id result))success
                          failure:(void (^)(id error))failure;

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                         success:(void (^)(id result))success
                         failure:(void (^)(id error))failure;

- (void)unauthenticatedPostForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(void (^)(id result))success
                           failure:(void (^)(id error))failure;

- (void)authenticatedDeleteForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(void (^)(id result))success
                           failure:(void (^)(id error))failure;

@end
