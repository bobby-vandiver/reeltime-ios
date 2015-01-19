#import "RTRestAPIMappingFactory.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"
#import "RTClientCredentials.h"

@implementation RTRestAPIMappingFactory

+ (RKMapping *)tokenMapping {
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

+ (RKMapping *)tokenErrorMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTOAuth2TokenError class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"error":             @"errorCode",
                                                  @"error_description": @"errorDescription"
                                                  }];
    return mapping;
}

+ (RKMapping *)serverErrorsMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTServerErrors class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"errors":            @"errors"
                                                  }];
    return mapping;
}

+ (RKMapping *)accountRegistrationMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTClientCredentials class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"client_id":         @"clientId",
                                                  @"client_secret":     @"clientSecret"
                                                  }];
    return mapping;
}

@end
