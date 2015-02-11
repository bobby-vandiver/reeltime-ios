#import "RTTestCommon.h"

#import "RTUser.h"

SpecBegin(RTUser)

describe(@"user", ^{
    
    __block RTUser *user;
    
    NSNumber *numberOfFollowers = @(3);
    NSNumber *numberOfFollowees = @(4);

    beforeEach(^{
        user = [[RTUser alloc] initWithUsername:username
                                    displayName:displayName
                              numberOfFollowers:numberOfFollowers
                              numberOfFollowees:numberOfFollowees];
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
                                               numberOfFollowees:[numberOfFollowees copy]];
                
                BOOL equal = [user isEqual:other];
                expect(equal).to.beTruthy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).to.equal(userHash);
            });
        });
        
        describe(@"users are not equal", ^{
            void (^expectNotEqual)(NSString *, NSString *, NSNumber *, NSNumber *) = ^(NSString *otherUsername,
                                                                                       NSString *otherDisplayName,
                                                                                       NSNumber *otherNumberOfFollowers,
                                                                                       NSNumber *otherNumberOfFollowees) {
                RTUser *other = [[RTUser alloc] initWithUsername:otherUsername
                                                     displayName:otherDisplayName
                                               numberOfFollowers:otherNumberOfFollowers
                                               numberOfFollowees:otherNumberOfFollowees];
                
                BOOL equal = [user isEqual:other];
                expect(equal).to.beFalsy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).toNot.equal(userHash);
            };
            
            it(@"different property values", ^{
                expectNotEqual([NSString stringWithFormat:@"%@a", username], [displayName copy],
                               [numberOfFollowers copy], [numberOfFollowees copy]);
                
                expectNotEqual(username, [NSString stringWithFormat:@"%@a", displayName],
                               [numberOfFollowers copy], [numberOfFollowees copy]);
                
                expectNotEqual(username, displayName,
                               @([numberOfFollowers intValue] + 1), [numberOfFollowees copy]);
                
                expectNotEqual(username, displayName,
                               [numberOfFollowers copy], @([numberOfFollowees intValue] + 1));
            });
            
            it(@"nil property values", ^{
                expectNotEqual(nil, [displayName copy],
                               [numberOfFollowers copy], [numberOfFollowees copy]);
                
                expectNotEqual([username copy], nil,
                               [numberOfFollowers copy], [numberOfFollowees copy]);
                
                expectNotEqual([username copy], [displayName copy],
                               nil, [numberOfFollowees copy]);
                
                expectNotEqual([username copy], [displayName copy],
                               [numberOfFollowers copy], nil);
            });
            
            it(@"both have nil properties", ^{
                RTUser *left = [[RTUser alloc] initWithUsername:nil
                                                    displayName:nil
                                              numberOfFollowers:nil
                                              numberOfFollowees:nil];
                
                RTUser *right = [[RTUser alloc] initWithUsername:nil
                                                     displayName:nil
                                               numberOfFollowers:nil
                                               numberOfFollowees:nil];
                
                BOOL equal = [left isEqual:right];
                expect(equal).to.beFalsy();
            });
        });
    });
});

SpecEnd