#include <unicode/utf16.h>

// EmojiCategory > -printCodepointsForPreset:10
#define skinToneCodepointsCount 109
static UChar32 skinToneCodepoints[] = {
    0x270a, 0x1f596, 0x270b, 0x270c, 0x270d, 0x1f3ca, 0x1f466, 0x1f6a3, 0x1f930, 0x1f3cb,
    0x1f467, 0x1f931, 0x1f3cc, 0x1f468, 0x1f442, 0x1f574, 0x1f932, 0x1f469, 0x1f443, 0x1f575,
    0x1f933, 0x1f934, 0x1f9cd, 0x1f935, 0x1f90f, 0x1f9ce, 0x1f446, 0x1f936, 0x1f9cf, 0x1f385,
    0x1f447, 0x1f937, 0x1f46e, 0x1f448, 0x261d, 0x1f57a, 0x1f938, 0x1f449, 0x1f9d1, 0x1f939,
    0x1f9d2, 0x1f470, 0x1f44a, 0x1f9d3, 0x1f471, 0x1f44b, 0x1f9d4, 0x1f472, 0x1f44c, 0x1f9d5,
    0x1f473, 0x1f44d, 0x1f93d, 0x1f9d6, 0x1f474, 0x1f44e, 0x1f93e, 0x1f918, 0x1f475, 0x1f44f,
    0x1f9d7, 0x1f919, 0x1f476, 0x1f450, 0x1f9d8, 0x1f91a, 0x1f477, 0x1f6b4, 0x1f9d9, 0x1f91b,
    0x1f478, 0x1f6b5, 0x1f9da, 0x1f91c, 0x1f6b6, 0x1f9b5, 0x1f9db, 0x1f9dc, 0x1f9b6, 0x1f645,
    0x1f91e, 0x1f9dd, 0x1f646, 0x1f91f, 0x1f47c, 0x1f9b8, 0x1f647, 0x1f9b9, 0x1f9bb, 0x26f9,
    0x1f64b, 0x1f481, 0x1f64c, 0x1f482, 0x1f64d, 0x1f926, 0x1f483, 0x1f6c0, 0x1f64e, 0x1f4aa,
    0x1f590, 0x1f64f, 0x1f3c3, 0x1f485, 0x1f3c4, 0x1f486, 0x1f487, 0x1f3c7, 0x1f595
};

// EmojiCategory > -printCodepointsForPreset:11
#define genderCodepointsCount 47
static UChar32 genderCodepoints[] = {
    0x1f9d9, 0x1f93d, 0x1f486, 0x1f64d, 0x1f93e, 0x1f487, 0x1f9da, 0x1f6a3, 0x1f64e, 0x1f9cd,
    0x1f9db, 0x1f9dc, 0x1f9ce, 0x1f9dd, 0x1f9cf, 0x1f3c3, 0x1f6b4, 0x1f46e, 0x1f9de, 0x1f3c4,
    0x1f6b5, 0x26f9, 0x1f46f, 0x1f926, 0x1f9df, 0x1f6b6, 0x1f645, 0x1f471, 0x1f646, 0x1f937,
    0x1f647, 0x1f938, 0x1f481, 0x1f473, 0x1f9b8, 0x1f939, 0x1f482, 0x1f9b9, 0x1f9d6, 0x1f3ca,
    0x1f575, 0x1f3cb, 0x1f9d7, 0x1f64b, 0x1f3cc, 0x1f9d8, 0x1f477
};

// EmojiCategory > -printProfessionModifierCodepoints
#define professionCodepointsCount 24
static UChar32 professionCodepoints[] = {
    0x1f9b2, 0x1f3eb, 0x1f4bc, 0x1f4bb, 0x1f33e, 0x2695, 0x1f373, 0x1f527, 0x1f52c, 0x1f393,
    0x1f692, 0x1f9b0, 0x1f9af, 0x1f9b3, 0x1f9bc, 0x1f9b1, 0x2708, 0x1f680, 0x1f3ed, 0x1f3a4,
    0x1f9bd, 0x2696, 0x1f3a8, 0x1f9ba
};