fwScraper = require "./fw_scraper.js"
fwScraper.scrape (results) ->
  console.log "framework name,# of stars,# of forks"
  for result in results
    console.log "#{result.name},#{result.starNum},#{result.forkNum}"
