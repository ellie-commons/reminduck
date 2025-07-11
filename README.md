<p align="center">
    <img src="data/icons/hicolor/64.png" alt="Icon" />
</p>

<h1 align="center">Reminduck</h1>
<p align="center">Remember your stuff in an adorably annoying way</p>

<p align="center">
  <a href="https://appcenter.elementary.io/io.github.ellie_commons.reminduck">
    <img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" />
  </a>
</p>

<p align="center">
    <img src="data/screenshots/Main.png" alt="Screenshot" />
</p>

Reminduck is a simple reminder app made to be quick and easy - it focuses on simple or recurrent reminders with set time and date and nothing else.

It's perfect if all you want are simple or daily/weekly/monthly reminders. Anything more than that is not achievable by Reminduck right now - but you can help! Open an issue or a pull request if you have any ideas or requests.

_And it quacks._


## 🛣️ Roadmap

 - Change the deprecated widgets
 - Clean everything up a bit and simplify
 - Work on some old bugs


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

On elementary OS or with its appcenter remote installed

```bash
flatpak-builder --force-clean --user --install-deps-from=appcenter --install builddir ./io.github.ellie_commons.reminduck.yml
```

On other systems

```bash
flatpak run org.flatpak.Builder --force-clean --sandbox --user --install --install-deps-from=flathub --ccache --mirror-screenshots-url=https://dl.flathub.org/media/ --repo=repo builddir io.github.ellie_commons.reminduck.flathub.yml
```

## ACKNOWLEDGMENTS

Quack sound: https://pixabay.com/sound-effects/075176-duck-quack-40345/

Sound Effect by <a href="https://pixabay.com/users/freesound_community-46691455/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=40345">freesound_community</a> from <a href="https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=40345">Pixabay</a>
