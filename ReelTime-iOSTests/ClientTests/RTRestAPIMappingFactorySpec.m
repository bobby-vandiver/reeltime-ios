#import "RTTestCommon.h"
#import "RTRestAPIMappingFactory.h"

#import "RTOAuth2Token.h"
#import <RestKit/Testing.h>

SpecBegin(RTRestAPIMappingFactory)

describe(@"API Mapping", ^{
    
    it(@"token", ^{
        RKObjectMapping *mapping = [RTRestAPIMappingFactory tokenMapping];
        
        
        assert([mapping isKindOfClass:[RKObjectMapping class]]);
        
        NSDictionary *response = @{
                                   @"access_token": @"1d49fc35-2af6-477e-8fd4-ab0353a4a76f",
                                   @"token_type": @"bearer",
                                   @"refresh_token": @"4996ba33-be3f-4555-b3e3-0b094a4e60c0",
                                   @"expires_in": @"43199",
                                   @"scope": @"read"
                                   };
        
        RTOAuth2Token *token = [[RTOAuth2Token alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
                                                 destinationObject:token];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"access_token"
                                                                                destinationKeyPath:@"accessToken"
                                                                                             value:@"1d49fc35-2af6-477e-8fd4-ab0353a4a76f"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"token_type"
                                                                                destinationKeyPath:@"tokenType"
                                                                                             value:@"bearer"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"refresh_token"
                                                                                destinationKeyPath:@"refreshToken"
                                                                                             value:@"4996ba33-be3f-4555-b3e3-0b094a4e60c0"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"expires_in"
                                                                                destinationKeyPath:@"expiresIn"
                                                                                             value:@43199]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"scope"
                                                                                destinationKeyPath:@"scope"
                                                                                             value:@"read"]];

        [mappingTest performMapping];
        [mappingTest verify];
    });
    
});

SpecEnd