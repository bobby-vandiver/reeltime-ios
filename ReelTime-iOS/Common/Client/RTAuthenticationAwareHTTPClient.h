#import <Foundation/Foundation.h>

@class RTAuthenticationAwareHTTPClientDelegate;
@class RKObjectManager;
@class RTServerErrors;
@protocol AFMultipartFormData;

typedef void (^SuccessCallback)(id result);
typedef void (^FailureCallback)(id error);

typedef void (^MultipartFormDataBlock)(id<AFMultipartFormData> formData);

@interface RTAuthenticationAwareHTTPClient : NSObject

- (instancetype)initWithDelegate:(RTAuthenticationAwareHTTPClientDelegate *)delegate
            restKitObjectManager:(RKObjectManager *)objectManager;

- (void)authentciatedGetBinaryForPath:(NSString *)path
                       withParameters:(NSDictionary *)parameters
                              success:(SuccessCallback)success
                              failure:(FailureCallback)failure;

- (void)authenticatedGetForPath:(NSString *)path
                 withParameters:(NSDictionary *)parameters
                        success:(SuccessCallback)success
                        failure:(FailureCallback)failure;

- (void)unauthenticatedGetForPath:(NSString *)path
                   withParameters:(NSDictionary *)parameters
                          success:(SuccessCallback)success
                          failure:(FailureCallback)failure;

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                   formDataBlock:(MultipartFormDataBlock)formDataBlock
                         success:(SuccessCallback)success
                         failure:(FailureCallback)failure;

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                         success:(SuccessCallback)success
                         failure:(FailureCallback)failure;

- (void)unauthenticatedPostForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(SuccessCallback)success
                           failure:(FailureCallback)failure;

- (void)authenticatedDeleteForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(SuccessCallback)success
                           failure:(FailureCallback)failure;

@end
