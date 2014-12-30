#import "RTRestAPIMappingFactory.h"
#import "RTOAuth2Token.h"

@implementation RTRestAPIMappingFactory

+ (RKObjectMapping *)tokenMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTOAuth2Token class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                       @"access_token":     @"accessToken",
                                                       @"refresh_token":    @"refreshToken",
                                                       @"token_type":       @"tokenType",
                                                       @"expires_in":       @"expiresIn",
                                                       @"scope":            @"scope"
                                                       }];
    return mapping;
}

@end
