#import "RTTestCommon.h"

#import "RTClientDescription.h"

SpecBegin(RTClientDescription)

describe(@"client description", ^{
    
    __block RTClientDescription *clientDescription;
    
    RTClientDescription * (^createClientDescription)(NSString *) = ^(NSString *clientId) {
        return [RTClientDescription clientDescriptionWithClientId:clientId clientName:anything()];
    };
    
    beforeEach(^{
        clientDescription = createClientDescription(clientId);
    });
    
    describe(@"isEqual for invalid type", ^{
        it(@"nil", ^{
            BOOL equal = [clientDescription isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-client description", ^{
            BOOL equal = [clientDescription isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });
    
    describe(@"isEqual and hash", ^{
        __block NSUInteger clientDescriptionHash;
        
        beforeEach(^{
            clientDescriptionHash = [clientDescription hash];
        });
        
        it(@"same instance", ^{
            BOOL equal = [clientDescription isEqual:clientDescription];
            expect(equal).to.beTruthy();
        });
        
        it(@"same clientId", ^{
            RTClientDescription *other = createClientDescription(clientId);
            
            BOOL equal = [clientDescription isEqual:other];
            expect(equal).to.beTruthy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).to.equal(clientDescriptionHash);
        });
        
        it(@"different clientId", ^{
            RTClientDescription *other = createClientDescription([NSString stringWithFormat:@"%@a", clientId]);
            
            BOOL equal = [clientDescription isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(clientDescriptionHash);
        });
        
        it(@"nil clientId", ^{
            RTClientDescription *other = createClientDescription(nil);
            
            BOOL equal = [clientDescription isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(clientDescriptionHash);
        });
        
        it(@"both nil clientId", ^{
            RTClientDescription *left = createClientDescription(nil);
            RTClientDescription *right = createClientDescription(nil);
            
            BOOL equal = [left isEqual:right];
            expect(equal).to.beFalsy();
        });
    });
});

SpecEnd
