#import "../PS.h"
#import "CharacterSet.h"
#import "EmojiCharacterSet.h"
#import "EmojiPresentation.h"
#import "uset.h"
#import "../libsubstitrate/substitrate.h"
#import <substrate.h>

typedef int32_t UChar32;

extern "C" CFCharacterSetRef _CFCreateCharacterSetFromUSet(USet *);

%config(generator=MobileSubstrate)

%group CharacterSet

static NSData *dataFromHexString(NSString *string) {
    string = [string lowercaseString];
    NSMutableData *data = [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {
        '\0', '\0', '\0'
    };
    NSUInteger i = 0;
    NSUInteger length = string.length;
    while (i < length - 1) {
        char c = [string characterAtIndex:i++];
        if (c == ' ')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

CFCharacterSetRef (*CreateCharacterSetForFont)(CFStringRef const);
CFDataRef (*XTCopyUncompressedBitmapRepresentation)(const UInt8 *, CFIndex);
%hookf(CFCharacterSetRef, CreateCharacterSetForFont, CFStringRef const fontName) {
    if (CFStringEqual(fontName, CFSTR("AppleColorEmoji")) || CFStringEqual(fontName, CFSTR(".AppleColorEmojiUI"))) {
        if (isiOS11Up) {
                CFDataRef compressedData = (__bridge CFDataRef)dataFromHexString(compressedSet);
                CFDataRef uncompressedData = XTCopyUncompressedBitmapRepresentation(CFDataGetBytePtr(compressedData), CFDataGetLength(compressedData));
                CFRelease(compressedData);
                if (uncompressedData) {
                    CFCharacterSetRef ourSet = CFCharacterSetCreateWithBitmapRepresentation(kCFAllocatorDefault, uncompressedData);
                    CFRelease(uncompressedData);
                    return ourSet;
                }
        } else {
                CFDataRef legacyUncompressedData = (CFDataRef)dataFromHexString(uncompressedSet);
                CFCharacterSetRef ourLegacySet = CFCharacterSetCreateWithBitmapRepresentation(kCFAllocatorDefault, legacyUncompressedData);
                return ourLegacySet;
        }
    }
    return %orig;
}

%end

#if __LP64__

static USet *unicodeSet = NULL;
static CFCharacterSetRef characterSet = NULL;

%group EmojiPresentation

void (*IsDefaultEmojiPresentation)(void *);
CFMutableCharacterSetRef *DefaultEmojiPresentationSet;

%hookf(void, IsDefaultEmojiPresentation, void *arg0) {
    *DefaultEmojiPresentationSet = (CFMutableCharacterSetRef)characterSet;
}

%end

%group EmojiPresentationUSet

bool (*IsDefaultEmojiPresentationUSet)(UChar32);
%hookf(bool, IsDefaultEmojiPresentationUSet, UChar32 c) {
    return uset_contains(unicodeSet, c);
}

%end

#endif

%ctor {
    const char *ct = realPath2(@"/System/Library/Frameworks/CoreText.framework/CoreText");
    CreateCharacterSetForFont = (CFCharacterSetRef (*)(CFStringRef const))PSFindSymbolCallableCompat(ct, "__Z25CreateCharacterSetForFontPK10__CFString");
    XTCopyUncompressedBitmapRepresentation = (CFDataRef (*)(const UInt8 *, CFIndex))PSFindSymbolCallableCompat(ct, "__Z38XTCopyUncompressedBitmapRepresentationPKhm");
    if (XTCopyUncompressedBitmapRepresentation == NULL || CreateCharacterSetForFont == NULL) {
        HBLogError(@"[CoreTextHack: CharacterSet] Fatal: couldn't find CreateCharacterSetForFont and/or XTCopyUncompressedBitmapRepresentation");
        return;
    }
    %init(CharacterSet);
#if __LP64__
    unicodeSet = uset_openEmpty();
    for (int i = 0; i < emojiPresentationCount; ++i)
        uset_add(unicodeSet, emojiPresentation[i]);
    uset_freeze(unicodeSet);
    characterSet = _CFCreateCharacterSetFromUSet(unicodeSet);
    CFRetain(characterSet);
    if (IS_IOS_BETWEEN_EEX(iOS_11_0, iOS_12_1)) {
        IsDefaultEmojiPresentation = (void (*)(void *))PSFindSymbolCallableCompat(ct, "__ZZL26IsDefaultEmojiPresentationjEN4$_138__invokeEPv");
        if (IsDefaultEmojiPresentation == NULL)
            IsDefaultEmojiPresentation = (void (*)(void *))PSFindSymbolCallableCompat(ct, "__ZZL26IsDefaultEmojiPresentationjEN4$_128__invokeEPv");
        DefaultEmojiPresentationSet = (CFMutableCharacterSetRef (*))PSFindSymbolReadableCompat(ct, "__ZZL26IsDefaultEmojiPresentationjE28sDefaultEmojiPresentationSet");
        if (IsDefaultEmojiPresentation == NULL || DefaultEmojiPresentationSet == NULL) {
            HBLogError(@"[CoreTextHack: EmojiPresentation] Fatal: couldn't find IsDefaultEmojiPresentation and/or DefaultEmojiPresentationSet");
            return;
        }
        %init(EmojiPresentation);
    } else if (isiOS12_2Up) {
        IsDefaultEmojiPresentationUSet = (bool (*)(UChar32))PSFindSymbolCallableCompat(ct, "__Z26IsDefaultEmojiPresentationj");
        if (IsDefaultEmojiPresentationUSet == NULL) {
            HBLogError(@"[CoreTextHack: EmojiPresentation] Fatal: couldn't find IsDefaultEmojiPresentation (USet)");
            return;
        }
        %init(EmojiPresentationUSet);
    }
#endif
}
