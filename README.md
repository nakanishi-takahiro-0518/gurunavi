### デプロイ
- https://takahirogurunavi.herokuapp.com/
- 2020/10/07にアクセスキーの有効期限が切れました。
- 2021/06/30よりぐるなびAPIの利用が有料になります。
### 使用上の注意
- アプリケーション直下に.envファイルを作成し、以下の記述をする必要があります。
```
GNAVI_API_KEY = '取得したぐるなびのAPIキー'
GOOGLE_MAPS_API_KEY = '取得したgooglemapのAPIキー'
```
### 対象OS
- 特になし
### 対象ブラウザ
- Chromeで確認済み
### 開発環境/言語
- vagrant  
- virtualbox  
- VScode(Visual Stadio Code)  
- ruby 2.5.7  
- ruby on rails 5.2.4.1  
- JavaScript(ES6)  

## 機能一覧
- Google Map  
> Geolocation APIを使用し取得した結果をGoogle Mapに反映する。  
- レストラン検索  
> ぐるなびレストラン検索APIを使用し、現在地周辺の飲食店を検索する。  
- レストラン情報取得  
> ぐるなびレストラン検索APIを使用し、飲食店の詳細情報を取得する。
  
## 画面一覧
- 検索画面  
> 条件を指定し、レストランを検索する。  
- 一覧画面  
> 検索結果の飲食店を一覧表示する。  
- 詳細画面  
> 選択した飲食店の詳細情報を表示する。
  
## 使用しているAPI,SDKなど
- ぐるなびレストラン検索API  
- Geolocation API  
- Maps JavaScript API  
- Geocoding API  

