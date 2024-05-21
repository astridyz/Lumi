---
sidebar_position: 2
---

# Installation
In order to use Lumi, you will need to follow some steps: 

### Download the Luau Runtime (Lune)

First, you need to download the Luau runtime, also known as Lune. Lumi is built on top of Luau, so having the Luau runtime installed is a prerequisite for using Lumi. ✨

To download Lune, [check their official website.](https://lune-org.github.io/docs/getting-started/1-installation)

:::info Language server
  In order to have a working IDE with Luau, you have to download luau lsp. [Check it here.](https://github.com/JohnnyMorganz/luau-lsp)
:::

:::tip Editor setup
  We recommend [you to check this page](https://lune-org.github.io/docs/getting-started/4-editor-setup) to set up Lune types and built-in libraries.
:::

### Install Lumi via GitHub Submodules

Once you have the Luau runtime installed, you can proceed to install Lumi using GitHub submodules. GitHub submodules are repositories nested inside other repositories. You chan check more about them [here.](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

To add Lumi as a submodule in your project repository, follow these steps:

- Navigate to your project repository

- In order to add Lumi as a submodule in your repository, run the following commands:

```
$ git submodule add https://github.com/astridyz/Lumi.git libs/Lumi
$ git submodule init
```

- Keep track of Lumi updates:

```
$ git submodule update
```

:::tip Gitignore
  We recommend you to add `/libs` to your .gitignore file.
:::

- Require Lumi folder in your `file.lua`:

```lua
--[[
    Assuming the given root:
    libs/
      Lumi/
    src/
      file.lua
]]

local Lumi = require('../libs/Lumi')
```