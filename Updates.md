# Updates
Updates, bugfixes and new stuff

## 14 Dec 2020 (take 3) [20:56 CET]
**By: [TheCasachii](https://github.com/TheCasachii)**

*This update happened after I realized I can make larger commits more rarely ;)*

Updated: nox_lang.rb, Update.md

Updates:
- Fixed an unfortunate paste (https://ctflearn.com if you don't know what I mean)
- Updated the layout of Updates.md (this file) to make new updates appear at the top (instead of the bottom)
- Split updates in Update.md by categories (Updates, Additions, Bug fixes)
- Removed unused variable declaration in nox_lang.rb

Additions:
- Added comments in source code to improve readability (nox_lang.rb)
- Added timestamps to Updates.md

Bug fixes:
- Fixed the bug where compiler would crash when program is too long

## 14 Dec 2020 (take 2) [11:37 CET]
**By: [TheCasachii](https://github.com/TheCasachii)**

Updated: nox_lang.rb, Syntax.md

Bug fixes:
- Fixed addressing system used by CALLPTR.
- Fixed pseudo-code implementation of CALLPTR in Syntax.

## 14 Dec 2020 [11:26 CET]
**By: [TheCasachii](https://github.com/TheCasachii)**

Updated: nox_lang.rb, Syntax.md

Bug fixes:
- Fixed typo in LEGAL_COMMANDS: `%w[... cpy, ...]` => `%w[... cpy ...]`. The CPY command is now correctly handled.

Additions:
- Added new command: CALLPTR. See [Syntax](Syntax.md#callptr) for details.
