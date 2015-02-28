#import "RKResponseDescriptor+SingleStatusCode.h"

@implementation RKResponseDescriptor (SingleStatusCode)

+ (RKResponseDescriptor *)responseDescriptorWithMapping:(RKMapping *)mapping
                                                 method:(RKRequestMethod)method
                                            pathPattern:(NSString *)pathPattern
                                            statusCodes:(NSIndexSet *)statusCodes {
    
    return [self responseDescriptorWithMapping:mapping
                                        method:method
                                   pathPattern:pathPattern
                                       keyPath:nil
                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)responseDescriptorWithMapping:(RKMapping *)mapping
                                                 method:(RKRequestMethod)method
                                            pathPattern:(NSString *)pathPattern
                                             statusCode:(NSUInteger)statusCode {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:statusCode];

    return [self responseDescriptorWithMapping:mapping
                                        method:method
                                   pathPattern:pathPattern
                                   statusCodes:statusCodes];
}

@end