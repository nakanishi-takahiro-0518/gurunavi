class Restaurant
    include ActiveModel::Model

    # indexのリクエスト
    def self.search(lat, lng, range, freeword, no_smoking, card, bottomless_cup, buffet, parking, wifi)
        uri = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
        access_key = ENV['GNAVI_API_KEY']
        url = uri << "?keyid=" << access_key << "&hit_per_page=100"  << "&latitude=" << lat << "&longitude=" << lng << "&range=" << range
        # 各パラメータが送られていたらURLを上書き
        if freeword != ""
            url = url << "&freeword=" << freeword
        end

        if no_smoking != nil
            url = url << "&no_smoking=" << no_smoking
        end

        if card != nil
            url = url << "&card=" << card
        end

        if bottomless_cup != nil
            url = url << "&bottomless_cup=" << bottomless_cup
        end

        if buffet != nil
            url = url << "&buffet=" << buffet
        end

        if parking != nil
            url = url << "&parking=" << parking
        end

        if wifi != nil
            url = url << "&wifi=" << wifi
        end

        require 'open-uri'
        require 'net/http'
        require 'json'
        require 'active_support'
        require 'active_support/core_ext'

        url = URI.encode url
        re_url = URI.parse(url)
        json = Net::HTTP.get(re_url)
        hash = JSON.parse(json)
        shops = []
        # 条件に合う店の情報の取得を配列shopsに入れる
        if hash.has_key?("rest")
            hash["rest"].each do |shop|
                shops.push({
                    id: shop["id"],
                    name: shop["name"],
                    access_line: shop["access"]["line"],
                    access_station: shop["access"]["station"],
                    access_exit: shop["access"]["station_exit"],
                    access_walk: shop["access"]["walk"],
                    access_note: shop["access"]["note"],
                    category: shop["category"],
                    budget: shop["budget"],
                    image: shop["image_url"]["shop_image1"]
                })
            end
            return shops
                # エラーが返ってきた処理
        elsif hash.has_key?("error")

                if hash["error"].first["code"] == 400
                    error = "不正なパラメーターが指定されました。"
                elsif hash["error"].first["code"] == 401
                    error = "不正なアクセス（認証エラー）です。"
                elsif hash["error"].first["code"] == 404
                    error = "指定された店舗の情報が存在しません。"
                elsif hash["error"].first["code"] == 405
                    error = "不正なアクセスです。"
                elsif hash["error"].first["code"] == 429
                    error = "リクエスト可能な上限回数を超過しました。"
                elsif hash["error"].first["code"] == 500
                    error = "処理中にエラーが発生しました。"
                else
                    error = "エラーが発生しました。"
                end

                return error
        end
    end

    # showのリクエスト
    def self.show_search(id)

        # ぐるなびAPIにリクエスト
        uri = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
        access_key = ENV['GNAVI_API_KEY']
        url = uri << "?keyid=" << access_key << "&id=" << id

        require 'open-uri'
        require 'net/http'
        require 'json'
        require 'active_support'
        require 'active_support/core_ext'

        url = URI.encode url
        re_url = URI.parse(url)
        json = Net::HTTP.get(re_url)
        hash = JSON.parse(json)
        only_shop = []

        # idの検索により、基本的に一つの情報が取り出される（each処理は必須）
        if hash.has_key?("rest")
            hash["rest"].each do |shop|
                only_shop.push({
                    name: shop["name"],
                    name_kana: shop["name_kana"],
                    category: shop["category"],
                    address: shop["address"],
                    image1: shop["image_url"]["shop_image1"],
                    image2: shop["image_url"]["shop_image2"],
                    pr_short: shop["pr"]["pr_short"],
                    pr_long: shop["pr"]["pr_long"],
                    opentime: shop["opentime"],
                    holiday: shop["holiday"],
                    tel: shop["tel"]
                })
                return only_shop
            end
        # エラーが返ってきた処理
        elsif hash.has_key?("error")
                if hash["error"]["code"] == "400"
                    error = "不正なパラメーターが指定されました。"
                elsif hash["error"]["code"] == "401"
                    error = "不正なアクセス（認証エラー）です。"
                elsif hash["error"]["code"] == "404"
                    error = "指定された店舗の情報が存在しません。"
                elsif hash["error"]["code"] == "405"
                    error = "不正なアクセスです。"
                elsif hash["error"]["code"] == "429"
                    error = "リクエスト可能な上限回数を超過しました。"
                elsif hash["error"]["code"] == "500"
                    error = "処理中にエラーが発生しました。"
                else
                    error = "エラーが発生しました。"
                end
                return error
        end
    end
end