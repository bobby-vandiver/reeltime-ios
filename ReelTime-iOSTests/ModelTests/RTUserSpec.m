#import "RTTestCommon.h"

#import "RTUser.h"

SpecBegin(RTUser)

describe(@"user", ^{
    
    __block RTUser *user;
    
    NSNumber *numberOfFollowers = @(3);
    NSNumber *numberOfFollowees = @(4);
    
    NSNumber *numberOfReelsOwned = @(5);
    NSNumber *numberOfAudienceMemberships = @(6);
    
    beforeEach(^{
        user = [[RTUser alloc] initWithUsername:username
                                    displayName:displayName
                              numberOfFollowers:numberOfFollowers
                              numberOfFollowees:numberOfFollowees
                             numberOfReelsOwned:numberOfReelsOwned
                    numberOfAudienceMemberships:numberOfAudienceMemberships];
    });
    
    describe(@"isEqual for user with non-user", ^{
        it(@"nil", ^{
            BOOL equal = [user isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-user", ^{
            BOOL equal = [user isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });
    
    describe(@"isEqual and hash for users", ^{
        __block NSUInteger userHash;
        
        beforeEach(^{
            userHash = [user hash];
        });
        
        describe(@"users are equal", ^{
            it(@"same instance", ^{
                BOOL equal = [user isEqual:user];
                expect(equal).to.beTruthy();
            });
            
            it(@"different instances, same property values", ^{
                RTUser *other = [[RTUser alloc] initWithUsername:[username copy]
                                                     displayName:[displayName copy]
                                               numberOfFollowers:[numberOfFollowers copy]
                                               numberOfFollowees:[numberOfFollowees copy]
                                              numberOfReelsOwned:[numberOfReelsOwned copy]
                                     numberOfAudienceMemberships:[numberOfAudienceMemberships copy]];
                
                BOOL equal = [user isEqual:other];
                expect(equal).to.beTruthy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).to.equal(userHash);
            });
        });
        
        describe(@"users are not equal", ^{
            void (^expectNotEqual)(NSString *, NSString *, NSNumber *, NSNumber *, NSNumber *, NSNumber *) = ^(NSString *otherUsername,
                                                                                       NSString *otherDisplayName,
                                                                                       NSNumber *otherNumberOfFollowers,
                                                                                       NSNumber *otherNumberOfFollowees,
                                                                                                               NSNumber *otherNumberOfReelsOwned,
                                                                                                               NSNumber *otherNumberOfAudienceMemberships) {
                RTUser *other = [[RTUser alloc] initWithUsername:otherUsername
                                                     displayName:otherDisplayName
                                               numberOfFollowers:otherNumberOfFollowers
                                               numberOfFollowees:otherNumberOfFollowees
                                              numberOfReelsOwned:otherNumberOfReelsOwned
                                     numberOfAudienceMemberships:otherNumberOfAudienceMemberships];
                
                BOOL equal = [user isEqual:other];
                expect(equal).to.beFalsy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).toNot.equal(userHash);
            };
            
            it(@"different username", ^{
                expectNotEqual([NSString stringWithFormat:@"%@a", username], [displayName copy],
                               [numberOfFollowers copy], [numberOfFollowees copy],
                               [numberOfReelsOwned copy], [numberOfAudienceMemberships copy]);
            });
            
            it(@"nil username", ^{
                expectNotEqual(nil, [displayName copy],
                               [numberOfFollowers copy], [numberOfFollowees copy],
                               [numberOfReelsOwned copy], [numberOfAudienceMemberships copy]);
            });
            
            it(@"both have nil username", ^{
                RTUser *left = [[RTUser alloc] initWithUsername:nil
                                                    displayName:displayName
                                              numberOfFollowers:numberOfFollowers
                                              numberOfFollowees:numberOfFollowees
                                             numberOfReelsOwned:numberOfReelsOwned
                                    numberOfAudienceMemberships:numberOfAudienceMemberships];
                
                RTUser *right = [[RTUser alloc] initWithUsername:nil
                                                     displayName:[displayName copy]
                                               numberOfFollowers:[numberOfFollowers copy]
                                               numberOfFollowees:[numberOfFollowees copy]
                                              numberOfReelsOwned:[numberOfReelsOwned copy]
                                     numberOfAudienceMemberships:[numberOfAudienceMemberships copy]];
                
                BOOL equal = [left isEqual:right];
                expect(equal).to.beFalsy();
            });
        });
    });
});

SpecEnd