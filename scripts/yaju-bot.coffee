# Description:
#   meigen.txtを読み込み、ランダムに返答
#
# Configuration:
#   None
# 
# Commands:
#   @hubot-name meigen - 名言を垂れ流す
#   @hubot-name meigen-all - 名言を全て解放
#   @hubot-name news - yahooニュースを取得
#   @hubot-name delay - 電車の遅延状況を取得
#   @hubot-name pwd - カレントディレクトリのパス取得
#   @hubot-name image me [検索ワード] | animate me [検索ワード] - 画像検索
#   roll - サイコロを降る, 1-100の乱数を返す
#   parrot-party (pallot-party) - ひ　み　つ
#   その他もあります
#   使用例: @yaju news (BOTの名前がyajuの場合)
#
# Author:
#   tikeda <t.i.motacapla@gmai.com>
# 
# Useful Commands:
#   msg.send "@#{msg.message.user.name}, foo bar."
# 

cron = require('cron').CronJob
path = require('path')
cheerio = require('cheerio-httpcli')
exec = require('child_process').exec
msgs = require('/mnt/meigen.json')

module.exports = (robot) ->
        #淫夢語録
        robot.respond /meigen(.*)/i, (msg) ->                
                if msg.match[1] == '-all'
                        msg.send "@#{msg.message.user.name} *全名言リスト* \n #{msgs}"
                else                                
                        message = msgs[Math.floor(Math.random() * msgs.length)]
                        msg.send "#{message}"
        #ニュース                       
        robot.respond /news/i, (msg) ->
                msg.send "本日のニュース: (https://news.yahoo.co.jp/)"                
                url = 'http://www.yahoo.co.jp/'
                cheerio.fetch url, {}, (err, $, res)->
                        $('ul.emphasis > li > a').each () -> 
                                news = $(this).text()
                                length = news.length - 1
                                if news[length] == 'W' and news[length-1] == 'E'  and news[length-2] == 'N'
                                        length = length - 3
                                if news[length] == '真' and news[length-1] == '写'
                                        length = length - 2
                                msg.send "- #{news[0..length]}"

        #電車遅延
        robot.respond /delay/i, (msg) ->
                baseUrl = 'https://transit.yahoo.co.jp/traininfo/area/4/'
                cheerio.fetch baseUrl, {}, (err, $, res) ->
                        #console.log $('.elmTblLstLine.trouble')
                        if $('.elmTblLstLine.trouble').find('a').length == 0
                                msg.send "事故や遅延情報はありません！"
                                return
                        $('.elmTblLstLine.trouble a').each ->
                                url = $(this).attr('href')
                                cheerio.fetch url, (err, $, res) ->
                                        title = "◎ #{$('h1').text()} #{$('.subText').text()}"
                                        result = ""
                                        $('.trouble').each ->
                                                trouble = $(this).text().trim()
                                                result += "- " + trouble + "\r\n"
                                        msg.send "#{title}\r\n#{result}"
        #for debug
        robot.respond /pwd/i, (msg) ->                                      
                msg.send path.resolve(process.cwd());

        #roll a dice!
        robot.hear /roll/i, (msg) ->
                max = 100
                min = 1
                range = Math.floor(Math.random() * (max - min) + min)
                msg.send "[#{min}-#{max}]: #{range}"

        #for party
        robot.hear /parrot(.*)|pallot(.*)/i, (msg) ->
                if msg.match[1] == '-party' or msg.match[2] == '-party'
                        msg.send ":pallot::parrot2::parrot3::parrot4::parrot5::parrot6::parrot7::pallot:\n:pallot:        Parrot  Party        :pallot:\n:pallot::parrot2::parrot3::parrot4::parrot5::parrot6::parrot7::pallot:"
                else
                        msg.send ":pallot:"

        #きたないやつ
        robot.hear /野獣先輩/i, (msg) ->
                url = [
                        "https://img.gifmagazine.net/gifmagazine/images/2308226/original.gif",
                        "https://img.gifmagazine.net/gifmagazine/images/1296405/original.gif",
                        "https://gazou.futabahokanko.com/2016/06/c54bdc5439837f41518626f6e81ba440.gif"
                        ]                        
                msg.send url[Math.floor(Math.random() * url.length)]

        robot.hear /アクメ/i, (msg) ->
                url = ["http://i.imgur.com/lkAhw.gif"]
                msg.send url[Math.floor(Math.random() * url.length)]

