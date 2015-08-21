#import "RTAuthenticationAwareHTTPClient.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTAuthorizationHeaderSupport.h"

#import <RestKit/RestKit.h>
#import "RKObjectManager+IncludeHeaders.h"

@interface RTAuthenticationAwareHTTPClient ()

@property RTAuthenticationAwareHTTPClientDelegate *delegate;
@property RKObjectManager *objectManager;

@property RTAuthorizationHeaderSupport *authorizationHeaderSupport;

@end

@implementation RTAuthenticationAwareHTTPClient

- (instancetype)initWithDelegate:(RTAuthenticationAwareHTTPClientDelegate *)delegate
            restKitObjectManager:(RKObjectManager *)objectManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.objectManager = objectManager;
        self.authorizationHeaderSupport = [[RTAuthorizationHeaderSupport alloc] init];
    }
    return self;
}

- (void)authenticatedGetBinaryForPath:(NSString *)path
                       withParameters:(NSDictionary *)parameters
                              success:(SuccessCallback)success
                              failure:(FailureCallback)failure {

    id successCallback = [self binarySuccessHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];

    NSDictionary *headers = [self authorizationHeader];
    [self.objectManager getObject:nil path:path parameters:parameters headers:headers success:successCallback failure:failureCallback];
}

- (void)authenticatedGetForPath:(NSString *)path
                 withParameters:(NSDictionary *)parameters
                        success:(SuccessCallback)success
                        failure:(FailureCallback)failure {
    NSDictionary *headers = [self authorizationHeader];
    [self getForPath:path withParameters:parameters headers:headers success:success failure:failure];
}

- (void)unauthenticatedGetForPath:(NSString *)path
                   withParameters:(NSDictionary *)parameters
                          success:(SuccessCallback)success
                          failure:(FailureCallback)failure {
    [self getForPath:path withParameters:parameters headers:nil success:success failure:failure];
}

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                   formDataBlock:(MultipartFormDataBlock)formDataBlock
                         success:(SuccessCallback)success
                         failure:(FailureCallback)failure {
    NSDictionary *headers = [self authorizationHeader];
    [self postForPath:path withParameters:parameters headers:headers formDataBlock:formDataBlock success:success failure:failure];
}

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                         success:(SuccessCallback)success
                         failure:(FailureCallback)failure {
    NSDictionary *headers = [self authorizationHeader];
    [self postForPath:path withParameters:parameters headers:headers formDataBlock:nil success:success failure:failure];
}

- (void)unauthenticatedPostForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(SuccessCallback)success
                           failure:(FailureCallback)failure {
    [self postForPath:path withParameters:parameters headers:nil formDataBlock:nil success:success failure:failure];
}

- (void)authenticatedDeleteForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(SuccessCallback)success
                           failure:(FailureCallback)failure {
    NSDictionary *headers = [self authorizationHeader];
    [self deleteForPath:path withParameters:parameters headers:headers success:success failure:failure];
}

- (void)getForPath:(NSString *)path
    withParameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
           success:(SuccessCallback)success
           failure:(FailureCallback)failure {
    
    id successCallback = [self successHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    if (headers) {
        [self.objectManager getObject:nil
                                 path:path
                           parameters:parameters
                              headers:headers
                              success:successCallback
                              failure:failureCallback];
    }
    else {
        [self.objectManager getObject:nil
                                 path:path
                           parameters:parameters
                              success:successCallback
                              failure:failureCallback];
    }
}

- (void)postForPath:(NSString *)path
     withParameters:(NSDictionary *)parameters
            headers:(NSDictionary *)headers
      formDataBlock:(MultipartFormDataBlock)formDataBlock
            success:(SuccessCallback)success
            failure:(FailureCallback)failure {
    
    id successCallback = [self successHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    if (headers && formDataBlock) {
        [self.objectManager postObject:nil
                                  path:path
                            parameters:parameters
                               headers:headers
                         formDataBlock:formDataBlock
                               success:successCallback
                               failure:failureCallback];
    }
    else if (headers) {
        [self.objectManager postObject:nil
                                  path:path
                            parameters:parameters
                               headers:headers
                               success:successCallback
                               failure:failureCallback];
    }
    else {
        [self.objectManager postObject:nil
                                  path:path
                            parameters:parameters
                               success:successCallback
                               failure:failureCallback];
    }
}

- (void)deleteForPath:(NSString *)path
       withParameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
              success:(SuccessCallback)success
              failure:(FailureCallback)failure {
    
    id successCallback = [self successHandlerWithCallback:success];
    id failureCallback = [self serverFailureHandlerWithCallback:failure];
    
    if (headers) {
        [self.objectManager deleteObject:nil
                                    path:path
                              parameters:parameters
                                 headers:headers
                                 success:successCallback
                                 failure:failureCallback];
    }
    else {
        [self.objectManager deleteObject:nil
                                    path:path
                              parameters:parameters
                                 success:successCallback
                                 failure:failureCallback];
    }
}

- (NSDictionary *)authorizationHeader {
    NSString *accessToken = [self.delegate accessTokenForCurrentUser];
    NSString *bearerTokenHeader = [self.authorizationHeaderSupport bearerTokenHeaderFromAccessToken:accessToken];
    return @{RTAuthorizationHeader:bearerTokenHeader};
}

- (void (^)(RKObjectRequestOperation *, RKMappingResult *))binarySuccessHandlerWithCallback:(void (^)(id))callback {
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        callback(operation.HTTPRequestOperation.responseData);
    };
}

- (void (^)(RKObjectRequestOperation *, RKMappingResult *))successHandlerWithCallback:(void (^)(id))callback {
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        id result = [mappingResult firstObject];
        callback(result);
    };
}

- (void (^)(RKObjectRequestOperation *, NSError *))serverFailureHandlerWithCallback:(void (^)(id))callback {
    return ^(RKObjectRequestOperation *operation, NSError *error) {
        id errors = [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        callback(errors);
    };
}

@end
