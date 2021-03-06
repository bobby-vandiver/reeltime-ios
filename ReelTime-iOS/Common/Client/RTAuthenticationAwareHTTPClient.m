#import "RTAuthenticationAwareHTTPClient.h"

#import "RTCurrentUserService.h"
#import "RTOAuth2TokenRenegotiator.h"

#import "RTAuthorizationHeaderSupport.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTLogging.h"

#import <RestKit/RestKit.h>
#import "RKObjectManager+IncludeHeaders.h"

@interface RTAuthenticationAwareHTTPClient ()

@property RTCurrentUserService *currentUserService;
@property RTOAuth2TokenRenegotiator *tokenRenegotiator;

@property RKObjectManager *objectManager;
@property RTAuthorizationHeaderSupport *authorizationHeaderSupport;

@end

@implementation RTAuthenticationAwareHTTPClient

- (instancetype)initWithCurrentUserService:(RTCurrentUserService *)currentUserService
                         tokenRenegotiator:(RTOAuth2TokenRenegotiator *)tokenRenegotiator
                authorizationHeaderSupport:(RTAuthorizationHeaderSupport *)authorizationHeaderSupport
                             objectManager:(RKObjectManager *)objectManager {
    self = [super init];
    if (self) {
        self.currentUserService = currentUserService;
        self.tokenRenegotiator = tokenRenegotiator;
        self.authorizationHeaderSupport = authorizationHeaderSupport;
        self.objectManager = objectManager;
    }
    return self;
}

- (void)authenticatedGetBinaryForPath:(NSString *)path
                       withParameters:(NSDictionary *)parameters
                              success:(SuccessCallback)success
                              failure:(FailureCallback)failure {
    
    RKHTTPOperation operation = ^(RKSuccessCallback successCallback, RKFailureCallback failureCallback) {
        NSDictionary *headers = [self authorizationHeader];

        RKSuccessCallback binarySuccessCallback = [self binarySuccessHandlerWithCallback:success];
        [self getForPath:path withParameters:parameters headers:headers successCallback:binarySuccessCallback failureCallback:failureCallback];
    };
    
    [self performOperation:operation authenticated:YES success:success failure:failure];
}

- (void)authenticatedGetForPath:(NSString *)path
                 withParameters:(NSDictionary *)parameters
                        success:(SuccessCallback)success
                        failure:(FailureCallback)failure {
    
    RKHTTPOperation operation = ^(RKSuccessCallback successCallback, RKFailureCallback failureCallback) {
        NSDictionary *headers = [self authorizationHeader];
        [self getForPath:path withParameters:parameters headers:headers successCallback:successCallback failureCallback:failureCallback];
    };
    
    [self performOperation:operation authenticated:YES success:success failure:failure];
}

- (void)unauthenticatedGetForPath:(NSString *)path
                   withParameters:(NSDictionary *)parameters
                          success:(SuccessCallback)success
                          failure:(FailureCallback)failure {
    
    RKHTTPOperation operation = ^(RKSuccessCallback successCallback, RKFailureCallback failureCallback) {
        [self getForPath:path withParameters:parameters headers:nil successCallback:successCallback failureCallback:failureCallback];
    };
    
    [self performOperation:operation authenticated:NO success:success failure:failure];
}

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                   formDataBlock:(MultipartFormDataBlock)formDataBlock
                         success:(SuccessCallback)success
                         failure:(FailureCallback)failure {
    
    RKHTTPOperation operation = ^(RKSuccessCallback successCallback, RKFailureCallback failureCallback) {
        NSDictionary *headers = [self authorizationHeader];
        [self postForPath:path withParameters:parameters headers:headers formDataBlock:formDataBlock successCallback:successCallback failureCallback:failureCallback];
    };
    
    [self performOperation:operation authenticated:YES success:success failure:failure];
}

