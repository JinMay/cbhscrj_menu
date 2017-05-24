require 'nokogiri'
require 'open-uri'

class MenuController < ApplicationController
     # 청람재 식단 크롤링하는 기능 구현
     # 나중에 학교기숙사 식단 크롤링 하는 것도 동일한 함수내에 구현 할 예정
     # crontab으로 매일 실행
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
    end


    # 채팅방 들어갈때 출력되는 기본 키보드
    def keyboard
        default_keyboard = {
            "type": "buttons",
            "buttons": ["아침", "점심", "저녁"]
        }

        render json: default_keyboard
    end


    # 청람재의 아침/점심/저녁 식단을 리턴
    def get_menu(time)
        menu = Crj.all[0]

        if time == "아침"
            return menu.breakfast
        elsif time == "점심"
            return menu.lunch
        elsif time == "저녁"
            return menu.dinner
        end
    end


    # request에 대한 response 구현
    def answer
        received_data = JSON.parse(request.raw_post)
        eating_time = received_data["content"]

        answer = {
            "message": {
                 # "text": "오늘의 청람재 " + input_data + "식단 입니다"
                "text": "오늘의 청람재 " + eating_time + "식단 입니다 \n\n" + get_menu(eating_time)
            },
            "keyboard": {
                "type": "buttons",
                "buttons": ["아침", "점심", "저녁"]
            }
        }

        render json: answer
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
