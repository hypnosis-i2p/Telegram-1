#import "TGCreateEncryptedChatController.h"

#import <LegacyComponents/LegacyComponents.h>

#import "TGAppDelegate.h"

#import <LegacyComponents/TGProgressWindow.h>

#import "TGInterfaceManager.h"

#import "TGAlertView.h"

@interface TGCreateEncryptedChatController ()
{
    TGProgressWindow *_progressWindow;
    TGUser *_user;
}

@end

@implementation TGCreateEncryptedChatController

- (id)init
{
    self = [super initWithContactsMode:TGContactsModeRegistered | TGContactsModeSelectModal];
    if (self != nil)
    {
        self.titleText = TGLocalized(@"Compose.NewEncryptedChat");
    }
    return self;
}

- (void)singleUserSelected:(TGUser *)user
{
    [self deselectRow];
    
    _user = user;
    
    _progressWindow = [[TGProgressWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_progressWindow show:true];
    
    static int actionId = 0;
    [ActionStageInstance() requestActor:[[NSString alloc] initWithFormat:@"/tg/encrypted/createChat/(profile%d)", actionId++] options:@{@"uid": @(user.uid)} flags:0 watcher:self];
}

- (void)actorCompleted:(int)status path:(NSString *)path result:(id)result
{
    if ([path hasPrefix:@"/tg/encrypted/createChat/"])
    {
        TGDispatchOnMainThread(^
        {
            [_progressWindow dismiss:true];
            _progressWindow = nil;
            
            if (status == ASStatusSuccess)
            {
                TGConversation *conversation = result[@"conversation"];
                [[TGInterfaceManager instance] navigateToConversationWithId:conversation.conversationId conversation:nil];
            }
            else
            {
                [[[TGAlertView alloc] initWithTitle:nil message:status == -2 ? [[NSString alloc] initWithFormat:TGLocalized(@"Login.UnknownError"), _user.displayFirstName, _user.displayFirstName] : TGLocalized(@"Profile.CreateEncryptedChatError") delegate:nil cancelButtonTitle:TGLocalized(@"Common.OK") otherButtonTitles:nil] show];
            }
        });
    }
    
    [super actorCompleted:status path:path result:result];
}

- (void)loadView
{
    [super loadView];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && self.navigationController.viewControllers.firstObject == self)
    {
        [self setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:TGLocalized(@"Common.Close") style:UIBarButtonItemStylePlain target:self action:@selector(closePressed)]];
    }
}

- (void)closePressed
{
    [TGAppDelegateInstance.rootController clearContentControllers];
}

@end