- (void)authenticatedPostForPath:(NSString *)path
                  withParameters:(NSDictionary *)parameters
                         success:(SuccessCallback)success
                         failure:(FailureCallback)failure {
    
    RKHTTPOperation operation = ^(RKSuccessCallback successCallback, RKFailureCallback failureCallback) {
        NSDictionary *headers = [self authorizationHeader];
        [self postForPath:path withParameters:parameters headers:headers formDataBlock:nil successCallback:successCallback failureCallback:failureCallback];
    };
    
    [self performOperation:operation authenticated:YES success:success failure:failure];
}

- (void)unauthenticatedPostForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(SuccessCallback)success
                           failure:(FailureCallback)failure {
    
    RKHTTPOperation operation = ^(RKSuccessCallback successCallback, RKFailureCallback failureCallback) {
        [self postForPath:path withParameters:parameters headers:nil formDataBlock:nil successCallback:successCallback failureCallback:failureCallback];
    };
    
    [self performOperation:operation authenticated:NO success:success failure:failure];
}

- (void)authenticatedDeleteForPath:(NSString *)path
                    withParameters:(NSDictionary *)parameters
                           success:(SuccessCallback)success
                           failure:(FailureCallback)failure {
    
    RKHTTPOperation operation = ^(RKSuccessCallback successCallback, RKFailureCallback failureCallback) {
        NSDictionary *headers = [self authorizationHeader];
        [self deleteForPath:path withParameters:parameters headers:headers successCallback:successCallback failureCallback:failureCallback];
    };
    
    [self performOperation:operation authenticated:YES success:success failure:failure];
}

- (void)getForPath:(NSString *)path
    withParameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
   successCallback:(RKSuccessCallback)successCallback
   failureCallback:(RKFailureCallback)failureCallback {
  
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
    successCallback:(RKSuccessCallback)successCallback
    failureCallback:(RKFailureCallback)failureCallback {

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
      successCallback:(RKSuccessCallback)successCallback
      failureCallback:(RKFailureCallback)failureCallback {
    
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
    RTOAuth2Token *token = [self.currentUserService tokenForCurrentUser];
    NSString *bearerTokenHeader = [self.authorizationHeaderSupport bearerTokenHeaderFromAccessToken:token.accessToken];
    return @{RTAuthorizationHeader:bearerTokenHeader};
}

- (void)performOperation:(RKHTTPOperation)operation
           authenticated:(BOOL)authenticated
                 success:(SuccessCallback)success
                 failure:(FailureCallback)failure {
    
    __block __weak NoArgsCallback weakRetryableOperation;
    
    NoArgsCallback retryableOperation = ^{
        RKSuccessCallback successCallback = [self successHandlerWithCallback:success];

        RKFailureCallback failureCallback = [self serverFailureHandlerWithCallback:failure
                                                             forRetryableOperation:weakRetryableOperation
                                                                     authenticated:authenticated];
        
        operation(successCallback, failureCallback);
    };
    
    weakRetryableOperation = retryableOperation;
    retryableOperation();
}

- (RKSuccessCallback)binarySuccessHandlerWithCallback:(ArgsCallback)callback {
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        callback(operation.HTTPRequestOperation.responseData);
    };
}

- (RKSuccessCallback)successHandlerWithCallback:(ArgsCallback)callback {
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        id result = [mappingResult firstObject];
        callback(result);
    };
}

- (RKFailureCallback)serverFailureHandlerWithCallback:(ArgsCallback)callback
                                forRetryableOperation:(NoArgsCallback)retryableOperation
                                        authenticated:(BOOL)authenticated {
    
    return ^(RKObjectRequestOperation *operation, NSError *error) {
        id errors = [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        
        if (authenticated && [errors isKindOfClass:[RTOAuth2TokenError class]]) {
            RTOAuth2TokenError *tokenError = (RTOAuth2TokenError *)errors;

            DDLogDebug(@"Renegotiating token due to token error: %@", tokenError);
            [self.tokenRenegotiator renegotiateTokenWithCallback:retryableOperation];
        }
        else {
            callback(errors);
        }
    };
}

@end
