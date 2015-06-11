#import "RTTestCommon.h"

#import "RTClient.h"

SpecBegin(RTClient)

describe(@"client", ^{
    
    __block RTClient *client;
    
    beforeEach(^{
        client = [[RTClient alloc] initWithClientId:clientId clientName:clientName];
    });
    
    describe(@"isEqual for client with non-client", ^{
        it(@"nil", ^{
            BOOL equal = [client isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-client", ^{
            BOOL equal = [client isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });
    
    describe(@"isEqual and hash for clients", ^{
        __block NSUInteger clientHash;
        
        beforeEach(^{
            clientHash = [client hash];
        });
        
        describe(@"clients are equal", ^{
            it(@"same instance", ^{
                BOOL equal = [client isEqual:client];
                expect(equal).to.beTruthy();
            });
            
            it(@"different instances, same property value", ^{
                RTClient *other = [[RTClient alloc] initWithClientId:[clientId copy]
                                                          clientName:[clientName copy]];
                
                BOOL equal = [client isEqual:other];
                expect(equal).to.beTruthy();

                NSUInteger otherHash = [other hash];
                expect(otherHash).to.equal(clientHash);
            });
        });
        
        describe(@"clients are not equal", ^{
            void (^expectNotEqual)(NSString *, NSString *) = ^(NSString *otherClientId,
                                                               NSString *otherClientName) {

                RTClient *other = [[RTClient alloc] initWithClientId:otherClientId
                                                          clientName:otherClientName];
                
                BOOL equal = [client isEqual:other];
                expect(equal).to.beFalsy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).toNot.equal(clientHash);
            };
            
            it(@"different client id", ^{
                expectNotEqual([NSString stringWithFormat:@"%@a", clientId], [clientName copy]);
            });
            
            it(@"nil client id", ^{
                expectNotEqual(nil, [clientName copy]);
            });
            
            it(@"both have nil client id", ^{
                RTClient *left = [[RTClient alloc] initWithClientId:nil clientName:clientName];
                RTClient *right = [[RTClient alloc] initWithClientId:nil clientName:[clientName copy]];
                
                BOOL equal = [left isEqual:right];
                expect(equal).to.beFalsy();
            });
        });
    });
});

SpecEnd