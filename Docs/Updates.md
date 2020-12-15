# Updates
Updates, bugfixes and new stuff

## 15 Dec 2020 [11:09 CET]
### The Fun Update.md Commit Naming Update
**By: [TheCasachii](https://github.com/TheCasachii)**

Updated: file structure, README.md, Updates.md, Syntax.md

Updates:
- Updated file structure to use directories
- Fixed binary code for CALLPTR in Syntax.md (0x1c => 0x1d)

Additions:
- Given unique codenames to updates in Updates.md
- Added commit IDs to Updates.md (ID of the latest commit will be added with the next one)
- Added HLT to command list in Syntax.md
- Added documentation for HLT in Syntax.md
- Added [Alphabet Injection](Alphabet-Injection.md) reference in README

## 14 Dec 2020 (take 3) [20:56 CET]
### The 8-hours-of-work-on-one-bug Update
**By: [TheCasachii](https://github.com/TheCasachii)**
Commit #d3289c7d6a5927e81c7f0668da8d6348a8022c4f

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
### Bugfixes for The Buggy Update
**By: [TheCasachii](https://github.com/TheCasachii)**
Commits #2f8ac792952ac5eead32c396984f7fcb2b10b4cc, #b76f192b699c40e6203e7ae32fda4d38d1a38d6b

Updated: nox_lang.rb, Syntax.md

Bug fixes:
- Fixed addressing system used by CALLPTR.
- Fixed pseudo-code implementation of CALLPTR in Syntax.

## 14 Dec 2020 [11:26 CET]
### The Buggy Update
**By: [TheCasachii](https://github.com/TheCasachii)**
Commit #9296d232c1210030a19957afbe4a0912c777be98

Updated: nox_lang.rb, Syntax.md

Bug fixes:
- Fixed typo in LEGAL_COMMANDS: `%w[... cpy, ...]` => `%w[... cpy ...]`. The CPY command is now correctly handled.

Additions:
- Added new command: CALLPTR. See [Syntax](Syntax.md#callptr) for details.
