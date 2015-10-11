#import <Foundation/Foundation.h>

@class RTCurrentUserService;
@class RTOAuth2TokenRenegotiator;
@class RTAuthorizationHeaderSupport;

@class RKObjectManager;
@protocol AFMultipartFormData;

typedef void (^SuccessCallback)(id result);
typedef void (^FailureCallback)(id error);

typedef void (^MultipartFormDataBlock)(id<AFMultipartFormData> formData);

@interface RTAuthenticationAwareHTTPClient : NSObject

- (instancetype)initWithCurrentUserService:(RTCurrentUserService *)currentUserService
                         tokenRenegotiator:(RTOAuth2TokenRenegotiator *)tokenRenegotiator
                authorizationHeaderSupport:(RTAuthorizationHeaderSupport *)authorizationHeaderSupport
                             objectManager:(RKObjectManager *)objectManager;

- (void)authenticatedGetBinaryForPath:(NSString *)path
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
