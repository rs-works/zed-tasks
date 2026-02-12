# zed-tasks

Zed エディタで使用するカスタムタスクを管理するリポジトリです。

## 概要

[Zed](https://zed.dev/) の Tasks 機能を使って、GitHub でのファイル表示や Terraform Registry の参照などをエディタから素早く実行できます。

## 設定方法

1. このリポジトリをクローンします

```sh
git clone https://github.com/rs-works/zed-tasks.git
```

2. スクリプトを Zed の設定ディレクトリにコピーします

```sh
cp -r tasks/ ~/.config/zed/tasks/
chmod +x ~/.config/zed/tasks/*.sh
```

3. `tasks.json` を Zed の設定ディレクトリにコピーします

```sh
cp tasks.json ~/.config/zed/tasks.json
```

## タスク一覧

| タスク名 | 説明 |
|----------|------|
| `github-open` | 現在開いているファイルを GitHub 上で開く（現在のブランチ） |
| `github-open-master` | 現在開いているファイルを GitHub 上で開く（`master` ブランチ固定） |
| `github-history` | 現在開いているファイルのコミット履歴を GitHub 上で表示する（現在のブランチ） |
| `github-history-master` | 現在開いているファイルのコミット履歴を GitHub 上で表示する（`master` ブランチ固定） |
| `terraform-lookup` | カーソル位置にある Terraform リソース / データソースの定義を Terraform Registry で開く（`.tf` ファイル上で実行） |

## 使い方

`cmd-shift-p` でコマンドパレットを開き、`task: spawn` を選択するとタスク一覧が表示されます。実行したいタスクを選んでください。

## 注意事項

`task: rerun` で直前のタスクを再実行する場合、**タスク起動時の `$ZED_FILE` / `$ZED_ROW` / `$ZED_COLUMN` がそのまま再利用されます**。別のファイルやカーソル位置に移動した後に rerun しても、最初に実行したときの値が使われるため意図した動作になりません。別のファイルで実行したい場合は `task: spawn` から再度タスクを選択してください。

## 使用可能な Zed 環境変数

https://zed.dev/docs/tasks


| 変数 | 内容 |
|------|------|
| `$ZED_FILE` | 現在開いているファイルの絶対パス |
| `$ZED_FILENAME` | 現在開いているファイルのファイル名のみ（例: `main.rs`） |
| `$ZED_DIRNAME` | 現在開いているファイルのディレクトリの絶対パス |
| `$ZED_RELATIVE_FILE` | ワークツリールートからのファイルの相対パス |
| `$ZED_RELATIVE_DIR` | ワークツリールートからのディレクトリの相対パス |
| `$ZED_STEM` | 拡張子を除いたファイル名 |
| `$ZED_ROW` | カーソルの行番号 |
| `$ZED_COLUMN` | カーソルの列番号 |
| `$ZED_SYMBOL` | 現在選択されているシンボル |
| `$ZED_SELECTED_TEXT` | 現在選択されているテキスト |
| `$ZED_WORKTREE_ROOT` | 現在のワークツリールートの絶対パス |
| `$ZED_CUSTOM_RUST_PACKAGE` | （Rust 専用）親パッケージの名前 |
