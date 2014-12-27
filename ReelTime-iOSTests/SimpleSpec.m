//
//  SimpleSpec.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/27/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "Common.h"

SpecBegin(NSMutableArray)

describe(@"simple test suite", ^{
    
    it(@"passing test", ^{
        expect(1).to.equal(1);
    });
    
    it(@"failing tests", ^{
        expect(1).to.equal(-1);
    });
    
    describe(@"mock object tests", ^{
        __block NSMutableArray *mockArray;
        
        beforeEach(^{
            mockArray = OCMClassMock([NSMutableArray class]);
            OCMStub([mockArray count]).andReturn(42);
        });
        
        afterEach(^{
            OCMVerify([mockArray count]);
        });
        
        it(@"passing test", ^{
            expect([mockArray count]).to.equal(42);
        });
        
        it(@"failing tests", ^{
            expect([mockArray count]).to.equal(-1);
        });
    });
});

SpecEnd
