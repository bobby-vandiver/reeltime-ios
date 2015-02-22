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
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory serverErrorsMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_REGISTER_ACCOUNT
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)newsfeedDescriptor {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:200];
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory newsfeedMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_NEWSFEED
                                                       keyPath:nil
                                                   statusCodes:statusCodes];
}

@end
