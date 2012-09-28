request = require('request')
fs = require 'fs'
jsdom = require 'jsdom'
jquery = fs.readFileSync("#{__dirname}/lib/jquery-1.7.1.min.js").toString()
_ = require 'underscore'
stringUtil = require "./string_util.js"

exports.scrape = (done) ->
  fws =
    Backbone: "https://github.com/documentcloud/backbone"
    Spine: "https://github.com/maccman/spine"
    Emberjs: "https://github.com/emberjs/ember.js"
    Angularjs: "https://github.com/angular/angular.js"
    Knockoutjs: "https://github.com/SteveSanderson/knockout"
    YUI3: "https://github.com/yui/yui3"
    Batmanjs: "https://github.com/Shopify/batman"
    Agilityjs: "https://github.com/arturadib/agility"
    Knockbackjs: "https://github.com/kmalakoff/knockback"
    jQuery: "https://github.com/jquery/jquery"
    Maria: "https://github.com/petermichaux/maria"
    Canjs: "https://github.com/jupiterjs/canjs"
    Meteor: "https://github.com/meteor/meteor"
    Derby: "https://github.com/codeparty/derby/"
    Sammy: "https://github.com/quirkey/sammy"
    Stapes: "https://github.com/hay/stapes"
    JavascriptMVC: "https://github.com/jupiterjs/javascriptmvc"
    Epitome: "https://github.com/DimitarChristoff/Epitome"
    Somajs: "https://github.com/somajs/somajs"
    Fidel: "https://github.com/jgallen23/fidel"
    Olives: "https://github.com/flams/olives"
    PlastronJS: "https://github.com/rhysbrettbowen/PlastronJS"
    Dijon: "https://github.com/creynders/dijon-framework"
    rAppidjs: "https://github.com/it-ony/rAppid.js"
    o_O: "https://github.com/weepy/o_O"

  fwNames = (name for name, url of fws)
  index = 0
  surveyResults = []
  func = ->
    if index >= fwNames.length
      done(surveyResults)
      return
    name = fwNames[index]
    index++
    url = fws[name]
    fetch url, (err, $, isScraped) ->
      starNum = $(".js-social-count").text().replace(",", "")
      forkNum = $($(".social-count")[1]).text().replace(",", "")
      surveyResults.push
        name: name
        starNum: starNum
        forkNum: forkNum
      func()
  func()

fetch = (url, callback) ->
  try
    request {uri:url, encoding:"binary"}, (err, response) ->
      # bodyをjQueryでパースして文字コードを把握し、文字コードをUTF8に変換したあと
      # またjsdomを使ってjQueryオブジェクトを生成する
      jsdom.env html: response.body, src: [jquery], done:(err, window) ->
        if err then throw err
        response.body = stringUtil.toUtf8(response.body, window.$)
        window.close()
        jsdom.env html: response.body, src: [jquery], done:(err, window) ->
          callback(null, window.$)
          window.close()
  catch e
    console.error e