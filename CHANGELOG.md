# Changelog

## [3.1.0](https://github.com/nat-418/grimoire/compare/v3.0.0...v3.1.0) (2024-04-17)


### Features

* **lmt:** init at version 0.0.0 ([eb1073c](https://github.com/nat-418/grimoire/commit/eb1073c3a78f4d2bba4520e4be4ff33ac58a7701))
* **micropicolisp:** init at 2018-09-30 ([e81b180](https://github.com/nat-418/grimoire/commit/e81b180988ddb6e8ddca8cc16531e9e70fc8440d))


### Bug Fixes

* **picolisp:** add missing executables ([4535b6f](https://github.com/nat-418/grimoire/commit/4535b6f25ab29ec0a24a4367640ecd858efc1665))
* **picolisp:** update URL etc. ([1c637ed](https://github.com/nat-418/grimoire/commit/1c637ed499735de3f82e3736050e5a64a54339a1))

## [3.0.0](https://github.com/nat-418/grimoire/compare/v2.0.0...v3.0.0) (2024-04-11)


### ⚠ BREAKING CHANGES

* **take:** bump to version 1.0.0
* **take:** remove arbitrary system command support

### Features

* add clonetrees pkg ([48ce06a](https://github.com/nat-418/grimoire/commit/48ce06ae010009b980677eaece34bb937defdd3c))
* add hogs package ([c497378](https://github.com/nat-418/grimoire/commit/c497378864b68d04da898d06d62f16eea2c9120e))
* add picolisp unstable ([4da2864](https://github.com/nat-418/grimoire/commit/4da2864c40a4758c0331207428e31b562ebb8b58))
* migrate from flakes to channel ([928e0b5](https://github.com/nat-418/grimoire/commit/928e0b568400e50a94aafac70e18635f1c3cfe56))


### Bug Fixes

* add ssh to clonetrees pkg ([8a0cb2f](https://github.com/nat-418/grimoire/commit/8a0cb2f835e50a1c3de9486da15fbb51096dee49))
* **picolisp:** add manpages ([5042aa7](https://github.com/nat-418/grimoire/commit/5042aa7ba2cee7c40b570e6862e45d900acd8d76))
* **take:** bump to version 1.0.0 ([48efa36](https://github.com/nat-418/grimoire/commit/48efa36d15280b52dca1fa9241871b7916c910d5))
* **take:** remove arbitrary system command support ([fec6212](https://github.com/nat-418/grimoire/commit/fec621255e4f05059020c29b006e1d1e319fe450))

## [2.0.0](https://github.com/nat-418/grimoire/compare/v1.1.0...v2.0.0) (2022-11-07)


### ⚠ BREAKING CHANGES

* update experimental flake

### Features

* add experimental flake ([58810b5](https://github.com/nat-418/grimoire/commit/58810b5eaf93d55af0e19d55f4ab25bcba619a95))


### Bug Fixes

* **take:** improve flag handling ([977bc5c](https://github.com/nat-418/grimoire/commit/977bc5c35e6dd51b5b18e8a284278d27051e1f48))


### Build System

* update experimental flake ([874c737](https://github.com/nat-418/grimoire/commit/874c737bc43ef4f8f1550fad33cedb4f2fe4b346))

## [1.1.0](https://github.com/nat-418/grimoire/compare/v1.0.0...v1.1.0) (2022-11-01)


### Features

* **dotctl:** add dotctl git dotfile manager ([5a79df9](https://github.com/nat-418/grimoire/commit/5a79df9590aef1c9daab500e0777c37a38a56d98))
* **dotctl:** add help and misc. improvements ([29d98e2](https://github.com/nat-418/grimoire/commit/29d98e27e43e47860a4b2375c48f0c8a311e8a90))
* **gnb:** add `tag` subcommand ([37e1132](https://github.com/nat-418/grimoire/commit/37e1132731d1ed5e0eb667ca10381d7817013908))
* **gnb:** add gnb.tcl ([bb74d42](https://github.com/nat-418/grimoire/commit/bb74d42f2f011e339d334d63f3521c05cdd49a2b))
* **gnb:** add parsing and pretty printing of logs ([b0c82f5](https://github.com/nat-418/grimoire/commit/b0c82f5507135dde10f6ba0a4aa2b200d9a27f0f))
* **gnb:** better-looking search and last output ([9dcd5a7](https://github.com/nat-418/grimoire/commit/9dcd5a78c79a859e0af981ed83881a5e476b8c8e))
* **gnb:** improve first-time setup experience ([d1a0a00](https://github.com/nat-418/grimoire/commit/d1a0a0056f852fd5f06c6e9c0d19774748b743d8))
* **gnb:** improve output formatting ([55d1e23](https://github.com/nat-418/grimoire/commit/55d1e2319b2bf68b496bfba975011498dbe0aead))
* initial commit ([c061e91](https://github.com/nat-418/grimoire/commit/c061e91e89d74430801c0247aaa0b16f091d8301))
* **take:** add --list flag to take ([e8795f0](https://github.com/nat-418/grimoire/commit/e8795f042fc8d7a803a0eb979d3d250585b4237d))


### Bug Fixes

* **gnb:** add better error handling ([4d2ea65](https://github.com/nat-418/grimoire/commit/4d2ea6561f7a89ccc1b462aac4b5fa2b65df96d1))
* **gnb:** correctly quote text passed to `add` ([b50b369](https://github.com/nat-418/grimoire/commit/b50b3699902a492fac3bd47e3630a7bfe0bb7e43))
* **gnb:** fix log formatting ([b9bec44](https://github.com/nat-418/grimoire/commit/b9bec44f5b7581938c54938156460466421cff24))
* revert bad nagelfar config ([45597f4](https://github.com/nat-418/grimoire/commit/45597f45fb9623e300e1a55fb4121c2f0f4f5759))

## 1.0.0 (2022-11-01)


### Features

* **dotctl:** add dotctl git dotfile manager ([5a79df9](https://github.com/nat-418/grimoire/commit/5a79df9590aef1c9daab500e0777c37a38a56d98))
* **dotctl:** add help and misc. improvements ([29d98e2](https://github.com/nat-418/grimoire/commit/29d98e27e43e47860a4b2375c48f0c8a311e8a90))
* **gnb:** add `tag` subcommand ([37e1132](https://github.com/nat-418/grimoire/commit/37e1132731d1ed5e0eb667ca10381d7817013908))
* **gnb:** add gnb.tcl ([bb74d42](https://github.com/nat-418/grimoire/commit/bb74d42f2f011e339d334d63f3521c05cdd49a2b))
* **gnb:** add parsing and pretty printing of logs ([b0c82f5](https://github.com/nat-418/grimoire/commit/b0c82f5507135dde10f6ba0a4aa2b200d9a27f0f))
* **gnb:** better-looking search and last output ([9dcd5a7](https://github.com/nat-418/grimoire/commit/9dcd5a78c79a859e0af981ed83881a5e476b8c8e))
* **gnb:** improve first-time setup experience ([d1a0a00](https://github.com/nat-418/grimoire/commit/d1a0a0056f852fd5f06c6e9c0d19774748b743d8))
* **gnb:** improve output formatting ([55d1e23](https://github.com/nat-418/grimoire/commit/55d1e2319b2bf68b496bfba975011498dbe0aead))
* initial commit ([c061e91](https://github.com/nat-418/grimoire/commit/c061e91e89d74430801c0247aaa0b16f091d8301))
* **take:** add --list flag to take ([e8795f0](https://github.com/nat-418/grimoire/commit/e8795f042fc8d7a803a0eb979d3d250585b4237d))


### Bug Fixes

* **gnb:** add better error handling ([4d2ea65](https://github.com/nat-418/grimoire/commit/4d2ea6561f7a89ccc1b462aac4b5fa2b65df96d1))
* **gnb:** correctly quote text passed to `add` ([b50b369](https://github.com/nat-418/grimoire/commit/b50b3699902a492fac3bd47e3630a7bfe0bb7e43))
* **gnb:** fix log formatting ([b9bec44](https://github.com/nat-418/grimoire/commit/b9bec44f5b7581938c54938156460466421cff24))
* revert bad nagelfar config ([45597f4](https://github.com/nat-418/grimoire/commit/45597f45fb9623e300e1a55fb4121c2f0f4f5759))

## 0.1.0 (2022-10-29)


### Features

* initial commit ([c4960db](https://github.com/nat-418/grimoire/commit/c4960db55d5bf16e007a89ba07e2beea65ff0de2))
* **take:** add --list flag to take ([e8644f8](https://github.com/nat-418/grimoire/commit/e8644f88d7a128f8d074ccd86646cbea12a34cbe))
