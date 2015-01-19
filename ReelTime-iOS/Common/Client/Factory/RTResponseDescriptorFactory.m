#import "RTResponseDescriptorFactory.h"
#import "RTRestAPIMappingFactory.h"
#import "RTRestAPI.h"

@implementation RTResponseDescriptorFactory

+ (RKResponseDescriptor *)tokenDescriptor {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory tokenMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_TOKEN_ENDPOINT
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)tokenErrorDescriptor {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory tokenErrorMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_TOKEN_ENDPOINT
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)accountRegistrationDescriptor {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:201];

    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory accountRegistrationMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_ACCOUNT_REGISTRATION_ENDPOINT
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

@end
