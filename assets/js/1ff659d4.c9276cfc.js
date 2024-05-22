"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[553],{3905:(e,t,n)=>{n.d(t,{Zo:()=>p,kt:()=>b});var o=n(67294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);t&&(o=o.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,o)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,o,r=function(e,t){if(null==e)return{};var n,o,r={},i=Object.keys(e);for(o=0;o<i.length;o++)n=i[o],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(o=0;o<i.length;o++)n=i[o],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var u=o.createContext({}),s=function(e){var t=o.useContext(u),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},p=function(e){var t=s(e.components);return o.createElement(u.Provider,{value:t},e.children)},m="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return o.createElement(o.Fragment,{},t)}},c=o.forwardRef((function(e,t){var n=e.components,r=e.mdxType,i=e.originalType,u=e.parentName,p=l(e,["components","mdxType","originalType","parentName"]),m=s(n),c=r,b=m["".concat(u,".").concat(c)]||m[c]||d[c]||i;return n?o.createElement(b,a(a({ref:t},p),{},{components:n})):o.createElement(b,a({ref:t},p))}));function b(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var i=n.length,a=new Array(i);a[0]=c;var l={};for(var u in t)hasOwnProperty.call(t,u)&&(l[u]=t[u]);l.originalType=e,l[m]="string"==typeof e?e:r,a[1]=l;for(var s=2;s<i;s++)a[s]=n[s];return o.createElement.apply(null,a)}return o.createElement.apply(null,n)}c.displayName="MDXCreateElement"},57784:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>u,contentTitle:()=>a,default:()=>d,frontMatter:()=>i,metadata:()=>l,toc:()=>s});var o=n(87462),r=(n(67294),n(3905));const i={sidebar_position:2},a="Installation",l={unversionedId:"Installation",id:"Installation",title:"Installation",description:"In order to use Lumi, you will need to follow some steps:",source:"@site/docs/Installation.md",sourceDirName:".",slug:"/Installation",permalink:"/Lumi/docs/Installation",draft:!1,editUrl:"https://github.com/astridyz/Lumi/edit/main/docs/Installation.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"defaultSidebar",previous:{title:"Lumi",permalink:"/Lumi/docs/intro"},next:{title:"Application bot",permalink:"/Lumi/docs/GettingStarted/Application"}},u={},s=[{value:"Download the Luau Runtime (Lune)",id:"download-the-luau-runtime-lune",level:3},{value:"Install Lumi via GitHub Submodules",id:"install-lumi-via-github-submodules",level:3}],p={toc:s},m="wrapper";function d(e){let{components:t,...n}=e;return(0,r.kt)(m,(0,o.Z)({},p,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"installation"},"Installation"),(0,r.kt)("p",null,"In order to use Lumi, you will need to follow some steps: "),(0,r.kt)("h3",{id:"download-the-luau-runtime-lune"},"Download the Luau Runtime (Lune)"),(0,r.kt)("p",null,"First, you need to download the Luau runtime, also known as Lune. Lumi is built on top of Luau, so having the Luau runtime installed is a prerequisite for using Lumi. \u2728"),(0,r.kt)("p",null,"To download Lune, ",(0,r.kt)("a",{parentName:"p",href:"https://lune-org.github.io/docs/getting-started/1-installation"},"check their official website.")),(0,r.kt)("admonition",{title:"Language server",type:"info"},(0,r.kt)("p",{parentName:"admonition"},"  In order to have a working IDE with Luau, you have to download luau lsp. ",(0,r.kt)("a",{parentName:"p",href:"https://github.com/JohnnyMorganz/luau-lsp"},"Check it here."))),(0,r.kt)("admonition",{title:"Editor setup",type:"tip"},(0,r.kt)("p",{parentName:"admonition"},"  We recommend ",(0,r.kt)("a",{parentName:"p",href:"https://lune-org.github.io/docs/getting-started/4-editor-setup"},"you to check this page")," to set up Lune types and built-in libraries.")),(0,r.kt)("h3",{id:"install-lumi-via-github-submodules"},"Install Lumi via GitHub Submodules"),(0,r.kt)("p",null,"Once you have the Luau runtime installed, you can proceed to install Lumi using GitHub submodules. GitHub submodules are repositories nested inside other repositories. You chan check more about them ",(0,r.kt)("a",{parentName:"p",href:"https://git-scm.com/book/en/v2/Git-Tools-Submodules"},"here.")),(0,r.kt)("p",null,"To add Lumi as a submodule in your project repository, follow these steps:"),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("p",{parentName:"li"},"Navigate to your project repository;")),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("p",{parentName:"li"},"In order to add Lumi as a submodule in your repository, run the following commands:"))),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"$ git submodule add https://github.com/astridyz/Lumi.git libs/Lumi\n$ git submodule init\n")),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},"Keep track of Lumi updates:")),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"$ git submodule update\n")),(0,r.kt)("admonition",{title:"Gitignore",type:"tip"},(0,r.kt)("p",{parentName:"admonition"},"  We recommend you to add ",(0,r.kt)("inlineCode",{parentName:"p"},"/libs")," to your .gitignore file.")),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("p",{parentName:"li"},"Create your source folder and add a file ",(0,r.kt)("inlineCode",{parentName:"p"},"bot.lua")," in it.")),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("p",{parentName:"li"},"Require Lumi folder in your ",(0,r.kt)("inlineCode",{parentName:"p"},"bot.lua"),":"))),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},"--[[\n    Assuming the given root:\n    libs/\n      Lumi/\n    src/\n      bot.lua\n]]\n\nlocal Lumi = require('../libs/Lumi')\n")))}d.isMDXComponent=!0}}]);