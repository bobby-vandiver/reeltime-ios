#import "RTResponseDescriptorFactory.h"
#import "RTRestAPIMappingFactory.h"
#import "RTRestAPI.h"

@implementation RTResponseDescriptorFactory

+ (RKResponseDescriptor *)tokenDescriptor {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory tokenMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_TOKEN
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)tokenErrorDescriptor {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory tokenErrorMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_TOKEN
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)accountRegistrationDescriptor {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:201];

    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory clientCredentialsMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_REGISTER_ACCOUNT
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)accountRegistrationErrorDescriptor {
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndex:400];
    [statusCodes addIndex:503];
    
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_REGISTER_ACCOUNT
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)accountRemovalDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_ACCOUNT
                                        statusCode:200];
}

+ (RKResponseDescriptor *)clientRegistrationDescriptor {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:201];

    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory clientCredentialsMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_REGISTER_CLIENT
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)clientRegistrationErrorDescriptor {
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    [statusCodes addIndex:400];
    [statusCodes addIndex:503];
    
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_REGISTER_CLIENT
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)clientRemovalDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_CLIENT
                                        statusCode:200];
}

+ (RKResponseDescriptor *)accountConfirmationDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CONFIRM_ACCOUNT
                                        statusCode:200];
}

+ (RKResponseDescriptor *)accountConfirmationErrorDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CONFIRM_ACCOUNT
                                        statusCode:403];
}

+ (RKResponseDescriptor *)accountConfirmationSendEmailDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CONFIRM_ACCOUNT_SEND_EMAIL
                                        statusCode:200];
}

+ (RKResponseDescriptor *)accountConfirmationSendEmailErrorDescriptor {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:503];
    
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_CONFIRM_ACCOUNT_SEND_EMAIL
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)changeDisplayNameDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CHANGE_DISPLAY_NAME
                                        statusCode:200];
}

+ (RKResponseDescriptor *)changeDisplayNameErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_CHANGE_DISPLAY_NAME
                                      statusCode:400];
}

+ (RKResponseDescriptor *)changePasswordDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CHANGE_PASSWORD
                                        statusCode:200];
}

+ (RKResponseDescriptor *)changePasswordErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_CHANGE_PASSWORD
                                      statusCode:400];
}

+ (RKResponseDescriptor *)newsfeedDescriptor {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:200];
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory newsfeedMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_NEWSFEED
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)joinAudienceDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_ADD_AUDIENCE_MEMBER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)followUserDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_FOLLOW_USER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)serverErrorsDescriptorForMethod:(RKRequestMethod)method
                                                     path:(NSString *)path
                                               statusCode:(NSUInteger)statusCode {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:statusCode];
    return [self serverErrorsDescriptorForMethod:method
                                            path:path
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)serverErrorsDescriptorForMethod:(RKRequestMethod)method
                                                     path:(NSString *)path
                                              statusCodes:(NSIndexSet *)statusCodes {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory serverErrorsMapping]
                                                        method:method
                                                   pathPattern:path
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)noResponseBodyDescriptorForMethod:(RKRequestMethod)method
                                                       path:(NSString *)path
                                                 statusCode:(NSUInteger)statusCode {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:statusCode];
    return [self noResponseBodyDescriptorForMethod:method
                                              path:path
                                       statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)noResponseBodyDescriptorForMethod:(RKRequestMethod)method
                                                       path:(NSString *)path
                                                statusCodes:(NSIndexSet *)statusCodes {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory emptyMapping]
                                                        method:method
                                                   pathPattern:path
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

@end
