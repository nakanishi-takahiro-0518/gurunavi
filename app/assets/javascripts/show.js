function showMap() {
  //情報の整理
  let address = gon.address;
  // geocoder APIを使って住所から緯度経度を取得
  let geocoder = new google.maps.Geocoder();
  geocoder.geocode(
    {
      address: address
    },
    function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        for (let i in results) {
          if (results[i].geometry) {
            // 位置情報
            let latlng = results[i].geometry.location;
            // Google Mapsに書き出し
            let map = new google.maps.Map(
              document.getElementById("map-canvas"),
              {
                zoom: 18,
                center: latlng
              }
            );
            // マーカーの新規出力
            new google.maps.Marker({
              map: map,
              position: latlng
            });
          }
        }
      } else {
        // 住所から緯度経度の取得に失敗
        alert("店の住所の取得に失敗しました。");
      }
    }
  );
}
