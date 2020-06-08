# IAB-TCF-V2-Objective-C
IAB Transparency and Consent Framework consent string decoder in Objective-C

# Use
## Copy files
## Use the following code to obtain a model with all the property of IAB Transparency and Consent Framework v1.1 or v2

```Objective-C
SPTIabTCFModel *model = [SPTIabConsentStringParser parseConsentString:<A_CONSENT_STRING>];
```
⚠️ Purposes and Vendors consents are decoded as succession of "0" ans "1" string to be compliant with IAB TCF v1.0 mobile. 
🚀 **Coming soon** : 
- Model will include ***[model isConsentGivenForID:(int)stuffID]*** 
- Maybe a coder if needed (or if someone wants to do it 😊)

