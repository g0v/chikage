#!/usr/bin/env lsc
require! {
  'fs'
  'path'
  'split'
  'kage.json/lib/utils': { parseLine }
  'tarball-extract': 'tarball'
  'redis'
}

const config = rootPath: path.resolve __dirname
const { REDIS_IP, REDIS_PORT } = process.env

dump = (done) ->
  client = redis.create-client +REDIS_PORT, REDIS_IP
  client.on 'error' -> console.log it

  glyph-count = 0
  count = 0

  jsonPath = path.resolve config.rootPath, 'json'
  if not fs.existsSync jsonPath
    fs.mkdirSync jsonPath

  url = 'http://glyphwiki.org/dump.tar.gz'
  err, result <- tarball.extractTarballDownload do
    url
    "#{path.resolve config.rootPath, 'dump.tar.gz'}"
    "#{path.resolve config.rootPath, 'data'}"
    {}
  fs.createReadStream path.resolve config.rootPath, 'data', 'dump_newest_only.txt'
    .pipe split!
    .on \data (line) ->
      if line is /.*name.*related.*data/ then return

      if line is /^[-+]+$/
        count := 0
        return

      if line is /\((\d+) 行\)/
        total = +RegExp.$1
        if total isnt count
          throw new Error "glyph number mismatched: #count/#total"
        client.quit!
        return done count

      { id, raw }:glyph = parseLine line
      delete glyph.raw

      if not id then return

      client.set "#{id}", raw
      client.set "#{id}.json", (JSON.stringify glyph)

      ++count

module.exports = dump
