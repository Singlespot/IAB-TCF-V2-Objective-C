//
//  CMPDataStorageUserDefaults.m
//  GDPR
//

#import "SPTIabTCFv1StorageUserDefaults.h"

NSString *const SPT_IABConsent_SubjectToGDPRKey = @"IABConsent_SubjectToGDPR";
NSString *const SPT_IABConsent_ConsentStringKey = @"IABConsent_ConsentString";
NSString *const SPT_IABConsent_ParsedVendorConsentsKey = @"IABConsent_ParsedVendorConsents";
NSString *const SPT_IABConsent_ParsedPurposeConsentsKey = @"IABConsent_ParsedPurposeConsents";
NSString *const SPT_IABConsent_CMPPresentKey = @"IABConsent_CMPPresent";

@implementation SPTIabTCFv1StorageUserDefaults

@synthesize consentString;
@synthesize subjectToGDPR;
@synthesize cmpPresent;
@synthesize parsedVendorConsents;
@synthesize parsedPurposeConsents;

/*
 * Test method for uncoupling userDefaults
 */
- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefs
{
    self = [super init];
    if (self) {
        _userDefaults = userDefs;
        [self registerDefaultUserDefault];
    }
    return self;
}
// **************************************************************

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        [self registerDefaultUserDefault];

    }
    return _userDefaults;
}

- (void) registerDefaultUserDefault {
    NSDictionary *dataStorageDefaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"", SPT_IABConsent_ConsentStringKey,
                                              @"", SPT_IABConsent_ParsedVendorConsentsKey,
                                              @"", SPT_IABConsent_ParsedPurposeConsentsKey,
                                              [NSNumber numberWithBool:NO], SPT_IABConsent_CMPPresentKey,
                                              nil];
    [_userDefaults registerDefaults:dataStorageDefaultValues];
}

+(NSString*)keyIABConsentString {
    return SPT_IABConsent_ConsentStringKey;
}

-(NSString *)consentString {
    return [self.userDefaults objectForKey:SPT_IABConsent_ConsentStringKey];
}

-(void)setConsentString:(NSString *)newConsentString {
    [self.userDefaults setObject:newConsentString forKey:SPT_IABConsent_ConsentStringKey];
    [self.userDefaults synchronize];
}

-(SubjectToGDPR)subjectToGDPR {
    NSString *subjectToGDPRAsString = [self.userDefaults objectForKey:SPT_IABConsent_SubjectToGDPRKey];

    if (subjectToGDPRAsString != nil) {
        if ([subjectToGDPRAsString isEqualToString:@"0"]) {
            return SubjectToGDPR_No;
        } else if ([subjectToGDPRAsString isEqualToString:@"1"]) {
            return SubjectToGDPR_Yes;
        } else {
            return SubjectToGDPR_Unknown;
        }
    } else {
        return SubjectToGDPR_Unknown;
    }
}

-(void)setSubjectToGDPR:(SubjectToGDPR)newSubjectToGDPR {
    NSString *subjectToGDPRAsString = nil;

    if (newSubjectToGDPR == SubjectToGDPR_No || newSubjectToGDPR == SubjectToGDPR_Yes) {
        subjectToGDPRAsString = [NSString stringWithFormat:@"%li", (long)newSubjectToGDPR];
    }

    [self.userDefaults setObject:subjectToGDPRAsString forKey:SPT_IABConsent_SubjectToGDPRKey];
    [self.userDefaults synchronize];
}

-(BOOL)cmpPresent {
    return [[self.userDefaults objectForKey:SPT_IABConsent_CMPPresentKey] boolValue];
}

-(void)setCmpPresent:(BOOL)newCmpPresent {
    [self.userDefaults setBool:newCmpPresent forKey:SPT_IABConsent_CMPPresentKey];
    [self.userDefaults synchronize];
}

-(NSString *)parsedVendorConsents {
    return [self.userDefaults objectForKey:SPT_IABConsent_ParsedVendorConsentsKey];
}

-(void)setParsedVendorConsents:(NSString *)newParsedVendorConsents {
    [self.userDefaults setObject:newParsedVendorConsents forKey:SPT_IABConsent_ParsedVendorConsentsKey];
    [self.userDefaults synchronize];
}

-(NSString *)parsedPurposeConsents {
    return [self.userDefaults objectForKey:SPT_IABConsent_ParsedPurposeConsentsKey];
}

-(void)setParsedPurposeConsents:(NSString *)newParsedPurposeConsents {
    [self.userDefaults setObject:newParsedPurposeConsents forKey:SPT_IABConsent_ParsedPurposeConsentsKey];
    [self.userDefaults synchronize];
}

@end
