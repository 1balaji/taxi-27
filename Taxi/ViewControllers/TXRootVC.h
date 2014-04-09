//
//  TXRootVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 3/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXModelBase.h"
#import "TXBaseViewController.h"

@interface TXRootVC : TXBaseViewController<TXEventListener, GPPSignInDelegate> {
    NSDictionary *parameters;
}

@property (nonatomic, strong) TXModelBase   *model;
@property (nonatomic, strong) TXSharedObj   *sharedObj;
@property (nonatomic, strong) GPPSignIn     *signIn;
@property (nonatomic, strong) GTLPlusPerson *googlePerson;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)setModel:(TXModelBase *) model_ eventNames:(NSArray *) eventNames;
-(void) pushViewController : (TXRootVC *) viewController;
-(void) alertError : (NSString *) title message : (NSString *) message;
-(TXRootVC *) viewControllerInstanceWithName: (NSString *) name;
-(TXRootVC *) viewControllerInstanceFromClass: (Class) aClass;
-(void)refreshInterfaceBasedOnSignIn;
-(void) setParameters:(NSDictionary *)props;
@end
