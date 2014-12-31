#define EXP_SHORTHAND
#define MOCKITO_SHORTHAND

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMockito/OCMockito.h>

// Neither Specta nor Expecta provide a way to unconditionally fail a test
#define fail() expect(0).to.equal(1)

// Expecta does not provide a simple way to check NSError instances
#define expectError(actualError, expectedDomain, expectedCode) do {     \
    expect(actualError).toNot.beNil();                                  \
    expect(actualError).to.beKindOf([NSError class]);                   \
    expect(((NSError*)(actualError)).domain).to.equal(expectedDomain);  \
    expect(((NSError*)(actualError)).code).to.equal(expectedCode);      \
} while(0)
