class RestaurantsController < ApplicationController

    def search

    end

    def index
        # 情報の整理
        lat = params[:lat]
        lng = params[:lng]
        range = params[:radius]
        # jsonリクエストの準備
        require 'open-uri'
        require 'net/http'
        require 'json'
        require 'active_support'
        require 'active_support/core_ext'

        uri = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
        access_key = "e1a2b74634545386f827f1b357b5f6b9"
        url = uri << "?keyid=" << access_key << "&hit_per_page=100"  << "&latitude=" << lat << "&longitude=" << lng << "&range=" << range
        # 各パラメータが送られていたらURLを上書き
        if params[:freeword]
            url = url << "&freeword=" << params[:freeword]
        end

        if params[:no_smoking]
            url = url << "&no_smoking=" << params[:no_smoking]
        end

        if params[:card]
            url = url << "&card=" << params[:card]
        end

        if params[:bottomless_cup]
            url = url << "&bottomless_cup=" << params[:bottomless_cup]
        end

        if params[:buffet]
            url = url << "&buffet=" << params[:buffet]
        end

        if params[:parking]
            url = url << "&parking=" << params[:parking]
        end

        if params[:wifi]
            url = url << "&wifi=" << params[:wifi]
        end

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
        # エラーが返ってきた処理
        elsif hash.has_key?("error")

                if hash["error"].first["code"] == 400
                    @error = "不正なパラメーターが指定されました。"
                elsif hash["error"].first["code"] == 401
                    @error = "不正なアクセス（認証エラー）です。"
                elsif hash["error"].first["code"] == 404
                    @error = "指定された店舗の情報が存在しません。"
                elsif hash["error"].first["code"] == 405
                    @error = "不正なアクセスです。"
                elsif hash["error"].first["code"] == 429
                    @error = "リクエスト可能な上限回数を超過しました。"
                elsif hash["error"].first["code"] == 500
                    @error = "処理中にエラーが発生しました。"
                else
                    @error = "エラーが発生しました。"
                end

                render :search
        end

        @shops = Kaminari.paginate_array(shops).page(params[:page]).per(10)

    end
    
    def show
        id = params[:id]

        require 'open-uri'
        require 'net/http'
        require 'json'
        require 'active_support'
        require 'active_support/core_ext'

        # ぐるなびAPIにリクエスト
        uri = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
        access_key = ENV['GNAVI_API_KEY']
        url = uri << "?keyid=" << access_key << "&id=" << id
        url = URI.encode url
        re_url = URI.parse(url)
        json = Net::HTTP.get(re_url)
        hash = JSON.parse(json)
        @shop = []

        # idの検索により、基本的に一つの情報が取り出される（each処理は必須）
        if hash.has_key?("rest")
            hash["rest"].each do |shop|
                @shop.push({
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
            end
        # エラーが返ってきた処理
        elsif hash.has_key?("error")
                if hash["error"]["code"] == "400"
                    @error = "不正なパラメーターが指定されました。"
                elsif hash["error"]["code"] == "401"
                    @error = "不正なアクセス（認証エラー）です。"
                elsif hash["error"]["code"] == "404"
                    @error = "指定された店舗の情報が存在しません。"
                elsif hash["error"]["code"] == "405"
                    @error = "不正なアクセスです。"
                elsif hash["error"]["code"] == "429"
                    @error = "リクエスト可能な上限回数を超過しました。"
                elsif hash["error"]["code"] == "500"
                    @error = "処理中にエラーが発生しました。"
                else
                    @error = "エラーが発生しました。"
                end
        end

        gon.address = @shop.first[:address]

    end
    
end
