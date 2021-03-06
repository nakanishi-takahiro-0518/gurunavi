// ユーザーの端末がGeoLocation APIに対応しているかの判定

// 対応している場合
if (navigator.geolocation) {
  // 現在地を取得
  navigator.geolocation.getCurrentPosition(
    // [第1引数] 取得に成功した場合の関数
    function(position) {
      // 取得したデータの整理
      let data = position.coords;

      // データの整理
      let lat = data.latitude;
      let lng = data.longitude;

      // 位置情報
      let latlng = new google.maps.LatLng(lat, lng);
      // Google Mapsに書き出し
      let map = new google.maps.Map(document.getElementById("map-canvas"), {
        zoom: 17, // ズーム値
        center: latlng // 中心座標 [latlng]
      });

      $(".kensaku").append(
        `<input type="hidden" id="id" name="lat" value="${lat}">
        <input type="hidden" id="id" name="lng" value="${lng}">`
      );

      // マーカーの新規出力
      new google.maps.Marker({
        map: map,
        position: latlng
      });
      // 中心からの円の出力
      let circle = new google.maps.Circle({
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 1,
        fillColor: "#FF0000",
        fillOpacity: 0.3,
        map: map,
        center: latlng,
        radius: 500
      });
      // パラメーターの値を受け取れる値に変更
      $(".select").change(function() {
        let hankei = $(this).val();
        let num = 500;
        if (hankei == "1") {
          num = 300;
        } else if (hankei == "2") {
          num = 500;
        } else if (hankei == "3") {
          num = 1000;
        } else if (hankei == "4") {
          num = 2000;
        } else {
          num = 3000;
        }
        updateRadius(circle, num);
      });
    },

    // [第2引数] 取得に失敗した場合の関数
    function(error) {
      // エラーコード(error.code)の番号
      // 0:UNKNOWN_ERROR				原因不明のエラー
      // 1:PERMISSION_DENIED			利用者が位置情報の取得を許可しなかった
      // 2:POSITION_UNAVAILABLE		電波状況などで位置情報が取得できなかった
      // 3:TIMEOUT					位置情報の取得に時間がかかり過ぎた…

      // エラー番号に対応したメッセージ
      let errorInfo = [
        "原因不明のエラーが発生しました…。",
        "位置情報の取得が許可されませんでした…。",
        "電波状況などで位置情報が取得できませんでした…。",
        "位置情報の取得に時間がかかり過ぎてタイムアウトしました…。"
      ];

      // エラー番号
      let errorNo = error.code;
      // エラーメッセージ
      let errorMessage = "[エラー番号: " + errorNo + "]\n" + errorInfo[errorNo];

      // アラート表示
      alert(errorMessage);

      // HTMLに書き出し
      document.getElementById("result").innerHTML = errorMessage;
    },

    // [第3引数] オプション
    {
      enableHighAccuracy: false,
      timeout: 8000,
      maximumAge: 2000
    }
  );
}

// 対応していない場合
else {
  // エラーメッセージ
  let errorMessage = "お使いの端末は、GeoLacation APIに対応していません。";

  // アラート表示
  alert(errorMessage);

  // HTMLに書き出し
  document.getElementById("result").innerHTML = errorMessage;
}

// GoogleMapの半径の変更
function updateRadius(circle, rad) {
  circle.setRadius(rad);
}
