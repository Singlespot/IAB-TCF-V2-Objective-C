//
//  SPTIabTCFApi.m
//  SPTProximityKit
//
//  Created by Quentin Beaudouin on 14/06/2020.
//  Copyright © 2020 Alexandre Fortoul. All rights reserved.
//

#import "SPTIabTCFApi.h"
#import "SPTIabTCFv1StorageUserDefaults.h"
#import "SPTIabTCFv2StorageUserDefaults.h"

@interface SPTIabTCFApi()
@property (nonatomic, retain, readwrite) SPTIabTCFModel *tcModel;
@end

@implementation SPTIabTCFApi

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefs {
    self = [super init];
    if (self) {
        _v1DataStorage = [[SPTIabTCFv1StorageUserDefaults alloc] initWithUserDefaults:userDefs];
        _v2DataStorage = [[SPTIabTCFv2StorageUserDefaults alloc] initWithUserDefaults:userDefs];
    }
    return self;
}

-(id<SPTIabTCFv1StorageProtocol>)v1DataStorage  {
    if (!_v1DataStorage) {
        _v1DataStorage = [SPTIabTCFv1StorageUserDefaults new];
    }
    return _v1DataStorage;
}

-(id<SPTIabTCFv2StorageProtocol>)v2DataStorage  {
    if (!_v2DataStorage) {
        _v2DataStorage = [SPTIabTCFv2StorageUserDefaults new];
    }
    return _v2DataStorage;
}

+ (SPTIabTCFModel *)decodeTCString:(NSString *)tcString {
    return [SPTIabTCStringParser parseConsentString:tcString];
}

-(NSString *)consentString {
    NSString *v1String = self.v1DataStorage.consentString;
    NSString *v2String = self.v2DataStorage.tcString;
    if (v1String && ![self isValidString:v2String] && !self.ignoreV1) {
        return v1String;
    }
    else {
        return v2String;
    }
}

-(void)setConsentString:(NSString *)consentString {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:consentString];
    self.tcModel = model;

    NSString *parsedVendorConsents = model.parsedVendorsConsents;
    NSString *parsedPurposeConsents = model.parsedPurposesConsents;

    if (model.version == 1) {
        self.v1DataStorage.consentString = consentString;
        self.v1DataStorage.parsedVendorConsents = parsedVendorConsents;
        self.v1DataStorage.parsedPurposeConsents = parsedPurposeConsents;
    }
    else if (model.version == 2) {
        self.v2DataStorage.tcString = consentString;

        self.v2DataStorage.cmpSdkId = model.cmpId;
        self.v2DataStorage.cmpSdkVersion = model.cmpVersion;

        self.v2DataStorage.policyVersion = model.policyVersion;

        self.v2DataStorage.publisherCountryCode = model.publisherCountryCode;
        self.v2DataStorage.purposeOneTreatment = model.purposeOneTreatment;
        self.v2DataStorage.useNonStandardStack = model.useNonStandardStack;
        self.v2DataStorage.isServiceSpecific = model.isServiceSpecific;

        self.v2DataStorage.parsedVendorsConsents = model.parsedVendorsConsents;
        self.v2DataStorage.parsedVendorsLegitmateInterest = model.parsedVendorsLegitmateInterest;
        self.v2DataStorage.parsedPurposesConsents = model.parsedPurposesConsents;
        self.v2DataStorage.parsedPurposesLegitmateInterest = model.parsedPurposesLegitmateInterest;
        self.v2DataStorage.specialFeatureOptIns = model.specialFeatureOptIns;
        self.v2DataStorage.publisherTCParsedPurposesConsents = model.publisherTCParsedPurposesConsents;
        self.v2DataStorage.publisherTCParsedPurposesLegitmateInterest = model.publisherTCParsedPurposesLegitmateInterest;
        self.v2DataStorage.publisherTCParsedCustomPurposesConsents = model.publisherTCParsedCustomPurposesConsents;
        self.v2DataStorage.publisherTCParsedCustomPurposesLegitmateInterest = model.publisherTCParsedCustomPurposesLegitmateInterest;
        for (SPTIabPublisherRestriction *pubRest in model.publisherRestrictions) {
            [self.v2DataStorage setPublisherRestrictions:pubRest.parsedVendors ForPurposeId:pubRest.purposeId];
        }
    }
}

-(NSInteger)cmpID {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return model.cmpId;
}

- (NSInteger)tcfVersionForTCString:(NSString*)string {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:string];
    return model.version;
}

//******************************************************************
#pragma mark - V1 & V2
//******************************************************************

-(NSString *)parsedVendorConsents {
    NSString *v1String = self.v1DataStorage.parsedVendorConsents;
    NSString *v2String = self.v2DataStorage.parsedVendorsConsents;
    if (v1String && ![self isValidString:v2String] && !self.ignoreV1) {
        return v1String;
    }
    else {
        return v2String;
    }
}

//- (void)setParsedVendorConsents:(NSString *)parsedVendorConsents forV1:(BOOL)forV1 {
//    if (forV1) {
//        self.v1DataStorage.parsedVendorConsents = parsedVendorConsents;
//    }
//    else {
//        self.v2DataStorage.parsedVendorsConsents = parsedVendorConsents;
//    }
//}

-(NSString *)parsedPurposeConsents {
    NSString *v1String = self.v1DataStorage.parsedPurposeConsents;
    NSString *v2String = self.v2DataStorage.parsedPurposesConsents;
    if (v1String && ![self isValidString:v2String] && !self.ignoreV1) {
        return v1String;
    }
    else {
        return v2String;
    }
}

