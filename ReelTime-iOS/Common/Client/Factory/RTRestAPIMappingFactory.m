#import "RTRestAPIMappingFactory.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"
#import "RTClientCredentials.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

#import "RTActivity.h"
#import "RTNewsfeed.h"

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

+ (RKMapping *)userMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTUser class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"username":          @"username",
                                                  @"display_name":      @"displayName",
                                                  @"follower_count":    @"numberOfFollowers",
                                                  @"followee_count":    @"numberOfFollowees"
                                                  }];
    return mapping;
}

+ (RKMapping *)reelMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTReel class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"reel_id":           @"reelId",
                                                  @"name":              @"name",
                                                  @"audience_size":     @"audienceSize",
                                                  @"video_count":       @"numberOfVideos"
                                                  }];
    return mapping;
}

+ (RKMapping *)videoMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTVideo class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"video_id":          @"videoId",
                                                  @"title":             @"title"
                                                  }];
    return mapping;
}

+ (RKMapping *)activityMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTActivity class]];
    return mapping;
}

+ (RKMapping *)newsfeedMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTNewsfeed class]];
    return mapping;
}

@end
