#import "RTRestAPIMappingFactory.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"
#import "RTClientCredentials.h"

#import "RTUser.h"
#import "RTUserList.h"

#import "RTReel.h"
#import "RTReelList.h"

#import "RTVideo.h"
#import "RTVideoList.h"

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

+ (RKMapping *)clientCredentialsMapping {
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

+ (RKMapping *)userListMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTUserList class]];
    RKRelationshipMapping *userMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:nil
                                                                                     toKeyPath:@"users"
                                                                                   withMapping:[self userMapping]];
    [mapping addPropertyMapping:userMapping];
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

+ (RKMapping *)reelListMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTReelList class]];
    RKRelationshipMapping *reelMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:nil
                                                                                     toKeyPath:@"reels"
                                                                                   withMapping:[self reelMapping]];
    [mapping addPropertyMapping:reelMapping];
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
    RKDynamicMapping *dynamicMapping = [[RKDynamicMapping alloc] init];
    
    [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        RKAttributeMapping *typeMapping = [RKAttributeMapping attributeMappingFromKeyPath:@"type" toKeyPath:@"type"];
        typeMapping.valueTransformer = [self activityTypeTransformer];
        
        RKRelationshipMapping *userMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                         toKeyPath:@"user"
                                                                                       withMapping:[self userMapping]];
        
        RKRelationshipMapping *reelMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"reel"
                                                                                         toKeyPath:@"reel"
                                                                                       withMapping:[self reelMapping]];

        NSMutableArray *propertyMappings = [[NSMutableArray alloc] init];
        [propertyMappings addObjectsFromArray:@[typeMapping, userMapping, reelMapping]];
        
        if ([representation objectForKey:@"video"]) {
            RKRelationshipMapping *videoMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"video"
                                                                                              toKeyPath:@"video"
                                                                                            withMapping:[self videoMapping]];
            [propertyMappings addObject:videoMapping];
        }

        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTActivity class]];
        [mapping addPropertyMappingsFromArray:propertyMappings];
        return mapping;
    }];
    
    return dynamicMapping;
}

+ (RKValueTransformer *)activityTypeTransformer {
    id validation = ^BOOL(__unsafe_unretained Class sourceClass, __unsafe_unretained Class destinationClass) {
        return [sourceClass isSubclassOfClass:[NSString class]] && [destinationClass isSubclassOfClass:[NSNumber class]];
    };
    
    id transformation = ^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputValueClass,
                              NSError *__autoreleasing *error) {
        RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
        RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputValueClass, [NSNumber class], error);

        NSDictionary *typeLookupTable = @{
                                          @"create-reel":           @(RTActivityTypeCreateReel),
                                          @"join-reel-audience":    @(RTActivityTypeJoinReelAudience),
                                          @"add-video-to-reel":     @(RTActivityTypeAddVideoToReel)
                                          };
        
        *outputValue = [typeLookupTable objectForKey:(NSString *)inputValue];
        return *outputValue != nil;
    };
    
    return [RKBlockValueTransformer valueTransformerWithValidationBlock:validation
                                                    transformationBlock:transformation];
}

+ (RKMapping *)newsfeedMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RTNewsfeed class]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"activities" mapping:[self activityMapping]];
    return mapping;
}

+ (RKMapping *)emptyMapping {
    return[RKObjectMapping mappingForClass:[NSNull class]];
}

@end