//- (void)setParsedPurposeConsents:(NSString *)parsedPurposeConsents forV1:(BOOL)forV1 {
//    if (forV1) {
//        self.v1DataStorage.parsedPurposeConsents = parsedPurposeConsents;
//    }
//    else {
//        self.v2DataStorage.parsedPurposesConsents = parsedPurposeConsents;
//    }
//}

- (BOOL)isVendorConsentGivenFor:(int)vendorId {
    return [self isVendorConsentGivenFor:vendorId inConsentString:self.consentString];
}

- (BOOL)isVendorConsentGivenFor:(int)vendorId inConsentString:(NSString*)string {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:string];
    return [model isVendorConsentGivenFor:vendorId];
}

- (BOOL)isPurposeConsentGivenFor:(int)purposeId {
    return [self isPurposeConsentGivenFor:purposeId inConsentString:self.consentString];
}

- (BOOL)isPurposeConsentGivenFor:(int)purposeId inConsentString:(NSString*)string {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:string];
    return [model isPurposeConsentGivenFor:purposeId];
}

- (BOOL)isValidString:(NSString *)aString {
    return aString && [aString length] != 0;
}

//******************************************************************
#pragma mark - V1 Specific
//******************************************************************

-(SubjectToGDPR)subjectToGDPR {
    return self.v1DataStorage.subjectToGDPR;
}

-(void)setSubjectToGDPR:(SubjectToGDPR)subjectToGDPR {
    self.v1DataStorage.subjectToGDPR = subjectToGDPR;
}

-(BOOL)cmpPresent {
    return self.v1DataStorage.cmpPresent;
}

-(void)setCmpPresent:(BOOL)cmpPresent {
    self.v1DataStorage.cmpPresent = cmpPresent;
}

//******************************************************************
#pragma mark - V2 Specific
//******************************************************************

- (NSInteger)cmpSdkId {
    return self.v2DataStorage.cmpSdkId;
}

- (void)setCmpSdkId:(NSInteger)cmpSdkId {
    self.v2DataStorage.cmpSdkId = cmpSdkId;
}

- (NSInteger)cmpSdkVersion {
    return self.v2DataStorage.cmpSdkVersion;
}

- (void)setCmpSdkVersion:(NSInteger)cmpSdkVersion {
    self.v2DataStorage.cmpSdkVersion = cmpSdkVersion;
}

- (NSInteger)policyVersion {
    return self.v2DataStorage.policyVersion;
}

- (void)setPolicyVersion:(NSInteger)policyVersion {
    self.v2DataStorage.policyVersion = policyVersion;
}

- (GdprApplies)gdprApplies {
    return self.v2DataStorage.gdprApplies;
}

- (void)setGdprApplies:(GdprApplies)gdprApplies {
    self.v2DataStorage.gdprApplies = gdprApplies;
}

- (NSString *)publisherCountryCode {
    return self.v2DataStorage.publisherCountryCode;
}

- (void)setPublisherCountryCode:(NSString *)publisherCountryCode {
    self.v2DataStorage.publisherCountryCode = publisherCountryCode;
}

- (BOOL)purposeOneTreatment {
    return self.v2DataStorage.purposeOneTreatment;
}

- (void)setPurposeOneTreatment:(BOOL)purposeOneTreatment {
    self.v2DataStorage.purposeOneTreatment = purposeOneTreatment;
}

- (BOOL)useNonStandardStack {
    return self.v2DataStorage.useNonStandardStack;
}

- (void)setUseNonStandardStack:(BOOL)useNonStandardStack {
    self.v2DataStorage.useNonStandardStack = useNonStandardStack;
}

- (BOOL)isServiceSpecific {
    return self.v2DataStorage.isServiceSpecific;
}

- (void)setIsServiceSpecific:(BOOL)isServiceSpecific {
    self.v2DataStorage.isServiceSpecific = isServiceSpecific;
}

- (PublisherRestrictionType)publisherRestrictionTypeForVendor:(int)vendorId forPurpose:(int)purposeId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model publisherRestrictionTypeForVendor:vendorId forPurpose:purposeId];
}


- (BOOL)isSpecialFeatureOptedInFor:(int)specialFeatureId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model isSpecialFeatureOptedInFor:specialFeatureId];
}

- (BOOL)isVendorDiscloseFor:(int)vendorId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model isVendorDiscloseFor:vendorId];
}

- (BOOL)isVendorAllowedFor:(int)vendorId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model isVendorAllowedFor:vendorId];
}

- (BOOL)isVendorLegitimateInterestGivenFor:(int)vendorId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model isVendorLegitInterestGivenFor:vendorId];
}

- (BOOL)isPurposeLegitimateInterestGivenFor:(int)vendorId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model isPurposeLegitInterestGivenFor:vendorId];
}

- (BOOL)isPublisherPurposeConsentGivenFor:(int)vendorId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model isPublisherPurposeConsentGivenFor:vendorId];
}

- (BOOL)isPublisherPurposeLegitimateInterestGivenFor:(int)vendorId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model isPublisherPurposeLegitInterestGivenFor:vendorId];
}

- (BOOL)isPublisherCustomPurposeConsentGivenFor:(int)vendorId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model isPublisherCustomPurposeConsentGivenFor:vendorId];
}

- (BOOL)isPublisherCustomPurposeLegitimateInterestGivenFor:(int)vendorId {
    SPTIabTCFModel *model = [SPTIabTCStringParser parseConsentString:self.consentString];
    return [model isPublisherCustomPurposeLegitInterestGivenFor:vendorId];
}


@end
