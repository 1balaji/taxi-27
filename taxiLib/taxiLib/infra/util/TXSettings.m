//
//  TXSettings.m
//  taxiLib
//
//  Created by Irakli Vashakidze on 1/22/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXSettings.h"
#import "TXHttpRequestManager.h"
#import "StrConsts.h"
#import "Macro.h"
#import "TXError.h"
#import "FDKeyChain.h"

@interface TXSettings()<TXHttpRequestListener>

-(TXSettings*)init;

-(void)initWithDefaults;
-(void)initWithObject:(NSDictionary*)userProfile;
-(void)onRequestCompleted:(id)object;
-(void)onFail:(id)object error:(TXError *)error;

@end

@implementation TXSettings

+(TXSettings *) instance {
    static dispatch_once_t settingsPred;
    static TXSettings* _settingsInstance;
    dispatch_once(&settingsPred, ^{ _settingsInstance = [[self alloc] init]; });
    return _settingsInstance;
}


-(id) init {
	self = [super init];
	if ( self ) {
        NSURL* t = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		stgPath = [[t URLByAppendingPathComponent:Files.SETTINGSFILE] path];
		NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:stgPath];
        
		NSPropertyListFormat format;
		NSString *errorString;
		root = [NSPropertyListSerialization propertyListFromData:plistXML
                                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                          format:&format
                                                errorDescription:&errorString];
		if (root == nil) {
            root = [[NSMutableDictionary alloc] initWithCapacity:10];
            NSTimeInterval installDate = ((NSDate*)[NSDate date]).timeIntervalSinceReferenceDate;
            NSString* val = [NSString stringWithFormat:@"%f", installDate];
            [root setObject:val forKey:SettingsConst.Property.LOCALSTG_INSTALLDATE];
            
            [self initWithDefaults];
		}
        
	}
	return self;
}

-(void)saveSettings {
    [root writeToFile:self->stgPath atomically:YES];
}

-(void)initWithDefaults {
    
   // [self setProperty:SettingsConst.Property.BASEURL value:@"http://localhost"]; // Me
   // [self setProperty:SettingsConst.Property.PORT value:@"8080"];
    
    [self setProperty:SettingsConst.Property.BASEURL value:@"http://192.168.43.221"]; // Archvi
    [self setProperty:SettingsConst.Property.PORT value:@"8095"];
    
    [self setUserName:@"tomcat"];
    [self setPassword:@"tomcat"];
    
}

//receives server side parameters for the user, for initial settings will have default user settings, and admin settings
-(void)initWithObject:(NSDictionary*)userProfile {
    for (NSString *key in [userProfile keyEnumerator]) {
        [self setProperty:key value:[userProfile objectForKey:key]];
    }
}

-(void)setProperty:(NSString*)property value:(id)value {
    
    if ( [property length] > 0 && value != nil ) {
        [self->root setObject:value forKey:property];
    }
}

-(id)getProperty:(NSString*)property {
    if ( [property length] > 0 )
        return [self->root objectForKey:property];
    DLogE(@"Illegal parameter, empty key name!");
    return nil;
    
    return [NSNull null];
}

-(NSString*)getUserName {
    return [FDKeychain itemForKey:SettingsConst.CryptoKeys.TXCRYPTO_KEY_USER
                       forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(NSString*)getPassword {
    return [FDKeychain itemForKey:SettingsConst.CryptoKeys.TXCRYPTO_KEY_PWD
                       forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void)setUserName:(NSString*)userName {
    [FDKeychain saveItem:userName forKey:SettingsConst.CryptoKeys.TXCRYPTO_KEY_USER
              forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void)setPassword:(NSString*)pwd {
    [FDKeychain saveItem:pwd forKey:SettingsConst.CryptoKeys.TXCRYPTO_KEY_PWD
              forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(int) getMaxHTTPConnectionsNumber {
    return [ [self getProperty:SettingsConst.Property.MAXHTTPCONNECTIONS] intValue];
}

-(void)onRequestCompleted:(id)object {
    
}

-(void)onFail:(id)object error:(TXError *)error {
   
}

@end
