# Changelog

## April 7th, 2024
### **[HouseRules | Experimental]**
- Modifiers button can now be pressed while in Continue tab
- Added 8 more new modifiers

## April 7th, 2024
*(at literally 12am, again)*
### **[HouseRules]**
- Added

### **[HouseRules]**
- Modified UI so it reads from left to right
- Added 8 new modifiers from base game challenges

## April 5th, 2024
*(at literally 12am)*
### **[MystJokers]**
- Updated to ``0.9.5``
- Rewrote a bunch of code
- **Miracle Milk**: Cost **$5** > **$3**
- **Yield My Flesh**: No longer renames itself due to unsupported by API
- **Autism Creature**: Cost **$5** > **$4**
- **R Key**:
  - No longer disables all future copies
  - Antes reduced **3** > **2**
- **Lucky Seven**: 
  - Cost **$4** > **$3**
  - Now compatible with **Blueprint**
- **Options**: 
  - Cost **$4** > **$5**
  - Now correctly shows as incompatible with **Blueprint**

*(and at 11pm)*
### **[MystJokers]**
- Added two new Jokers
- **Yield My Flesh**: Cost **$7** > **$6**
- **Miracle Milk**: 
  - Effect changed, now "**Undebuff** all scored cards, **+8** Chips per **undebuffed** card"
  - Cost **$3** > **$4**
  - Now **Blueprint** compatible
- **Options**: Rarity **Common** > **Uncommon**
- **Lucky Seven**: Now shows extra information about **The Wheel of Fortune**

## April 3rd, 2024
### **[MystAprilFools]**
- ``blind_overwrite`` now no longer randomizes into **Small Blind** or **Big Blind**

## April 2nd, 2024
### **[MystBlinds | Steamodded]**
- Updated to ``0.9.2+``
- Deprecated **BlindCollectionPatch**
### **[MystAprilFools]**
- idk how it got here

## March 23rd, 2024
### **[MystBlinds]**
- **Cartomancer** no longer generate cards during **The Monster**
- Reworded **The Insect**: *after each hand* > *whenever cards are drawn*
  - Actual effect unchanged
- Added a check for **BlindCollectionPatch** that makes the mod not load if the patch is not found
- Changed version to **v1.0.1** for ``Balamod``
### **[Repo]**
- Separated **MystBlinds** and **BlindCollectionPatch**
  - ``MystBlinds.zip`` in **Releases** still have both bundled

## March 21st, 2024
### **[Repo]**
- Added **MystBlinds** to ``Steamodded``
- Mods can now be downloaded individually [here](https://github.com/Mysthaps/BalatroMods/releases/tag/Steamodded)
  - Balamod mods can be downloaded via its Marketplace

## March 18th, 2024
### **[Repo]**
- Added **MystBlinds** to ``Balamod``
- Added ``Infodumps``, which contains information about **MystJokers** and **MystBlinds**
- Added images to ``Jokers.md``

## March 13th, 2024
### **[MystJokers]**
- Added **Options**
- Recoded **Polydactyly** - should stop crashes relating to ``extra_gacha_pulls`` now

## March 8th, 2024
### **[MystJokers]**
- Fixed **Polydactyly** permanently increasing the amount of options after buying any **Booster Pack**

## March 6th, 2024

### **[Repo]**
- Added ``Changelog.md``
### **[GoldenChallenge]**
- Removed all card blacklists, save for **Vampire**
- The starting **Midas Mask** is now **Negative**
### **[MystJokers]**
- Update to use the Joker API's atlas introduced in **Steamodded 0.7.2**
- Added failsave for **Polydactyly**'s effect
- Added **Lucky Seven**