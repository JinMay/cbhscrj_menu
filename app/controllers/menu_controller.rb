require 'nokogiri'
require 'open-uri'

class MenuController < ApplicationController
    def crawling
        Crj.delete_all

        crj_url = 'http://www.cbhscrj.kr/food/list.do?menuKey=39'
        crj_data = Nokogiri::HTML(open(crj_url))
        crj_menus = crj_data.css('div.food_week_box ul.on')

        Crj.create(
            :breakfast => crj_menus.css('li p')[0].text,
            :lunch => crj_menus.css('li p')[1].text,
            :dinner => crj_menus.css('li p')[2].text
        )

        all = Crj.all
        render json: all
    end
end
