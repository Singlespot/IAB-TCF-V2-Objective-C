//
//  SPTIabTCFModelV1.m
//  SPTProximityKit
//
//  Created by Quentin Beaudouin on 04/06/2020.
//  Copyright © 2020 Alexandre Fortoul. All rights reserved.
//

#import "SPTIabTCFModel.h"

@implementation SPTIabTCFModel

- (NSDictionary *)asJson {
    
    NSMutableDictionary * result = [NSMutableDictionary new];

    [result setValue:@(self.version) forKey:@"version"];
    [result setValue:self.created forKey:@"created"];
    [result setValue:self.lastUpdated forKey:@"lastUpdated"];
    [result setValue:@(self.cmpId) forKey:@"cmpId"];
    [result setValue:@(self.cmpVersion) forKey:@"cmpVersion"];
    [result setValue:@(self.consentScreen) forKey:@"consentScreen"];
    [result setValue:self.consentCountryCode forKey:@"consentCountryCode"];
    [result setValue:@(self.vendorListVersion) forKey:@"vendorListVersion"];
    [result setValue:self.parsedPurposesConsents forKey:@"parsedPurposesConsents"];
    [result setValue:self.parsedVendorsConsents forKey:@"parsedVendorsConsents"];
    
    [result setValue:self.parsedPurposesLegitmateInterest forKey:@"parsedPurposesLegitmateInterest"];
    [result setValue:self.parsedVendorsLegitmateInterest forKey:@"parsedVendorsLegitmateInterest"];
    [result setValue:@(self.policyVersion) forKey:@"policyVersion"];
    [result setValue:@(self.isServiceSpecific) forKey:@"isServiceSpecific"];
    [result setValue:@(self.useNonStandardStack) forKey:@"useNonStandardStack"];
    [result setValue:self.specialFeatureOptIns forKey:@"specialFeatureOptIns"];
    [result setValue:@(self.purposeOneTreatment) forKey:@"purposeOneTreatment"];
    [result setValue:self.publisherCountryCode forKey:@"publisherCountryCode"];
    
    [result setValue:self.parsedDisclosedVendors forKey:@"parsedDisclosedVendors"];
    [result setValue:self.parsedAllowedVendors forKey:@"parsedAllowedVendors"];
    
    [result setValue:self.publisherTCParsedPurposesConsents forKey:@"publisherTCParsedPurposesConsents"];
    [result setValue:self.publisherTCParsedPurposesLegitmateInterest forKey:@"publisherTCParsedPurposesLegitmateInterest"];
    [result setValue:self.publisherTCParsedCustomPurposesConsents forKey:@"publisherTCParsedCustomPurposesConsents"];
    [result setValue:self.publisherTCParsedCustomPurposesLegitmateInterest forKey:@"publisherTCParsedCustomPurposesLegitmateInterest"];
    
    
    NSMutableArray * pubRestArray = [[NSMutableArray alloc] initWithCapacity:self.publisherRestrictions.count];
    for (SPTIabPublisherRestriction *rest in self.publisherRestrictions) {
        [pubRestArray addObject:[rest asJson]];
    }
    
    [result setValue:pubRestArray forKey:@"publisherRestrictions"];

    return result;
    
}

@end
