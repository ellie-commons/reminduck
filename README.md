# ![icon](data/icons/io.github.ellie_commons.reminduck.png) Reminduck

Remember your stuff in an adorably annoying way

<p align="center">
    <img src="data/screenshots/Main.png" alt="Screenshot" />
</p>

Reminduck is a simple reminder app made to be quick and easy - it focuses on simple or recurrent reminders with set time and date and nothing else.

It's perfect if all you want are simple or daily/weekly/monthly reminders. Anything more than that is not achievable by Reminduck right now - but you can help! Open an issue or a pull request if you have any ideas or requests.

_And it quacks._



## 🛣️ Roadmap

 - Currently dusting this off!!! (Help wanted)
 - Setting to have the app quack
 - Request autostart


## 💝 Donations

Original developer is Matt
https://github.com/matfantinel

Currently actively trying to revive this project is me - Stella
Support is always welcome and shows us that people want this work to continue.

Stella, current main dev:
<p align="left">
  <a href="https://ko-fi.com/teamcons">
    <img src="https://cdn.ko-fi.com/cdn/kofi3.png?v=2" width="150">
  </a>
</p>





## 🏗️ Building

Please make sure you have these dependencies first before building Jorts.

```bash
flatpak-builder
libgranite-7-dev
gtk+-4.0
libjson-glib-dev
libgee-0.8-dev
libsqlite3-dev
meson
valac
gettext
```

here are the package names to install:

```bash
sudo apt install libgranite-7-common libsqlite3-dev libgee-0.8-2 meson valac libvala-0.56-0 flatpak-builder gettext
```

Installation is as simple as installing the above, downloading and extracting the zip archive, changing to the new repo's directory,
and run the following command:

On elementary OS or with its appcenter remote installed

```bash
flatpak-builder --force-clean --user --install-deps-from=appcenter --install builddir ./io.github.ellie_commons.reminduck.yml
```

## ACKNOWLEDGMENTS

(NOT YET IMPLEMENTED)
Quack sound: https://pixabay.com/sound-effects/075176-duck-quack-40345/

Sound Effect by <a href="https://pixabay.com/users/freesound_community-46691455/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=40345">freesound_community</a> from <a href="https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=40345">Pixabay</a>


