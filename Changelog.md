# Changelog
## June 14th, 2024
### **[MystBlinds | 1.2.3]**
- Fixed **The Bird** juicing up the wrong Joker

## June 4th, 2024
### **[MystBlinds | 1.2.2]**
- Added the mod's icon
- Blacklisted **The Stone** when using **Cryptid**'s Enhanced decks
### **[HouseRules | 1.4.2]**
- Fixed crash when generating card UI

## May 30th, 2024
### **[MystBlinds | 1.2.1]**
- Updated the mod for the latest version of Steamodded
- Fixed **The Ancestor** displaying a higher value than it should
- Reworded **The Food** and **The Fruit**
### **[HouseRules | 1.4.1]**
- Updated the mod for the latest version of Steamodded

# Changelog
## May 20th, 2024
### **[Repo]**
- Removed **Infodumps**, will be moved to a proper wiki in the future
- Removed **RandomSprites**, can still be found in 0.9.8 mod releases
- Deprecated **MystJokers** in favor of a new Joker mod soon:tm:
### **[MystBlinds | 1.2.0]**
- Updated the mod for the latest version of Steamodded
- Added 4 new blinds
- Blinds are no longer automatically discovered
- Fixed **The Ancestor** displaying ``ERROR`` in the collections tab

## May 15th, 2024
### **[Repo]**
- Mods will be versioned from now on
### **[MystBlinds | 1.1.3]**
- Updated to Steamodded 1.0.0
- **The Ancestor** mininum ante **1** > **2**
- **The Insect** now only affects each hand (from whenever cards are drawn)
- Updated code for Blinds that trigger every hand
- **The Monster** and **Noir Silence** should not double their effects with multiple copies of **Chicot** anymore

## May 14th, 2024
### **[HouseRules]**
- Replaced ``HouseRules.lua`` with ``HouseRules_Experimental.lua``

## May 3rd, 2024
### **[MystBlinds]**
- Fixed **The Monster** crashing with **Chicot**

## May 1st, 2024
### **[MystBlinds]**
- Fixed **The Monster** removing consumable slots from **Negative** cards twice

## April 28th, 2024
### **[MystBlinds]**
- Updated the structure of the mod. Now all blinds are split to their own files that can be found in ``indiv_blinds``
- Updated all blinds' shorthands, now all start with ``bl_myst_``
- Now requires **Lovely** to be used
  - Fixes **The Monster** and **Noir Silence** not giving back consumable slots/hand size after defeated
- Added 3 new blinds
- The Market mininum Ante **3** > **2**

## April 27th, 2024
### **[HouseRules | Experimental]**
- Added 3(?) new modifiers
- Updated and optimized some code

## April 22nd, 2024
### **[MystJokers]**
- Updated the structure of the mod. Now all Jokers are split to their own files that can be found in ``indiv_jokers`` *(thanks dps2004)*
- Added four new Jokers
- **Suspicious Joker**: Effect **X0.25** Mult > **X0.5** Mult

## April 17th, 2024
### **[MystJokers]**
- Updated all Joker's shorthands, now all start with ``j_myst_``
- All effects now check for key instead of name
- Added three* new Jokers
- Slightly modified text for **Miracle Milk** and **Suspicious Joker**
- **Polydactyly**, **Options** and **Credits** no longer work when debuffed
- Actually updated cost for **Options** and **Credits**
- **Yield My Flesh**: Effect **X2.5** Mult > **X3** Mult, cost **$6** > **$7**
- **R Key**: 
  - Cost **$15** *(was supposed to be $99 but it didn't work)* > **$40**
  - Sell cost now fixed at **$0**
- Bug fixes
### **[MystBlinds | Steamodded]**
- Updated all functions to ``0.9.8``

## April 10th, 2024
### **[MystBlinds]**
- Fixed crashing on Blinds with the ``set_blind`` function

## April 9th, 2024
### **[HouseRules | Experimental]**
- Reworked UI
  - Now split into pages
  - Each page contains modifiers of each category: Basic, Challenges, Joker, Legacy
- A bunch of internal changes
- Added 7 new modifiers
- Fixes:
  - Perishable Jokers can now appear when "All Jokers are Eternal" is enabled
  - Perishable Jokers can now gain Eternal when "When Ante 4 boss is defeated, all Jokers become Eternal" is enabled

## April 7th, 2024
### **[HouseRules | Experimental]**
- Modifiers button can now be pressed while in Continue tab
- Added 9 more new modifiers

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