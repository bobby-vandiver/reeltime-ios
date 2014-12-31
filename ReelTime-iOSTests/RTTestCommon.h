#define EXP_SHORTHAND
#define MOCKITO_SHORTHAND

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMockito/OCMockito.h>

// Neither Specta nor Expecta provide a way to unconditionally fail a test
#define fail() expect(0).to.equal(1)