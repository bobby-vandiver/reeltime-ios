#import "RTTestCommon.h"

#import "RTKeyChainWrapper.h"
#import "RTKeyChainError.h"

@interface RTKeyChainWrapper ()

- (void)mapKeyChainStoreError:(NSError *)error
           toApplicationError:(NSError *__autoreleasing *)appError;

@end

SpecBegin(RTKeyChainWrapper)

describe(@"key chain wrapper", ^{
    
    __block RTKeyChainWrapper *wrapper;
    __block NSError *error;
   
    beforeEach(^{
        UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStore];
        wrapper = [[RTKeyChainWrapper alloc] initWithKeyChainStore:keyChainStore];
        
        [keyChainStore removeAllItems];
        error = nil;
    });
    
    describe(@"loading item from keychain", ^{
        it(@"should return nil when key is nil", ^{
            id<NSSecureCoding> object = [wrapper objectForKey:nil error:&error];
            
            expect(object).to.beNil();
            expect(error).to.beError(RTKeyChainWrapperErrorDomain, RTKeyChainErrorMissingKey);
        });
        
        it(@"should return nil when item is not found", ^{
            id<NSSecureCoding> object = [wrapper objectForKey:@"RTKeyChainErrorUnknown" error:&error];
            
            expect(object).to.beNil();
            expect(error).to.beError(RTKeyChainWrapperErrorDomain, RTKeyChainErrorItemNotFound);
        });
        
        it(@"should return object when item is found", ^{
            [wrapper setObject:@"something" forKey:@"found" error:nil];

            id<NSSecureCoding> object = [wrapper objectForKey:@"found" error:&error];
            
            expect(object).to.equal(@"something");
            expect(error).to.beNil();
        });
    });
    
    describe(@"storing item in keychain", ^{
        it(@"should return YES when item is stored successfully", ^{
            BOOL success = [wrapper setObject:@"something" forKey:@"store" error:&error];
            
            expect(success).to.beTruthy();
            expect(error).to.beNil();
        });
        
        it(@"should update item that already exists", ^{
            [wrapper setObject:@"anything" forKey:@"existing" error:nil];

            id<NSSecureCoding> existing = [wrapper objectForKey:@"existing" error:nil];
            expect(existing).to.equal(@"anything");
            
            BOOL success = [wrapper setObject:@"something" forKey:@"existing" error:&error];
            expect(success).to.beTruthy();
            
            id<NSSecureCoding> object = [wrapper objectForKey:@"existing" error:nil];
            expect(object).to.equal(@"something");
        });
    });
    
    describe(@"removing item from keychain", ^{
        it(@"should return YES when removing item that doesn't exist", ^{
            BOOL success = [wrapper removeObjectForKey:@"RTKeyChainErrorUnknown" error:&error];
            
            expect(success).to.beTruthy();
            expect(error).to.beNil();
        });
        
        it(@"should return YES when removing item succesfully", ^{
            [wrapper setObject:@"something" forKey:@"remove" error:nil];

            id<NSSecureCoding> object = [wrapper objectForKey:@"remove" error:nil];
            expect(object).to.equal(@"something");
            
            BOOL success = [wrapper removeObjectForKey:@"remove" error:&error];

            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            object = [wrapper objectForKey:@"remove" error:nil];
            expect(object).to.beNil();
        });
    });
    
    describe(@"keychain operations fail", ^{
        __block UICKeyChainStore *keyChainStore;
        
        beforeEach(^{
            keyChainStore = mock([UICKeyChainStore class]);
            wrapper = [[RTKeyChainWrapper alloc] initWithKeyChainStore:keyChainStore];
        });
        
        it(@"should return NO when storing object with nil key", ^{
            BOOL success = [wrapper setObject:@"something" forKey:nil error:&error];

            expect(success).to.beFalsy();
            expect(error).to.beError(RTKeyChainWrapperErrorDomain, RTKeyChainErrorMissingKey);
        });
        
        it(@"should return NO when storing object fails", ^{
            [[given([keyChainStore setData:anything() forKey:@"store" error:nil])
              withMatcher:anything() forArgument:2]
             willReturnBool:NO];
            
            BOOL success = [wrapper setObject:@"something" forKey:@"store" error:&error];
            expect(success).to.beFalsy();
            
            [[verify(keyChainStore) withMatcher:anything() forArgument:2] setData:anything() forKey:@"store" error:nil];
        });
        
        it(@"should return NO when removing object with nil key", ^{
            BOOL success = [wrapper removeObjectForKey:nil error:&error];
            
            expect(success).to.beFalsy();
            expect(error).to.beError(RTKeyChainWrapperErrorDomain, RTKeyChainErrorMissingKey);
        });
        
        it(@"should return NO when removing object fails", ^{
            [[given([keyChainStore removeItemForKey:@"remove" error:nil])
              withMatcher:anything() forArgument:1]
             willReturnBool:NO];
            
            BOOL success = [wrapper removeObjectForKey:@"remove" error:&error];
            expect(success).to.beFalsy();
            
            [[verify(keyChainStore) withMatcher:anything() forArgument:1] removeItemForKey:@"remove" error:nil];
        });
    });
    
    describe(@"error mapping", ^{
        struct ErrorCodeMapping {
            int keyChainCode;
            int applicationCode;
        };
        
        static struct ErrorCodeMapping expectedMapping[] = {
            { errSecUnimplemented, RTKeyChainErrorUnknown },
            { errSecIO, RTKeyChainErrorUnknown },
            { errSecOpWr, RTKeyChainErrorUnknown },
            { errSecParam, RTKeyChainErrorUnknown },
            { errSecAllocate, RTKeyChainErrorUnknown },
            { errSecUserCanceled, RTKeyChainErrorUnknown },
            { errSecBadReq, RTKeyChainErrorUnknown },
            { errSecInternalComponent, RTKeyChainErrorUnknown },
            { errSecNotAvailable, RTKeyChainErrorUnknown },
            { errSecDuplicateItem, RTKeyChainErrorDuplicateItem },
            { errSecItemNotFound, RTKeyChainErrorItemNotFound },
            { errSecInteractionNotAllowed, RTKeyChainErrorUnknown },
            { errSecDecode, RTKeyChainErrorUnknown },
            { errSecAuthFailed, RTKeyChainErrorUnknown },
            { 0, 0 }
        };
        
        it(@"should map system keychain error to appropriate application error", ^{
            struct ErrorCodeMapping *mapping = expectedMapping;
            
            while(mapping->keyChainCode) {
                NSError *keyChainError = [NSError errorWithDomain:UICKeyChainStoreErrorDomain
                                                             code:mapping->keyChainCode
                                                         userInfo:nil];

                [wrapper mapKeyChainStoreError:keyChainError toApplicationError:&error];
                
                expect(error).to.beError(RTKeyChainWrapperErrorDomain, mapping->applicationCode);
                expect([error underlyingError]).to.equal(keyChainError);
                
                mapping++;
            }
        });
    });
});

SpecEnd