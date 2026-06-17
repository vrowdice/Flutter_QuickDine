# QuickDine

[English](README.md) | **日本語**

[ホットペッパーグルメサーチ API](https://webservice.recruit.co.jp/hotpepper/gourmet/v1/) と **Google マップ** を使い、**日本国内**の周辺飲食店を探す Flutter アプリです。地図上で検索地点を選び、条件を絞って一覧・詳細を表示。お気に入り、クイックピン、多言語 UI に対応しています。

![Flutter](https://img.shields.io/badge/Flutter-3.12+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)

---

## 主な機能

| カテゴリ | 内容 |
|----------|------|
| **地図検索** | 全画面 Google マップ。タップで検索中心を指定。GPS で現在地取得 |
| **HotPepper 検索** | 半径 300 m〜3000 m（5 段階）、1 回あたり最大 10〜100 件 |
| **フィルタ** | ジャンル（居酒屋・ラーメン等）、駐車場あり、個室あり |
| **結果表示** | 地図マーカー + ドラッグ可能なボトムシート一覧（店名・アクセス・サムネイル） |
| **詳細** | 写真、ジャンル/キャッチ、予算、住所、営業時間、アクセス。電話・Web リンク |
| **クイックピン** | よく使う地点に名前を付けて保存、ワンタップで移動 |
| **お気に入り** | 端末内に店舗を保存（`shared_preferences`） |
| **設定** | デフォルト半径・件数、表示言語（システム / 韓国語 / 日本語 / 英語）、データ削除 |
| **クレジット** | API データ・画像画面にホットペッパー公式表記を表示 |
| **多言語・フォント** | UI は ko / ja / en。Noto Sans / Noto Sans KR / Noto Sans JP |

> **注意:** HotPepper は **日本国内の座標** のみ有効です。海外からテストする場合は、地図を日本の地点（例：東京駅）に移動するか、クイックピンを利用してください。

---

## 画面構成

```
スプラッシュ → 検索（地図ハブ） → 詳細
                    ↓
              お気に入り / 設定
```

- **検索** — 地図、上部検索パネル、下部 Pill 検索ボタン、結果シート、クイックピンパネル  
- **詳細** — 店舗情報、お気に入り、地図で表示、電話 / HotPepper Web  
- **お気に入り** — 保存済み店舗一覧  
- **設定** — デフォルト値、言語、データ一括削除  

---

## 技術スタック

| 項目 | 内容 |
|------|------|
| フレームワーク | Flutter / Dart ^3.12.1 |
| 外部 API | ホットペッパーグルメサーチ API、Google Maps SDK |
| 主要パッケージ | `http`, `geolocator`, `google_maps_flutter`, `flutter_dotenv`, `shared_preferences`, `url_launcher`, `google_fonts` |
| ローカル保存 | `shared_preferences`（お気に入り、クイックピン、設定） |
| パッケージ ID | `com.vrowdice.quick_dine` |

---

## 必要環境

- [Flutter SDK](https://docs.flutter.dev/get-started/install)（Dart ^3.12.1）
- Android Studio および / または Xcode
- [ホットペッパー API キー](https://webservice.recruit.co.jp/)（リクルート Web サービス）
- [Google Maps API キー](https://console.cloud.google.com/)（**Maps SDK for Android / iOS** を有効化）

---

## セットアップ

### 1. クローンと依存関係

```bash
git clone <リポジトリ URL>
cd QuickDine
flutter pub get
```

### 2. API キーの設定

`assets/env` は **Git 管理外** です。テンプレートから作成してください。

**Windows（PowerShell）**

```powershell
copy assets\env.example assets\env
```

**macOS / Linux**

```bash
cp assets/env.example assets/env
```

`assets/env` を編集:

```env
HOTPEPPER_API_KEY=your_hotpepper_key
GOOGLE_MAPS_API_KEY=your_google_maps_key
```

| キー | 用途 |
|------|------|
| `HOTPEPPER_API_KEY` | グルメサーチ API |
| `GOOGLE_MAPS_API_KEY` | 地図表示 |

**Google Maps キーの連携**

- **Android** — ビルド時に Gradle が `assets/env` を読み、`AndroidManifest.xml` へ注入
- **iOS** — 起動時に `MapsKeyService` が `assets/env` の値をネイティブへ渡す

ローカル開発では **`assets/env` のみ** メンテナンスすれば足ります。実キーはコミットしないでください。

### 3. 実行

```bash
flutter devices
flutter run
```

GPS 検索には **位置情報の許可** が必要です。

---

## プロジェクト構成

```
lib/
  main.dart                 # エントリポイント
  app.dart                  # MaterialApp、テーマ、ロケール
  screens/                  # splash, search, detail, favorites, settings
  widgets/                  # 地図、ボトムシート、クレジット、検索 UI
  services/                 # API、GPS、お気に入り、クイックピン、設定、bootstrap
  models/                   # Shop, QuickPin
  constants/                # API URL、半径、件数、ジャンルコード
  theme/                    # ブランドカラー + Noto フォント
  l10n/                     # 多言語（ko / ja / en）
assets/
  env.example               # API キーテンプレート（コミット対象）
  env                       # 実キー（gitignore）
  images/                   # アプリアイコン、スタジオロゴ
agents/                     # エージェント向けドキュメント（英語）
簡易仕様書_QuickDine.txt      # 詳細仕様書（日本語）
```

---

## 採点・確認用デモ手順

1. 起動 → スプラッシュ → 検索画面（地図表示）  
2. 地図を **日本国内** の座標へ移動（日本にいる場合は GPS 可）  
3. 半径・取得件数を設定。必要ならジャンル、駐車場、個室フィルタ  
4. 下部の **検索** Pill をタップ → 地図マーカー + ボトムシート一覧  
5. 店舗を開く → 詳細。電話・Web があれば試す  
6. お気に入り登録。**設定** で言語切替を確認  

---

## ホットペッパー クレジット（必須）

API データまたは画像を表示する画面には、[リクルート Web サービス](https://webservice.recruit.co.jp/) の利用規約に従った表記が必要です。UI 変更時も `ScreenWithCredit` および `HotPepperImageCredit` を削除しないでください。

---

## トラブルシューティング

| 症状 | 確認事項 |
|------|----------|
| HotPepper キーエラー | `assets/env` が存在し、`HOTPEPPER_API_KEY` が placeholder でない |
| 地図が灰色 / 空白 | `assets/env` の Maps キー、SDK 有効化、GCP 課金設定 |
| 検索 0 件 | 座標が日本国内か、半径を広げる |
| GPS エラー | 端末の位置情報 ON、アプリ権限、iOS `Info.plist` の usage 文字列 |

---

## 関連ドキュメント

| ファイル | 言語 | 内容 |
|----------|------|------|
| [README.md](README.md) | English | 英語版 README |
| [簡易仕様書_QuickDine.txt](簡易仕様書_QuickDine.txt) | 日本語 | 簡易仕様書・設計判断の詳細 |
| [agents/INDEX.md](agents/INDEX.md) | English | コントリビュータ / エージェント索引 |

---

## 作者

**Vrowdice**

---

## ライセンス

非公開 / 課題用プロジェクト（`publish_to: 'none'`）。
