//
//  CMPDataStorageUserDefaults.h
//  GDPR
//

#import <Foundation/Foundation.h>
#import "SPTIabTCFv1StorageProtocol.h"

@interface SPTIabTCFv1StorageUserDefaults : NSObject<SPTIabTCFv1StorageProtocol>

@property (nonatomic, retain) NSUserDefaults *userDefaults;

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefs
    NS_SWIFT_NAME(initWith(userDefaults:));

@end
