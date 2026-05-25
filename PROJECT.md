# Quartz 法学知识库项目文档

## 项目定位

这是一个基于 Quartz v4 的数字花园项目，用来把 Markdown/Obsidian 风格的法学笔记、法条整理和课程资料发布为静态网站。

当前仓库同时包含两类内容：

- Quartz 站点生成器本体：位于 `quartz/`、`docs/`、`quartz.config.ts`、`quartz.layout.ts` 等。
- 个人知识库内容：位于 `content/`，主要是法学课程笔记、法条与图片资源。

更准确地说，这不是一个从零写的网站，而是一个“用 Quartz 发布法学笔记”的知识库站点。

## 当前内容概览

核心内容目录是 `content/`。

主要板块包括：

- `content/index.md`：网站首页，目前是中文法学分类卡片导航。
- `content/法学/刑法/`：刑法课程笔记。
- `content/法学/民法/民总/`：民法总论笔记。
- `content/法学/民法/债法/`：债法笔记。
- `content/法学/民法/知识产权/`：知识产权法笔记。
- `content/法学/国际法/`：国际法笔记。
- `content/法学/法理学导论/`：法理学导论笔记。
- `content/法条/`：民商法、刑法、行政处罚法等法条整理。

图片通常放在各课程目录下的 `pics/` 子目录中，由 Markdown 文件引用。

## 关键文件

- `quartz.config.ts`：Quartz 主配置，包括站点标题、语言、主题、插件、RSS、站点地图等。
- `quartz.layout.ts`：页面布局配置，决定左侧导航、搜索、深色模式、右侧目录、关系图、反向链接等组件如何显示。
- `quartz/styles/custom.scss`：自定义样式，目前主要写了首页卡片样式。
- `content/index.md`：首页内容。
- `package.json`：Node 依赖和脚本。
- `public/`：构建输出目录，不需要手动维护，重新构建时会生成。

## 本地运行

项目要求：

- Node.js >= 22
- npm >= 10.9.2

安装依赖：

```bash
npm install
```

构建站点：

```bash
./quartz/bootstrap-cli.mjs build
```

本地预览：

```bash
./quartz/bootstrap-cli.mjs build --serve
```

如果 `npx quartz build` 报 npm cache 权限错误，可以先用上面的直接调用方式绕过。当前机器曾出现过 `~/.npm` 中存在 root-owned 文件的问题，这不是 Quartz 代码错误。

## 常用维护流程

### 添加一篇新笔记

1. 在 `content/` 下选择合适目录。
2. 新建 `.md` 文件。
3. 使用普通 Markdown、Obsidian wikilink、标签或图片引用。
4. 运行构建确认没有明显报错：

```bash
./quartz/bootstrap-cli.mjs build
```

### 添加图片

建议把图片放在对应课程目录的 `pics/` 文件夹中，例如：

```text
content/法学/民法/民总/pics/
```

然后在 Markdown 中用相对路径引用。

### 修改首页

首页文件是：

```text
content/index.md
```

首页卡片样式在：

```text
quartz/styles/custom.scss
```

当前首页还有一些早期生成时留下的注释，例如 `<!-- ... existing code ... -->`，后续可以清理。

## 当前配置状态

这个项目仍有一些 Quartz 默认配置尚未改成个人站点信息：

- `pageTitle` 仍是 `Quartz 4`。
- `baseUrl` 仍是 `quartz.jzhao.xyz`。
- 页脚链接仍指向 Quartz 官方 GitHub 和 Discord。
- `locale` 仍是 `en-US`，如果主要内容是中文，可以考虑改为 `zh-CN`。

建议之后把这些改成自己的站点信息，例如：

```ts
pageTitle: "ChillyChilli 法学笔记"
locale: "zh-CN"
baseUrl: "你的部署域名"
```

`baseUrl` 不要带 `https://`，也不要带开头或结尾斜杠。

## Git 与同步状态

远程仓库：

- `origin`：`https://github.com/chilly-chilli/ChillyChilli.git`
- `upstream`：`https://github.com/jackyzha0/quartz.git`

当前分支是 `v4`。最近检查时，本地 `v4` 比 `origin/v4` 领先 2 个提交，说明有本地内容尚未推送到 GitHub。

维护时要注意：

- 不要随意执行 `git reset --hard`。
- 推送前先运行 `git status` 看清楚当前变更。
- 如果只是发布自己的内容，通常只需要提交和推送 `content/`、`quartz.config.ts`、`quartz.layout.ts`、`quartz/styles/custom.scss` 这类文件。

## 构建情况

最近一次本地构建结果：

- Quartz 版本：v4.5.2
- 输入内容：63 个 Markdown 文件
- 输出目录：`public/`
- 构建结果：成功

构建过程中出现了不少 LaTeX 警告，原因是部分中文内容写在 `$...$` 或 `$$...$$` 数学公式环境里，例如：

```markdown
$$犯罪论+刑罚论=刑法$$
```

这些警告目前不阻止构建，但如果想清理，可以把中文公式改成普通文本、表格、代码块或 Mermaid 图。

## 部署现状

`.github/workflows/` 目前基本沿用 Quartz 官方仓库配置，其中很多 job 带有类似条件：

```yaml
if: ${{ github.repository == 'jackyzha0/quartz' }}
```

这意味着这些 GitHub Actions 在自己的仓库里大概率不会真正运行部署。

如果要恢复自动部署，需要选择一种目标：

- GitHub Pages
- Cloudflare Pages
- Vercel
- Netlify

然后按目标平台改 `.github/workflows/`、`baseUrl` 和构建命令。

## 建议待办

优先级从高到低：

1. 推送本地领先的 2 个提交，避免内容只留在本机。
2. 修改 `quartz.config.ts` 中的站点标题、语言、域名和页脚链接。
3. 清理 `content/index.md` 中的生成痕迹和示例注释。
4. 确认部署平台，并重写对应 GitHub Actions。
5. 清理 Markdown 中误用 `$...$` 包裹中文的地方，减少 LaTeX 警告。
6. 逐步给重要笔记添加 frontmatter、标签和摘要，改善搜索、RSS 与页面元数据。

## 快速命令备忘

查看仓库状态：

```bash
git status --short --branch
```

构建站点：

```bash
./quartz/bootstrap-cli.mjs build
```

本地预览：

```bash
./quartz/bootstrap-cli.mjs build --serve
```

查看最近提交：

```bash
git log --oneline --decorate --graph -8
```

推送当前分支：

```bash
git push origin v4
```

