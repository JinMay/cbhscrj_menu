Rails.application.routes.draw do
    # 크롤링할 주소
    # crontab 으로 curl 자동화 할 예정
    root 'menu#crawling'

    get 'keyboard' => 'menu#keyboard'
    post 'message' => 'menu#answer'
    post 'friend' => 'menu#friend'
    delete 'friend/:user_key' => 'menu#friend'
    delete 'chat_room/:user_key' => 'menu#chat_room'

end
