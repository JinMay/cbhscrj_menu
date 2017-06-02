require 'nokogiri'
require 'open-uri'

class MenuController < ApplicationController
    # 식단 크롤링
    def crawling
        Crj.delete_all

        crj_url = 'http://www.cbhscrj.kr/food/list.do?menuKey=39'
        main = 'https://dorm.chungbuk.ac.kr/main/main.php'

        crj_data = Nokogiri::HTML(open(crj_url))
        main_data = Nokogiri::HTML(open(main))

        crj_menus = crj_data.css('div.food_week_box ul.on')
        @main_menus = main_data.css('li#tab1c1 > ul.ul > li:nth-child(1)')

        Crj.create(
            :breakfast => crj_menus.css('li p')[0].text.gsub(',', '\n'),
            :lunch => crj_menus.css('li p')[1].text.gsub(',', '\n'),
            :dinner => crj_menus.css('li p')[2].text.gsub(',', '\n')
        )

        Main.create(
            :morning => meal.css('div.foodmenu1 li').to_s.gsub('<li>', '').gsub('</li>', ", ").strip,
            :lunch => meal.css('div.foodmenu2 li').to_s.gsub('<li>', '').gsub('</li>', ", ").strip,
            :dinner => meal.css('div.foodmenu3 li').to_s.gsub('<li>', '').gsub('</li>', ", ").strip
        )
    end


    # 채팅방 들어갈때 출력되는 기본 키보드
    def keyboard
        default_keyboard = {
            "type": "buttons",
            # "buttons": ["아침", "점심", "저녁"]
            "buttons": ["청람재", "본관", "양진재", "양성재"],
        }

        render json: default_keyboard
    end


    # 청람재의 아침/점심/저녁 식단을 리턴
    def get_menu(dorm)
        if dorm == "청람재"
            tday = Crj.all[0]
        elsif dorm == "본관"
            tday = Main.all[0]

        m = tday.morning
        l = tday.lunch
        d = tday.dinner

        return "[아침]\n#{m}\n\n[점심]\n#{l}\n\n[저녁]\n#{d}"


    end


    # request에 대한 response 구현
    def answer
        received_data = JSON.parse(request.raw_post)
        eating_time = received_data["content"]

        render json: {
                "message": {
                # "text": "오늘의 청람재 " + input_data + "식단 입니다"
                "text": "오늘의 " + eating_time + "식단 입니다 \n\n" + get_menu(eating_time)
            },
                "keyboard": {
                "type": "buttons",
                "buttons": ["청람재", "본관", "양진재", "양성재"],
            }
        }
    end


    # 친구 추가하고 차단하는 거 구현
    def friend
        if request.method == 'POST'
            render status: 200
        elsif request.method == 'DELETE'
            render status: 200
        end
    end


    # 채팅방 나갔을 때 구현
    def chat_room
        if request.method == 'DELETE'
            render status: 200
        end
    end
end
