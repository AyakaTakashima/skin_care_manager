# Skinmate
## サービスURL
https://skinmate.fly.dev/

## サービス概要
Skinmate（スキンメイト）というサービスは、下記の問題を解決します。

- いつスキンケア製品がなくなるのかわからないという問題
- 実質、スキンケア製品に月々いくらかかっているのかがわからないという問題

スキンケア製品を多く使っている女性向けの、使用サイクルを管理するアプリです。

## 特徴
ユーザーが Skinmate を利用する前に必要な操作は、スキンケア製品名と価格の登録のみです。
あとは、スキンケア製品の使い始めた日に「使用開始日」、使い切った日に「使用終了日」を登録するだけで下記のことが実現できます。
- いつスキンケア製品がなくなるか把握することができる
- 実質どのくらい月々に化粧品にお金がかかっているかを把握できる

「googleカレンダーにスケジュール登録をして管理する方法」とは、下記の点で異なります。
- 自分が入力した実績から、次回使い切るであろう期間を自動で算出してくれる
- 実質どのくらい月々お金がかかっているかがわかる

## 使い方
### はじめに
下記URLより、新規アカウントを作成します。
https://skinmate.fly.dev/users/sign_up

![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/93d41e92-5394-40db-a815-485ff0bcf99a)


### 1. 製品を登録する

![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/0b453e05-9bb7-4b2f-ae6b-a56f53f4d425)

![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/13cefebb-496a-48ba-86f5-03c45066ce5e)

![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/592222fa-a5a0-43f3-8194-f88c34ba4538)

### 2. 使用開始日を登録する
ボタン「使用開始日を登録する」をクリックします。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/fd119c89-3d35-4868-86cc-cfe24c85953c)

日付を入力します。
入力欄の右端にあるカレンダーマークをクリックすると日付を選択することができます。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/dffba9a9-1bda-4736-ac63-4615ca8125ed)

「使用を開始する」をクリックすると、登録完了です。

### 3. 使用終了日を登録する
ボタン「使用終了日を登録する」をクリックします。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/7f71a322-5456-4bd4-8bc1-727ba21351e9)

日付を入力します。
入力欄の右端にあるカレンダーマークをクリックすると日付を選択することができます。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/97ed3c9b-6b6f-4c16-a070-4578c742cd35)

「使用を終了する」をクリックすると、登録完了です。

### 4. アイテムの詳細を編集/削除する
アイテムの登録内容は、スキンケア製品個別ページ下部にあるボタン「このアイテムを編集する」より可能です。
また、削除をしたい場合は同ページ下部にあるボタン「このアイテムを削除する」より可能です。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/dba7ff1c-b0f1-472d-b8e1-f263f271df22)

### 5. 使用開始日・使用終了日の編集/削除
使用開始日・使用終了日の編集は、スキンケア製品個別ページの鉛筆マークより可能です。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/dba7ff1c-b0f1-472d-b8e1-f263f271df22)

鉛筆マークのボタンをクリックすると編集が可能です。
保存をクリックすると変更内容が保存されます。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/8cb84bae-60ab-491b-9f4f-02926ff751fd)

削除したい場合は、ゴミ箱マークのボタンより削除が可能です。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/c21e137c-36e3-4552-9ef6-4e0eac42d8f3)

### 6. 過去1年間の実績を見る
Skinmate では、過去1年間までの実績を遡って閲覧することができます。
トップページ上部の「過去1年間の実績を見る」から確認できます。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/18bd342e-7191-45f4-b258-351021d0e239)

各月の詳細を見たい場合は、確認したい月をクリックします。
![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/47dc34cb-e2e5-4ef1-b5fb-0499e88c4504)

![image](https://github.com/AyakaTakashima/skin_care_manager/assets/76944527/343bd4cc-69f7-4166-9806-1a5253ef654c)

## 技術スタック
- Ruby 3.1.3
- Rails 7.0.4
- Hotwire
  - Turbo-rails 1.3.2
  - Stimulus-rails 1.2.1
- Slim 4.1.0
- Bootstrap 5.2.3
- Sassc 2.4.0
- Rubocop 1.50.2
- Slim_lint 0.24.0
- Eslint 8.39.0
- Prettier 2.8.8
- PostgreSQL
- GitHub Actions
- Fly.io

## 環境構築
```shell
$ git clone https://github.com/AyakaTakashima/skin_care_manager.git
$ cd skin_care_manager
$ bin/setup
```

## テスト
```shell
$ rails test:all
```

## lint
`bin/lint`で下記コマンド全てを実行できます。個別に実行することも可能です。
```shell
$ bundle exec rubocop -a
$ bundle exec slim-lint app/views -c config/slim_lint.yml
$ npm run -s lint
```
