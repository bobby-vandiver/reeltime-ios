#import "RTTestCommon.h"

#import "RTUserDescription.h"

SpecBegin(RTUserDescription)

describe(@"user description", ^{
    
    __block RTUserDescription *userDescription;
    
    RTUserDescription * (^createUserDescription)(NSString *) = ^(NSString *username) {
        return [RTUserDescription userDescriptionWithForUsername:username
                                                 withDisplayName:anything()
                                               numberOfFollowers:anything()
                                               numberOfFollowees:anything()
                                              numberOfReelsOwned:anything()
                                     numberOfAudienceMemberships:anything()
                                          currentUserIsFollowing:anything()];
    };
    
    beforeEach(^{
        userDescription = createUserDescription(username);
    });
    
    describe(@"isEqual for invalid type", ^{
        it(@"nil", ^{
            BOOL equal = [userDescription isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-user description", ^{
            BOOL equal = [userDescription isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });
    
    describe(@"isEqual and hash", ^{
        __block NSUInteger userDescriptionHash;
        
        beforeEach(^{
            userDescriptionHash = [userDescription hash];
        });
        
        it(@"same instance", ^{
            BOOL equal = [userDescription isEqual:userDescription];
            expect(equal).to.beTruthy();
        });
        
        it(@"same username", ^{
            RTUserDescription *other = createUserDescription(username);
            
            BOOL equal = [userDescription isEqual:other];
            expect(equal).to.beTruthy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).to.equal(userDescriptionHash);
        });
        
        it(@"different username", ^{
            RTUserDescription *other = createUserDescription([NSString stringWithFormat:@"%@a", username]);
            
            BOOL equal = [userDescription isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(userDescriptionHash);
        });
        
        it(@"nil username", ^{
            RTUserDescription *other = createUserDescription(nil);
            
            BOOL equal = [userDescription isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(userDescriptionHash);
        });
        
        it(@"both nil username", ^{
            RTUserDescription *left = createUserDescription(nil);
            RTUserDescription *right = createUserDescription(nil);
            
            BOOL equal = [left isEqual:right];
            expect(equal).to.beFalsy();
        });
    });
});

SpecEnd
