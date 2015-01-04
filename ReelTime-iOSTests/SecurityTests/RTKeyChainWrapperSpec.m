#import "RTTestCommon.h"

#import "RTKeyChainWrapper.h"
#import "RTKeyChainErrors.h"

SpecBegin(RTKeyChainWrapper)

describe(@"key chain wrapper", ^{
    
    __block RTKeyChainWrapper *wrapper;
   
    beforeEach(^{
        UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStore];
        wrapper = [[RTKeyChainWrapper alloc] initWithKeyChainStore:keyChainStore];
    });
    
    describe(@"loading items from keychain", ^{
        it(@"should return nil when item is not found", ^{
            RTError *error;
            id<NSSecureCoding> object = [wrapper objectForKey:@"unknown" error:&error];
            
            expect(object).to.beNil();
            expect(error).to.beError(RTKeyChainWrapperErrorDomain, ItemNotFound);
        });
        
        it(@"should return object when item is found", ^{
            [wrapper setObject:@"something" forKey:@"found" error:nil];
            
            RTError *error;
            id<NSSecureCoding> object = [wrapper objectForKey:@"found" error:&error];
            
            expect(object).to.equal(@"something");
            expect(error).to.beNil();
        });
    });
    
    describe(@"storing item in keychain", ^{
        it(@"should return YES when item is stored successfully", ^{
            RTError *error;
            BOOL success = [wrapper setObject:@"something" forKey:@"store" error:&error];
            
            expect(success).to.beTruthy();
            expect(error).to.beNil();
        });
        
        it(@"should update item that already exists", ^{
            [wrapper setObject:@"anything" forKey:@"existing" error:nil];

            id<NSSecureCoding> existing = [wrapper objectForKey:@"existing" error:nil];
            expect(existing).to.equal(@"anything");
            
            RTError *error;
            BOOL success = [wrapper setObject:@"something" forKey:@"existing" error:&error];
            expect(success).to.beTruthy();
            
            id<NSSecureCoding> object = [wrapper objectForKey:@"existing" error:nil];
            expect(object).to.equal(@"something");
        });
    });
    
});

SpecEnd