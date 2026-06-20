# Quartz 法学知识库项目文档

## 项目定位

这是一个基于 Quartz 5 的数字花园项目，用于把 `content/` 下的 Obsidian 法学笔记发布为静态网站。

## 分支与远程

- 当前开发分支：`v5`
- 旧版回退分支：`v4`
- 用户仓库：`origin`
- Quartz 官方仓库：`upstream`

`v4` 分支保留完整的 Quartz 4 站点与提交历史。Quartz 5 框架更新从 `upstream/v5` 获取。

## 关键文件

- `content/`：Obsidian vault 与公开站点内容
- `content/index.md`：首页
- `quartz.config.yaml`：Quartz 5 的站点、插件与布局配置
- `quartz.ts`：高级 TypeScript 配置入口
- `quartz/styles/custom.scss`：自定义样式
- `quartz.lock.json`：Quartz 5 插件锁文件
- `scripts/quartz-prepublish-check.sh`：发布前内容检查与构建
- `public/`：构建输出，不提交

Quartz 5 已用 `quartz.config.yaml` 取代 Quartz 4 的 `quartz.config.ts` 与 `quartz.layout.ts`。

## 本地命令

项目要求 Node.js 22+ 与 npm 10.9.2+。

```bash
npm install
./quartz/bootstrap-cli.mjs plugin install --clean
./quartz/bootstrap-cli.mjs build
./quartz/bootstrap-cli.mjs build --serve
npm run quartz:prepublish
```

Quartz 5 的插件位于忽略提交的 `.quartz/` 目录，并由 `quartz.lock.json` 固定版本。新环境或 CI 构建前应先运行：

```bash
./quartz/bootstrap-cli.mjs plugin install --clean
```

## 部署

Cloudflare Pages 建议设置：

```text
Production branch: v5
Framework preset: None
Build command: npm ci && npx quartz plugin install --clean && npx quartz build
Build output directory: public
```

如果使用 Git 提交时间，构建命令前可增加 `git fetch --unshallow &&`。

## 安全与维护

- `content/` 中已提交的文件应视为公开内容。
- `draft: true` 只阻止页面进入站点输出，不阻止文件上传到 GitHub。
- 私密附件应放在 `content/` 外并加入 `.gitignore`。
- 发布前运行 `npm run quartz:prepublish`。
- 不提交 `public/`、`node_modules/`、`.quartz/`、`.obsidian/` 或 `.quartz-cache/`。
